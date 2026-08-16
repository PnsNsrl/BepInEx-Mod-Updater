# ============================================================
#  PEAK ThunderStore Mod Updater by PonosNasral
#  Проверяет и обновляет моды из https://thunderstore.io/c/peak/
#  Запуск -> автопроверка -> при наличии устаревших модов
#  спрашивается: обновить? (Да - 1, Нет - 2)
# ============================================================

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'
$exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
if ($exePath -and $exePath.EndsWith('.exe') -and ((Split-Path -Leaf $exePath) -notmatch 'powershell|pwsh')) {
    $PluginsDir = Split-Path -Parent $exePath
} elseif ($PSCommandPath) {
    $PluginsDir = Split-Path -Parent $PSCommandPath
} else {
    $PluginsDir = $PSScriptRoot
}

# --- Проверка: программа должна лежать в PEAK\BepInEx\plugins ---
$parentName = Split-Path -Leaf (Split-Path -Parent $PluginsDir)
$gameExe = Join-Path (Split-Path -Parent (Split-Path -Parent $PluginsDir)) 'PEAK.exe'
if ($parentName -ne 'BepInEx' -or -not (Test-Path -LiteralPath $gameExe)) {
    Write-Host 'ОШИБКА: программа находится не в папке игры!' -ForegroundColor Red
    Write-Host "Текущее расположение: $PluginsDir" -ForegroundColor Red
    Write-Host 'Переместите программу в папку PEAK\BepInEx\plugins и запустите снова.' -ForegroundColor Red
    try { [void](Read-Host 'Нажмите Enter для выхода') } catch { }
    exit 1
}

# --- Лог-файл (полный отчёт каждого запуска) ---
$LogFile = Join-Path $PluginsDir 'updater_log.txt'
try { Start-Transcript -Path $LogFile -Append | Out-Null } catch { }

# --- Center console window on screen (WinAPI) ---
try {
    Add-Type -AssemblyName System.Windows.Forms
    $cs = '[DllImport("user32.dll")] public static extern IntPtr GetConsoleWindow(); [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect); [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int x, int y, int w, int h, bool repaint); public struct RECT { public int Left, Top, Right, Bottom; } public struct COORD { public short X; public short Y; } [DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int nStdHandle); [DllImport("kernel32.dll")] public static extern bool SetConsoleScreenBufferSize(IntPtr hConsoleOutput, COORD dwSize);'
    Add-Type -Name Win32 -Namespace Native -MemberDefinition $cs
    # Крупный шрифт консоли (WinAPI SetCurrentConsoleFontEx)
    if (-not [Console]::IsOutputRedirected) {
        try {
            $cs2 = '[StructLayout(LayoutKind.Sequential)] public struct CONSOLE_FONT_INFO_EX { public uint cbSize; public uint nFont; public short dwFontSizeX; public short dwFontSizeY; public int FontFamily; public int FontWeight; [MarshalAs(UnmanagedType.ByValTStr, SizeConst=32)] public string FaceName; } [DllImport("kernel32.dll", SetLastError=true)] public static extern bool SetCurrentConsoleFontEx(IntPtr hOut, bool bMax, ref CONSOLE_FONT_INFO_EX lp); [DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int nStdHandle);'
            Add-Type -Name Font -Namespace Native -MemberDefinition $cs2
            $fi = New-Object Native.Font+CONSOLE_FONT_INFO_EX
            $fi.FaceName = 'Consolas'
            $fi.cbSize = [uint32][System.Runtime.InteropServices.Marshal]::SizeOf($fi)
            $fi.dwFontSizeX = 14
            $fi.dwFontSizeY = 28
            $fi.FontFamily = 54
            $fi.FontWeight = 700
            $hOut = [Native.Font]::GetStdHandle(-11)
            [void][Native.Font]::SetCurrentConsoleFontEx($hOut, $false, [ref]$fi)
            Start-Sleep -Milliseconds 300
        } catch { }
    }
    # Квадратное окно 100x45 через mode.com (работает и в ps2exe)
    $WinW = 100
    if (-not [Console]::IsOutputRedirected) {
        try { & mode.com con cols=100 lines=30 | Out-Null } catch { }
        # Буфер прокрутки 3000 строк (иначе mode.com делает буфер = окну и листать нельзя)
        try {
            $buf = New-Object Native.Win32+COORD
            $buf.X = 100; $buf.Y = 3000
            [void][Native.Win32]::SetConsoleScreenBufferSize([Native.Win32]::GetStdHandle(-11), $buf)
        } catch { }
        Start-Sleep -Milliseconds 300
    }
    $hWnd = [Native.Win32]::GetConsoleWindow()
    if ($hWnd -ne [IntPtr]::Zero) {
        $b = New-Object Native.Win32+RECT
        [void][Native.Win32]::GetWindowRect($hWnd, [ref]$b)
        $sw = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
        $sh = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
        [void][Native.Win32]::MoveWindow($hWnd, [int](($sw - ($b.Right - $b.Left) - 40) / 2), [int](($sh - ($b.Bottom - $b.Top) - 10) / 2), ($b.Right - $b.Left + 40), ($b.Bottom - $b.Top + 10), $true)
    }
} catch { }

if (-not [Console]::IsOutputRedirected) { Clear-Host }

# --- Заголовок окна консоли (после mode.com, иначе он сбрасывает титул на путь) ---
try { $Host.UI.RawUI.WindowTitle = 'PEAK Mod Updater by PonosNasral' } catch { }
try {
    Add-Type -Name Title -Namespace Native -MemberDefinition '[DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)] public static extern bool SetConsoleTitleW(string lpConsoleTitle);'
    [void][Native.Title]::SetConsoleTitleW('PEAK Mod Updater by PonosNasral')
} catch { }

$ApiUrl     = 'https://thunderstore.io/c/peak/api/v1/package/'
$BackupDir  = Join-Path $PluginsDir '.mod_backups'
$MaxRetries = 10

# --- Сравнение версий (semver-подобное: 1.2.10 > 1.2.9) ---
function Compare-Versions([string]$a, [string]$b) {
    $pa = ($a -split '[-+]')[0] -split '\.' | ForEach-Object { [int]($_ -replace '\D', '0') }
    $pb = ($b -split '[-+]')[0] -split '\.' | ForEach-Object { [int]($_ -replace '\D', '0') }
    $max = [Math]::Max($pa.Count, $pb.Count)
    for ($i = 0; $i -lt $max; $i++) {
        $va = if ($i -lt $pa.Count) { $pa[$i] } else { 0 }
        $vb = if ($i -lt $pb.Count) { $pb[$i] } else { 0 }
        if ($va -lt $vb) { return -1 }
        if ($va -gt $vb) { return 1 }
    }
    return 0
}

# --- Самопроверка Compare-Versions (тесты сравнения версий) ---
$versionTests = @(
    @('1.2.10', '1.2.9',  1),
    @('1.0',    '1.0.1', -1),
    @('1.0.0',  '1.0.0',  0),
    @('2.0',    '10.0',  -1),
    @('1.0.0-beta', '1.0.0', 0)
)
foreach ($vt in $versionTests) {
    $r = Compare-Versions $vt[0] $vt[1]
    if ($r -ne $vt[2]) {
        Write-Host "ОШИБКА САМОПРОВЕРКИ: Compare-Versions '$($vt[0])' vs '$($vt[1])' = $r (ожидалось $($vt[2]))" -ForegroundColor Red
        try { [void](Read-Host 'Нажмите Enter для выхода') } catch { }
        exit 1
    }
}

Write-Host '=== PEAK Mod Updater (ThunderStore) by PonosNasral ===' -ForegroundColor Cyan

# --- Загружаем каталог ThunderStore (до 10 попыток) ---
Write-Host "`nПолучаю каталог модов PEAK с ThunderStore..." -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$catalog = $null
for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
    try {
        $catalog = Invoke-RestMethod -Uri $ApiUrl -TimeoutSec 90
        break
    } catch {
        Write-Host "Попытка ${attempt} из ${MaxRetries}. $($_.Exception.Message)" -ForegroundColor DarkYellow
        if ($attempt -lt $MaxRetries) { Start-Sleep -Seconds 5 }
    }
}
if (-not $catalog) {
    Write-Host "ОШИБКА: не удалось получить каталог ThunderStore после ${MaxRetries} попыток." -ForegroundColor Red
    try { [void](Read-Host "Нажмите Enter для выхода") } catch { }; exit 1
}

# Индексы: по имени мода и по полному имени author-name
$byName      = @{}
$byFullName  = @{}
foreach ($p in $catalog) {
    $key = $p.name.ToLower()
    if (-not $byName.ContainsKey($key)) { $byName[$key] = $p }
    $byFullName[$p.full_name.ToLower()] = $p
}
# Индекс версий по uuid (для разрешения зависимостей)
$byUuid = @{}
foreach ($p in $catalog) {
    foreach ($v in $p.versions) { $byUuid[$v.uuid4] = $p.full_name }
}
Write-Host ("Найдено модов в каталоге: {0}" -f $catalog.Count) -ForegroundColor Gray

# --- Сканируем установленные моды ---
$installed = @()
$skipped   = @()

Get-ChildItem -LiteralPath $PluginsDir -Directory | Where-Object { $_.Name -ne '.mod_backups' } | ForEach-Object {
    $dir = $_
    $manifestPath = Join-Path $dir.FullName 'manifest.json'
    if (-not (Test-Path -LiteralPath $manifestPath)) {
        $hasFiles = @(Get-ChildItem -LiteralPath $dir.FullName -Recurse -File -ErrorAction SilentlyContinue).Count -gt 0
        if ($hasFiles) {
            $skipped += $dir.Name
        } else {
            $skipped += "$($dir.Name) (пустая папка — возможно, битая установка)"
        }
        return
    }
    try {
        $m = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        $skipped += "$($dir.Name) (битый manifest.json)"
        return
    }
    $installed += [PSCustomObject]@{
        Dir     = $dir
        Name    = $m.name
        Version = $m.version_number
    }
}

Write-Host ("Установлено модов ThunderStore: {0}" -f $installed.Count) -ForegroundColor Gray

# --- «Голые» .dll напрямую в plugins (не в папках модов) ---
$dllMods = @(Get-ChildItem -LiteralPath $PluginsDir -File -Filter '*.dll' -ErrorAction SilentlyContinue)

# --- Сравниваем версии ---
$upToDate = @(); $outdated = @(); $notFound = @()

foreach ($mod in $installed) {
    $pkg = $null
    # Сначала ищем по author-name из имени папки
    $folderKey = ($mod.Dir.Name -replace '-\d+(\.\d+)*(-[\w.]+)?$', '').ToLower()
    if ($byFullName.ContainsKey($folderKey)) { $pkg = $byFullName[$folderKey] }
    # Затем по имени мода из manifest
    if (-not $pkg -and $byName.ContainsKey($mod.Name.ToLower())) { $pkg = $byName[$mod.Name.ToLower()] }

    if (-not $pkg) {
        $notFound += $mod
    }
    elseif ((Compare-Versions $mod.Version $pkg.versions[0].version_number) -ge 0) {
        $upToDate += $mod
    }
    else {
        $outdated += [PSCustomObject]@{
            Mod    = $mod
            Pkg    = $pkg
            NewVer = $pkg.versions[0].version_number
        }
    }
}

# --- Полный отчёт ---
Write-Host "`n--- РЕЗУЛЬТАТ ПРОВЕРКИ ---" -ForegroundColor Cyan
foreach ($m in $upToDate) {
    Write-Host ("  [OK]        {0} {1}" -f $m.Name, $m.Version) -ForegroundColor Green
}
foreach ($o in $outdated) {
    Write-Host ("  [UPDATE]    {0}: {1}  ->  {2}" -f $o.Mod.Name, $o.Mod.Version, $o.NewVer) -ForegroundColor Yellow
}
foreach ($m in $notFound) {
    Write-Host ("  [NOT FOUND] {0} {1} (нет на ThunderStore, пропущен)" -f $m.Name, $m.Version) -ForegroundColor DarkYellow
}
# --- Проверка зависимостей обновляемых модов ---
$missingDeps = @()
foreach ($o in $outdated) {
    foreach ($depUuid in @($o.Pkg.versions[0].dependencies)) {
        $depFull = $byUuid[$depUuid]
        if (-not $depFull) { continue }
        $depKey = $depFull.ToLower()
        $depNameOnly = $depFull.Substring($depFull.IndexOf('-') + 1).ToLower()
        $haveIt = $false
        foreach ($m in $installed) {
            $fk = ($m.Dir.Name -replace '-\d+(\.\d+)*(-[\w.]+)?$', '').ToLower()
            if ($fk -eq $depKey -or $m.Name.ToLower() -eq $depNameOnly) { $haveIt = $true; break }
        }
        if (-not $haveIt -and $missingDeps -notcontains $depFull) { $missingDeps += $depFull }
    }
}
if ($missingDeps.Count -gt 0) {
    Write-Host "`nНедостающие зависимости (для обновляемых модов):" -ForegroundColor Yellow
    foreach ($d in $missingDeps) {
        Write-Host ("  [DEP] {0} — не установлен" -f $d) -ForegroundColor Yellow
    }
    Write-Host '  Установите их с ThunderStore, иначе мод может не работать.' -ForegroundColor DarkYellow
}
if ($dllMods.Count -gt 0) {
    Write-Host "`n.dll-файлы напрямую в plugins (версию определить нельзя):" -ForegroundColor Yellow
    foreach ($d in $dllMods) {
        Write-Host ('  [DLL] {0}' -f $d.Name) -ForegroundColor Yellow
    }
    Write-Host '  Совет: распакуйте zip мода в plugins папкой, а не кидайте .dll — тогда скрипт будет работать' -ForegroundColor DarkYellow
}
if ($skipped.Count -gt 0) {
    Write-Host "`nПропущены (не ThunderStore-папки):" -ForegroundColor DarkGray
    foreach ($s in $skipped) { Write-Host ("  - {0}" -f $s) -ForegroundColor DarkGray }
}
Write-Host ("`nИтог: актуальных — {0}, к обновлению — {1}, не найдено — {2}" -f $upToDate.Count, $outdated.Count, $notFound.Count) -ForegroundColor Cyan

# --- Если обновлять нечего — выходим ---
if ($outdated.Count -eq 0) {
    Write-Host "`nВсе моды актуальны. Обновление не требуется." -ForegroundColor Green

# --- Предупреждение: игра запущена ---
if (Get-Process -Name 'PEAK' -ErrorAction SilentlyContinue) {
    Write-Host 'ВНИМАНИЕ: Игра PEAK запущена. Рекомендую выйти из игры!' -ForegroundColor Yellow
}
    Write-Host "Спасибо за использование моего скрипта! По желанию подпишитесь на канал PonosNasral" -ForegroundColor Magenta
    try { [void](Read-Host "Нажмите Enter для выхода") } catch { }; exit 0
}

# --- Спрашиваем, обновлять ли устаревшие моды ---
$choice = 0
while ($choice -ne 1 -and $choice -ne 2) {
    $answer = Read-Host 'Хотите ли вы обновить данные моды? (Да - 1, Нет - 2)'
    if ($answer -eq '1') { $choice = 1 }
    elseif ($answer -eq '2') { $choice = 2 }
    else { Write-Host 'Неверный ввод. Введите 1 или 2.' -ForegroundColor Red }
}
if ($choice -eq 2) {
    Write-Host "`nОбновление отменено пользователем." -ForegroundColor Cyan
    Write-Host "Спасибо за использование моего скрипта! По желанию подпишитесь на канал PonosNasral" -ForegroundColor Magenta
    try { [void](Read-Host "Нажмите Enter для выхода") } catch { }; exit 0
}

# --- Проверка: не запущена ли игра (файлы .dll будут заблокированы) ---
$gameProc = Get-Process -Name 'PEAK' -ErrorAction SilentlyContinue
if ($gameProc) {
    Write-Host "`nВНИМАНИЕ: игра PEAK сейчас запущена!" -ForegroundColor Red
    Write-Host 'Файлы модов заблокированы, обновление может завершиться с ошибками.' -ForegroundColor Red
    $choice = 0
    while ($choice -ne 1 -and $choice -ne 2) {
        $answer = Read-Host 'Всё равно продолжить обновление? (Да - 1, Нет - 2)'
        if ($answer -eq '1') { $choice = 1 }
        elseif ($answer -eq '2') { $choice = 2 }
        else { Write-Host 'Неверный ввод. Введите 1 или 2.' -ForegroundColor Red }
    }
    if ($choice -eq 2) {
        Write-Host "`nОбновление отменено пользователем. Закройте игру и запустите скрипт снова." -ForegroundColor Cyan
        Write-Host "Спасибо за использование моего скрипта! По желанию подпишитесь на канал PonosNasral" -ForegroundColor Magenta
        try { [void](Read-Host "Нажмите Enter для выхода") } catch { }; exit 0
    }
    Write-Host 'Продолжаю по решению пользователя...' -ForegroundColor DarkYellow
}

# --- Обновление ---
Write-Host ("`nНачинаю обновление {0} мод(ов)..." -f $outdated.Count) -ForegroundColor Cyan
if (-not (Test-Path -LiteralPath $BackupDir)) { New-Item -ItemType Directory -Path $BackupDir | Out-Null }

$success = 0; $failed = @()

foreach ($o in $outdated) {
    $mod    = $o.Mod
    $owner  = $o.Pkg.owner
    $name   = $o.Pkg.name
    $newVer = $o.NewVer
    $newDirName = "{0}-{1}-{2}" -f $owner, ($name -replace ' ', '_'), $newVer
    $newDirPath = Join-Path $PluginsDir $newDirName
    $dlUrl      = $o.Pkg.versions[0].download_url
    $backupPath = $null
    $tmp        = $null

    Write-Host ("`n>>> {0}: {1} -> {2}" -f $name, $mod.Version, $newVer) -ForegroundColor White

    try {
        # Если целевая папка уже существует (остаток после прошлого сбоя) — удаляем
        if (Test-Path -LiteralPath $newDirPath) {
            Write-Host "    Целевая папка уже существует, удаляю остаток: $newDirName" -ForegroundColor DarkYellow
            Remove-Item -LiteralPath $newDirPath -Recurse -Force
        }

        # Скачиваем во временную папку (до 10 попыток)
        $tmp = Join-Path $env:TEMP ("peakmod_" + [Guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tmp | Out-Null
        $zipPath = Join-Path $tmp 'mod.zip'

        $downloaded = $false
        for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
            try {
                Write-Host "    Скачиваю (попытка ${attempt})..." -ForegroundColor Gray
                Invoke-WebRequest -Uri $dlUrl -OutFile $zipPath -TimeoutSec 120 -UseBasicParsing
                $downloaded = $true
                break
            } catch {
                Write-Host "    Попытка ${attempt} из ${MaxRetries} не удалась: $($_.Exception.Message)" -ForegroundColor DarkYellow
                if ($attempt -lt $MaxRetries) { Start-Sleep -Seconds 5 }
            }
        }
        if (-not $downloaded) { throw 'не удалось скачать архив' }

        # Проверка размера файла (сверка с данными ThunderStore)
        $expectedSize = $o.Pkg.versions[0].filesize
        $actualSize = (Get-Item -LiteralPath $zipPath).Length
        if ($expectedSize -and $actualSize -ne $expectedSize) {
            throw "размер скачанного файла не совпадает (ожидалось $expectedSize байт, получено $actualSize байт)"
        }

        # Проверка целостности: файл должен быть zip (сигнатура PK)
        $fs = [IO.File]::OpenRead($zipPath)
        try {
            $magic = New-Object byte[] 2
            [void]$fs.Read($magic, 0, 2)
        } finally { $fs.Close() }
        if ($magic[0] -ne 0x50 -or $magic[1] -ne 0x4B) {
            throw 'скачанный файл не является zip-архивом'
        }

        Write-Host "    Распаковываю..." -ForegroundColor Gray
        $extractDir = Join-Path $tmp 'extracted'
        Expand-Archive -LiteralPath $zipPath -DestinationPath $extractDir

        # Проверяем, что в архиве есть manifest.json
        if (-not (Test-Path -LiteralPath (Join-Path $extractDir 'manifest.json'))) {
            throw 'в архиве нет manifest.json'
        }

        # Бэкап старой папки
        $backupPath = Join-Path $BackupDir ("{0}_{1}" -f $mod.Dir.Name, (Get-Date -Format 'yyyyMMdd_HHmmss'))
        Write-Host "    Бэкап: $backupPath" -ForegroundColor Gray
        Move-Item -LiteralPath $mod.Dir.FullName -Destination $backupPath

        # Устанавливаем новую версию
        Move-Item -LiteralPath $extractDir -Destination $newDirPath

        Write-Host "    Готово: $newDirName" -ForegroundColor Green
        $success++
    }
    catch {
        Write-Host "    ОШИБКА: $($_.Exception.Message)" -ForegroundColor Red
        $failed += $name
        # Откат: если старую папку уже переместили, а новая не встала — вернуть
        if ($backupPath -and (Test-Path -LiteralPath $backupPath) -and -not (Test-Path -LiteralPath $mod.Dir.FullName)) {
            Move-Item -LiteralPath $backupPath -Destination $mod.Dir.FullName
            Write-Host "    Откат выполнен." -ForegroundColor Gray
        }
    }
    finally {
        if ($tmp -and (Test-Path -LiteralPath $tmp)) { Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }
}

# --- Очистка старых бэкапов (хранить последние 3 на мод) ---
try {
    $backupGroups = Get-ChildItem -LiteralPath $BackupDir -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '_\d{8}_\d{6}$' } |
        Group-Object { $_.Name -replace '_\d{8}_\d{6}$', '' }
    foreach ($g in $backupGroups) {
        $oldBackups = $g.Group | Sort-Object Name -Descending | Select-Object -Skip 3
        foreach ($ob in $oldBackups) {
            Remove-Item -LiteralPath $ob.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
} catch { }

# --- Итог ---
Write-Host "`n--- ИТОГ ОБНОВЛЕНИЯ ---" -ForegroundColor Cyan
Write-Host ("  Успешно обновлено: {0}" -f $success) -ForegroundColor Green
if ($failed.Count -gt 0) {
    Write-Host ("  Ошибки: {0}" -f ($failed -join ', ')) -ForegroundColor Red
}
Write-Host ("  Бэкапы старых версий: {0}" -f $BackupDir) -ForegroundColor Gray
Write-Host "  (Бэкапы можно удалить, если игра работает корректно)" -ForegroundColor DarkGray
Write-Host "Спасибо за использование моего скрипта! По желанию подпишитесь на канал PonosNasral" -ForegroundColor Magenta

Write-Host ""
try { Stop-Transcript | Out-Null } catch { }
try { [void](Read-Host "Нажмите Enter для выхода") } catch { }

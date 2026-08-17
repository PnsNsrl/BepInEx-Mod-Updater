# ============================================================
#  BepInEx ThunderStore Mod Updater by PonosNasral (universal)
#  Works with ANY game that has BepInEx + a ThunderStore community
#  Scans ALL Steam libraries on ALL drives (C:, D:, ...)
#  6 languages: en / ru / es / pt / de / fr
# ============================================================

$ErrorActionPreference = 'Stop'
# Force TLS 1.2 (PS 5.1 defaults to TLS 1.0, ThunderStore rejects it)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ScriptDir = $null
try { if ($PSScriptRoot) { $ScriptDir = $PSScriptRoot } } catch {}
if (-not $ScriptDir) {
    try {
        $cmdLine = [Environment]::GetCommandLineArgs()
        if ($cmdLine -and $cmdLine[0]) { $ScriptDir = Split-Path -Parent ([IO.Path]::GetFullPath($cmdLine[0])) }
    } catch {}
}
if (-not $ScriptDir) { $ScriptDir = (Get-Location).Path }
$LogLines = New-Object System.Collections.Generic.List[string]

# ---------- LOG ----------
function Write-Log([string]$msg) {
    $stamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    $LogLines.Add("[$stamp] $msg")
}

# ---------- LOCALIZATION ----------
$L = [ordered]@{}
$L['en'] = [ordered]@{
    title      = 'BepInEx ThunderStore Mod Updater (universal)'
    scan       = 'Scanning Steam libraries...'
    found_libs = 'Steam libraries found:'
    found_none = 'No games with BepInEx found in any Steam library!'
    select_game= 'Select a game (number):'
    one_game   = 'Game found:'
    no_comm    = 'No ThunderStore community found for this game. Sorry!'
    comm_ok    = 'ThunderStore community:'
    checking   = 'Checking mods against ThunderStore...'
    up_to_date = 'All mods are up to date!'
    outdated   = 'Outdated mods:'
    update_q   = 'Update these mods now? (y/n):'
    updating   = 'Updating:'
    done       = 'Update finished!'
    errors     = 'Errors occurred, see log.'
    backup     = 'Backup created:'
    rollback   = 'Rolled back due to error:'
    game_run   = 'WARNING: the game appears to be running! Close it before updating.'
    no_mods    = 'No ThunderStore-style mods (folders with manifest.json) found in BepInEx/plugins.'
    loose      = 'Loose DLLs (no manifest) skipped:'
    deps_miss  = 'Missing dependencies:'
    lang_pick  = 'Select language: 1=English 2=Русский 3=Espanol 4=Portugues 5=Deutsch 6=Francais'
    press_enter= 'Press Enter to exit...'
    latest     = 'latest:'
    installed  = 'installed:'
    dl         = 'Downloading:'
    extract    = 'Extracting...'
    unknown_ver= 'unknown'
}
$L['ru'] = [ordered]@{
    title      = 'BepInEx ThunderStore Mod Updater (универсальный)'
    scan       = 'Сканирование библиотек Steam...'
    found_libs = 'Найдены библиотеки Steam:'
    found_none = 'Игры с BepInEx не найдены ни в одной библиотеке Steam!'
    select_game= 'Выберите игру (номер):'
    one_game   = 'Найдена игра:'
    no_comm    = 'Сообщество ThunderStore для этой игры не найдено.'
    comm_ok    = 'Сообщество ThunderStore:'
    checking   = 'Проверка модов на ThunderStore...'
    up_to_date = 'Все моды актуальны!'
    outdated   = 'Устаревшие моды:'
    update_q   = 'Обновить эти моды сейчас? (y/n):'
    updating   = 'Обновление:'
    done       = 'Обновление завершено!'
    errors     = 'Произошли ошибки, смотрите лог.'
    backup     = 'Создан бэкап:'
    rollback   = 'Откат из-за ошибки:'
    game_run   = 'ВНИМАНИЕ: похоже, игра запущена! Закройте её перед обновлением.'
    no_mods    = 'В BepInEx/plugins не найдено модов в формате ThunderStore (папки с manifest.json).'
    loose      = 'Отдельные DLL (без manifest) пропущены:'
    deps_miss  = 'Отсутствующие зависимости:'
    lang_pick  = 'Выберите язык: 1=English 2=Русский 3=Espanol 4=Portugues 5=Deutsch 6=Francais'
    press_enter= 'Нажмите Enter для выхода...'
    latest     = 'новейшая:'
    installed  = 'установлена:'
    dl         = 'Скачивание:'
    extract    = 'Распаковка...'
    unknown_ver= 'неизвестно'
}
$L['es'] = [ordered]@{
    title      = 'BepInEx ThunderStore Mod Updater (universal)'
    scan       = 'Escaneando bibliotecas de Steam...'
    found_libs = 'Bibliotecas de Steam encontradas:'
    found_none = 'No se encontraron juegos con BepInEx en ninguna biblioteca de Steam!'
    select_game= 'Selecciona un juego (numero):'
    one_game   = 'Juego encontrado:'
    no_comm    = 'No se encontro comunidad de ThunderStore para este juego.'
    comm_ok    = 'Comunidad de ThunderStore:'
    checking   = 'Comprobando mods en ThunderStore...'
    up_to_date = 'Todos los mods estan actualizados!'
    outdated   = 'Mods desactualizados:'
    update_q   = 'Actualizar estos mods ahora? (y/n):'
    updating   = 'Actualizando:'
    done       = 'Actualizacion completada!'
    errors     = 'Ocurrieron errores, mira el registro.'
    backup     = 'Copia de seguridad creada:'
    rollback   = 'Revertido por error:'
    game_run   = 'ATENCION: el juego parece estar en ejecucion! Cierralo antes de actualizar.'
    no_mods    = 'No se encontraron mods estilo ThunderStore (carpetas con manifest.json) en BepInEx/plugins.'
    loose      = 'DLL sueltas (sin manifest) omitidas:'
    deps_miss  = 'Dependencias faltantes:'
    lang_pick  = 'Idioma: 1=English 2=Русский 3=Espanol 4=Portugues 5=Deutsch 6=Francais'
    press_enter= 'Pulsa Enter para salir...'
    latest     = 'ultima:'
    installed  = 'instalada:'
    dl         = 'Descargando:'
    extract    = 'Extrayendo...'
    unknown_ver= 'desconocida'
}
$L['pt'] = [ordered]@{
    title      = 'BepInEx ThunderStore Mod Updater (universal)'
    scan       = 'Escaneando bibliotecas do Steam...'
    found_libs = 'Bibliotecas do Steam encontradas:'
    found_none = 'Nenhum jogo com BepInEx encontrado em nenhuma biblioteca do Steam!'
    select_game= 'Selecione um jogo (numero):'
    one_game   = 'Jogo encontrado:'
    no_comm    = 'Nenhuma comunidade ThunderStore encontrada para este jogo.'
    comm_ok    = 'Comunidade ThunderStore:'
    checking   = 'Verificando mods no ThunderStore...'
    up_to_date = 'Todos os mods estao atualizados!'
    outdated   = 'Mods desatualizados:'
    update_q   = 'Atualizar estos mods agora? (y/n):'
    updating   = 'Atualizando:'
    done       = 'Atualizacao concluida!'
    errors     = 'Ocorreram erros, veja o log.'
    backup     = 'Backup criado:'
    rollback   = 'Revertido por erro:'
    game_run   = 'ATENCAO: o jogo parece estar em execucao! Feche-o antes de atualizar.'
    no_mods    = 'Nenhum mod estilo ThunderStore (pastas com manifest.json) em BepInEx/plugins.'
    loose      = 'DLLs soltas (sem manifest) ignoradas:'
    deps_miss  = 'Dependencias ausentes:'
    lang_pick  = 'Idioma: 1=English 2=Русский 3=Espanol 4=Portugues 5=Deutsch 6=Francais'
    press_enter= 'Pressione Enter para sair...'
    latest     = 'ultima:'
    installed  = 'instalada:'
    dl         = 'Baixando:'
    extract    = 'Extraindo...'
    unknown_ver= 'desconhecida'
}
$L['de'] = [ordered]@{
    title      = 'BepInEx ThunderStore Mod Updater (universal)'
    scan       = 'Steam-Bibliotheken werden durchsucht...'
    found_libs = 'Gefundene Steam-Bibliotheken:'
    found_none = 'Keine Spiele mit BepInEx in einer Steam-Bibliothek gefunden!'
    select_game= 'Spiel auswaehlen (Nummer):'
    one_game   = 'Spiel gefunden:'
    no_comm    = 'Keine ThunderStore-Community fuer dieses Spiel gefunden.'
    comm_ok    = 'ThunderStore-Community:'
    checking   = 'Mods werden mit ThunderStore verglichen...'
    up_to_date = 'Alle Mods sind aktuell!'
    outdated   = 'Veraltete Mods:'
    update_q   = 'Diese Mods jetzt aktualisieren? (y/n):'
    updating   = 'Aktualisiere:'
    done       = 'Aktualisierung abgeschlossen!'
    errors     = 'Fehler aufgetreten, siehe Log.'
    backup     = 'Backup erstellt:'
    rollback   = 'Wegen Fehler zurueckgesetzt:'
    game_run   = 'WARNUNG: Das Spiel scheint zu laufen! Vor dem Update schliessen.'
    no_mods    = 'Keine ThunderStore-Mods (Ordner mit manifest.json) in BepInEx/plugins gefunden.'
    loose      = 'Einzelne DLLs (ohne manifest) uebersprungen:'
    deps_miss  = 'Fehlende Abhaengigkeiten:'
    lang_pick  = 'Sprache: 1=English 2=Русский 3=Espanol 4=Portugues 5=Deutsch 6=Francais'
    press_enter= 'Enter zum Beenden druecken...'
    latest     = 'neueste:'
    installed  = 'installiert:'
    dl         = 'Lade herunter:'
    extract    = 'Entpacke...'
    unknown_ver= 'unbekannt'
}
$L['fr'] = [ordered]@{
    title      = 'BepInEx ThunderStore Mod Updater (universel)'
    scan       = 'Analyse des bibliotheques Steam...'
    found_libs = 'Bibliotheques Steam trouvees :'
    found_none = 'Aucun jeu avec BepInEx trouve dans les bibliotheques Steam !'
    select_game= 'Choisissez un jeu (numero) :'
    one_game   = 'Jeu trouve :'
    no_comm    = 'Aucune communaute ThunderStore pour ce jeu.'
    comm_ok    = 'Communaute ThunderStore :'
    checking   = 'Verification des mods sur ThunderStore...'
    up_to_date = 'Tous les mods sont a jour !'
    outdated   = 'Mods obsolete :'
    update_q   = 'Mettre a jour ces mods maintenant ? (y/n) :'
    updating   = 'Mise a jour :'
    done       = 'Mise a jour terminee !'
    errors     = 'Des erreurs sont survenues, voir le log.'
    backup     = 'Sauvegarde creee :'
    rollback   = 'Annule a cause d une erreur :'
    game_run   = 'ATTENTION : le jeu semble en cours d execution ! Fermez-le avant.'
    no_mods    = 'Aucun mod ThunderStore (dossiers avec manifest.json) dans BepInEx/plugins.'
    loose      = 'DLL isolees (sans manifest) ignorees :'
    deps_miss  = 'Dependances manquantes :'
    lang_pick  = 'Langue : 1=English 2=Русский 3=Espanol 4=Portugues 5=Deutsch 6=Francais'
    press_enter= 'Appuyez sur Entree pour quitter...'
    latest     = 'derniere :'
    installed  = 'installee :'
    dl         = 'Telechargement :'
    extract    = 'Extraction...'
    unknown_ver= 'inconnue'
}

# ---------- LANGUAGE SELECTION ----------
$langFile = Join-Path $ScriptDir 'lang.txt'
$langKeys = @('en','ru','es','pt','de','fr')
$lang = 'en'
$forced = $false
foreach ($a in $args) {
    if ("$a" -eq '/lang') { $forced = $true }
}
if ($forced -or -not (Test-Path $langFile)) {
    Write-Host ''
    Write-Host $L['en'].lang_pick -ForegroundColor Cyan
    $pick = Read-Host '> '
    $idx = 0
    if ([int]::TryParse($pick, [ref]$idx) -and $idx -ge 1 -and $idx -le 6) { $lang = $langKeys[$idx-1] }
    [IO.File]::WriteAllText($langFile, $lang)
} else {
    $saved = (Get-Content $langFile -Raw).Trim()
    if ($langKeys -contains $saved) { $lang = $saved } else { [IO.File]::WriteAllText($langFile, $lang) }
}
$T = $L[$lang]

function Pause-Exit([int]$code = 0) {
    Write-Host ''
    Write-Host $T.press_enter -ForegroundColor DarkGray
    [void](Read-Host)
    exit $code
}

# ---------- STEAM LIBRARY DISCOVERY ----------
function Get-SteamLibraries {
    $libs = New-Object System.Collections.Generic.List[string]
    $steamRoots = New-Object System.Collections.Generic.List[string]

    # 1) Registry
    foreach ($rk in @(
        'HKLM:\SOFTWARE\WOW6432Node\Valve\Steam',
        'HKLM:\SOFTWARE\Valve\Steam',
        'HKCU:\Software\Valve\Steam'
    )) {
        if (Test-Path $rk) {
            $ip = (Get-ItemProperty $rk -ErrorAction SilentlyContinue).InstallPath
            if ($ip) { $steamRoots.Add($ip) }
        }
    }

    # 2) libraryfolders.vdf from every known root (iterate over a snapshot!)
    $vdfRoots = New-Object System.Collections.Generic.List[string]
    foreach ($root in @($steamRoots.ToArray())) {
        $vdf = Join-Path $root 'steamapps\libraryfolders.vdf'
        if (Test-Path $vdf) {
            foreach ($m in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) {
                $vdfRoots.Add(($m.Groups[1].Value -replace '\\\\','\'))
            }
        }
    }
    foreach ($r in $vdfRoots) { if (-not $steamRoots.Contains($r)) { $steamRoots.Add($r) } }

    # 3) Fallback: scan all fixed drives for SteamLibrary
    if ($steamRoots.Count -eq 0) {
        Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -ne $null } | ForEach-Object {
            $p = "$($_.Name):\SteamLibrary"
            if (Test-Path (Join-Path $p 'steamapps')) { $steamRoots.Add($p) }
        }
    }

    # Normalize + dedupe
    foreach ($root in $steamRoots) {
        $norm = ($root -replace '/','\').TrimEnd('\')
        if (-not $libs.Contains($norm)) { $libs.Add($norm) }
    }
    return $libs
}

# ---------- GAME NAME FROM APPMANIFEST ----------
function Get-GameNameFromManifest([string]$steamapps, [string]$folderName) {
    foreach ($acf in (Get-ChildItem $steamapps -Filter 'appmanifest_*.acf' -ErrorAction SilentlyContinue)) {
        $raw = Get-Content $acf.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $raw) { continue }
        $idm = [regex]::Match($raw, '"installdir"\s+"([^"]+)"')
        if ($idm.Success -and $idm.Groups[1].Value -ieq $folderName) {
            $nm = [regex]::Match($raw, '"name"\s+"([^"]+)"')
            if ($nm.Success) { return $nm.Groups[1].Value }
        }
    }
    return $folderName
}

# ---------- FIND GAMES ----------
function Find-BepInExGames([System.Collections.Generic.List[string]]$libs) {
    $games = New-Object System.Collections.Generic.List[object]
    $seen = New-Object System.Collections.Generic.HashSet[string]([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($lib in $libs) {
        $sa = Join-Path $lib 'steamapps\common'
        if (-not (Test-Path $sa)) { continue }
        foreach ($dir in (Get-ChildItem $sa -Directory -ErrorAction SilentlyContinue)) {
            $bep = Join-Path $dir.FullName 'BepInEx'
            if (-not (Test-Path $bep)) { continue }
            if (-not $seen.Add($dir.FullName)) { continue }
            $games.Add([pscustomobject]@{
                Name    = Get-GameNameFromManifest (Join-Path $lib 'steamapps') $dir.Name
                Folder  = $dir.Name
                Path    = $dir.FullName
                Plugins = (Join-Path $bep 'plugins')
            })
        }
    }
    return $games
}

# ---------- THUNDERSTORE HELPERS ----------
$TS = 'https://thunderstore.io'

function Test-CommunityExists([string]$slug) {
    try {
        $r = Invoke-WebRequest -Uri "$TS/c/$slug/" -UseBasicParsing -Method Head -TimeoutSec 15
        return ($r.StatusCode -eq 200)
    } catch {
        try {
            $r = Invoke-WebRequest -Uri "$TS/c/$slug/" -UseBasicParsing -TimeoutSec 15
            return ($r.StatusCode -eq 200)
        } catch { return $false }
    }
}

function Get-Catalog([string]$community) {
    # Community-scoped legacy API: one request returns ALL packages with versions
    $url = "$TS/c/$community/api/v1/package/"
    for ($attempt = 1; $attempt -le 5; $attempt++) {
        try { return Invoke-RestMethod -Uri $url -TimeoutSec 90 } catch { Start-Sleep -Seconds 3 }
    }
    return $null
}

function Compare-Versions([string]$a, [string]$b) {
    # returns 1 if a > b, -1 if a < b, 0 if equal
    $pa = ($a -split '[.\-+]') | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }
    $pb = ($b -split '[.\-+]') | Where-Object { $_ -match '^\d+$' } | ForEach-Object { [int]$_ }
    $n = [Math]::Max($pa.Count, $pb.Count)
    for ($i = 0; $i -lt $n; $i++) {
        $va = if ($i -lt $pa.Count) { $pa[$i] } else { 0 }
        $vb = if ($i -lt $pb.Count) { $pb[$i] } else { 0 }
        if ($va -gt $vb) { return 1 }
        if ($va -lt $vb) { return -1 }
    }
    return 0
}

# ---------- MAIN ----------
try {
    Write-Host ''
    Write-Host ('==== ' + $T.title + ' ====') -ForegroundColor Green
    Write-Host ''

    Write-Host $T.scan -ForegroundColor Cyan
    $libs = Get-SteamLibraries
    foreach ($l in $libs) { Write-Host "  [$($T.found_libs)] $l" -ForegroundColor DarkGray }
    Write-Log "Libraries: $($libs -join '; ')"

    $games = Find-BepInExGames $libs
    if ($games.Count -eq 0) {
        Write-Host $T.found_none -ForegroundColor Red
        Write-Log 'No games found'
        Pause-Exit 1
    }

    # Select game
    $game = $null
    if ($games.Count -eq 1) {
        $game = $games[0]
        Write-Host ($T.one_game + ' ' + $game.Name) -ForegroundColor Yellow
    } else {
        for ($i = 0; $i -lt $games.Count; $i++) {
            Write-Host ("  {0}. {1}  ({2})" -f ($i+1), $games[$i].Name, $games[$i].Path)
        }
        Write-Host $T.select_game -ForegroundColor Cyan
        $sel = 0
        do {
            $in = Read-Host '> '
        } until ([int]::TryParse($in, [ref]$sel) -and $sel -ge 1 -and $sel -le $games.Count)
        $game = $games[$sel-1]
    }
    Write-Log "Selected game: $($game.Name) @ $($game.Path)"

    # Game running check
    $gameExes = Get-ChildItem $game.Path -Filter '*.exe' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty BaseName
    $running = Get-Process -ErrorAction SilentlyContinue | Where-Object { $gameExes -contains $_.Name }
    if ($running) { Write-Host $T.game_run -ForegroundColor Red; Write-Log 'Game running detected' }

    # Community detection
    $slug = $game.Folder.ToLower()
    if (-not (Test-CommunityExists $slug)) {
        Write-Host $T.no_comm -ForegroundColor Red
        Write-Log "No community for slug '$slug'"
        Pause-Exit 1
    }
    Write-Host ($T.comm_ok + ' ' + $slug) -ForegroundColor Yellow
    Write-Log "Community: $slug"

    # Fetch full catalog in ONE request (fast, reliable)
    $catalog = Get-Catalog $slug
    if (-not $catalog) {
        Write-Host $T.no_comm -ForegroundColor Red
        Write-Log 'Catalog fetch failed'
        Pause-Exit 1
    }
    $byName = @{}
    $byFullName = @{}
    foreach ($p in $catalog) {
        $k = $p.name.ToLower()
        if (-not $byName.ContainsKey($k)) { $byName[$k] = $p }
        $byFullName[$p.full_name.ToLower()] = $p
    }
    Write-Host ('Packages in catalog: {0}' -f $catalog.Count) -ForegroundColor Gray
    Write-Log "Catalog packages: $($catalog.Count)"

    # Collect mods
    $plugins = $game.Plugins
    if (-not (Test-Path $plugins)) { New-Item -ItemType Directory -Path $plugins -Force | Out-Null }
    $mods = New-Object System.Collections.Generic.List[object]
    $loose = New-Object System.Collections.Generic.List[string]
    foreach ($d in (Get-ChildItem $plugins -Directory -ErrorAction SilentlyContinue)) {
        if ($d.Name -like '.*') { continue }   # hidden (backups)
        $mani = Join-Path $d.FullName 'manifest.json'
        if (Test-Path $mani) {
            try {
                $j = Get-Content $mani -Raw | ConvertFrom-Json
                $mods.Add([pscustomobject]@{
                    Dir = $d.FullName; Name = $j.name; Version = $j.version_number
                    Deps = @($j.dependencies)
                })
            } catch { $loose.Add($d.Name) }
        } else { $loose.Add($d.Name) }
    }
    foreach ($f in (Get-ChildItem $plugins -Filter '*.dll' -File -ErrorAction SilentlyContinue)) { $loose.Add($f.Name) }

    if ($loose.Count -gt 0) {
        Write-Host ($T.loose) -ForegroundColor DarkYellow
        foreach ($x in $loose) { Write-Host "  - $x" -ForegroundColor DarkGray }
    }
    if ($mods.Count -eq 0) {
        Write-Host $T.no_mods -ForegroundColor Red
        Write-Log 'No ThunderStore mods found'
        Pause-Exit 0
    }

    # Dependency check
    $installedNames = $mods | ForEach-Object { $_.Name }
    $missingDeps = New-Object System.Collections.Generic.List[string]
    foreach ($m in $mods) {
        foreach ($dep in $m.Deps) {
            $depName = ($dep -split '-')[1]
            if ($depName -and ($installedNames -notcontains $depName)) { $missingDeps.Add("$($m.Name) -> $dep") }
        }
    }
    if ($missingDeps.Count -gt 0) {
        Write-Host $T.deps_miss -ForegroundColor DarkYellow
        foreach ($x in $missingDeps) { Write-Host "  - $x" -ForegroundColor DarkGray }
    }

    # Version check
    Write-Host ''
    Write-Host $T.checking -ForegroundColor Cyan
    $toUpdate = New-Object System.Collections.Generic.List[object]
    foreach ($m in $mods) {
        $pkg = $null
        $folderKey = ((Split-Path -Leaf $m.Dir) -replace '-\d+(\.\d+)*(-[\w.]+)?$', '').ToLower()
        if ($byFullName.ContainsKey($folderKey)) { $pkg = $byFullName[$folderKey] }
        if (-not $pkg -and $byName.ContainsKey($m.Name.ToLower())) { $pkg = $byName[$m.Name.ToLower()] }
        if (-not $pkg) {
            Write-Host ("  ? $($m.Name) ($($T.latest) $($T.unknown_ver))") -ForegroundColor DarkGray
            continue
        }
        $latest = @{ Version = $pkg.versions[0].version_number; Download = $pkg.versions[0].download_url }
        $cmp = Compare-Versions $latest.Version $m.Version
        if ($cmp -gt 0) {
            Write-Host ("  ! {0}  {1} {2} -> {3}" -f $m.Name, $T.installed, $m.Version, $latest.Version) -ForegroundColor Yellow
            $toUpdate.Add([pscustomobject]@{ Mod = $m; Latest = $latest })
        } else {
            Write-Host ("  + {0} ({1})" -f $m.Name, $m.Version) -ForegroundColor DarkGreen
        }
    }
    Write-Log "Checked $($mods.Count) mods, outdated: $($toUpdate.Count)"

    if ($toUpdate.Count -eq 0) {
        Write-Host ''
        Write-Host $T.up_to_date -ForegroundColor Green
        Pause-Exit 0
    }

    # Confirm
    Write-Host ''
    Write-Host $T.outdated -ForegroundColor Yellow
    foreach ($u in $toUpdate) { Write-Host ("  - {0}: {1} -> {2}" -f $u.Mod.Name, $u.Mod.Version, $u.Latest.Version) }
    Write-Host $T.update_q -ForegroundColor Cyan
    $ans = Read-Host '> '
    if ($ans -notmatch '^[yYдД]') { Pause-Exit 0 }

    # Update
    $backupRoot = Join-Path $plugins '.mod_backups'
    $hadErrors = $false
    foreach ($u in $toUpdate) {
        $m = $u.Mod
        Write-Host ''
        Write-Host ($T.updating + ' ' + $m.Name) -ForegroundColor Cyan
        Write-Log "Updating $($m.Name) $($m.Version) -> $($u.Latest.Version)"
        try {
            # Backup
            New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
            $bk = Join-Path $backupRoot ("{0}_{1}_{2}" -f $m.Name, $m.Version, (Get-Date -Format 'yyyyMMdd_HHmmss'))
            Copy-Item $m.Dir $bk -Recurse -Force
            Write-Host ("  $($T.backup) $bk") -ForegroundColor DarkGray
            # Keep only last 3 backups per mod
            Get-ChildItem $backupRoot -Directory -Filter "$($m.Name)_*" -ErrorAction SilentlyContinue |
                Sort-Object Name -Descending | Select-Object -Skip 3 | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            # Download
            $tmp = Join-Path $env:TEMP ("peakupd_" + [guid]::NewGuid().ToString('N'))
            New-Item -ItemType Directory -Path $tmp -Force | Out-Null
            $zip = Join-Path $tmp 'mod.zip'
            Write-Host ("  $($T.dl) $($u.Latest.Version)") -ForegroundColor DarkGray
            $dlUrl = $u.Latest.Download
            if (-not $dlUrl) { $dlUrl = "$TS/package/download/$slug/$($m.Name)/$($u.Latest.Version)/" }
            Invoke-WebRequest -Uri $dlUrl -OutFile $zip -UseBasicParsing -TimeoutSec 120

            # Extract
            Write-Host "  $($T.extract)" -ForegroundColor DarkGray
            $ext = Join-Path $tmp 'ext'
            Expand-Archive -Path $zip -DestinationPath $ext -Force
            $newDir = Get-ChildItem $ext -Directory | Where-Object { Test-Path (Join-Path $_.FullName 'manifest.json') } | Select-Object -First 1
            if (-not $newDir) { throw 'manifest.json not found in archive' }

            # Replace
            Remove-Item $m.Dir -Recurse -Force
            Copy-Item $newDir.FullName $m.Dir
            Write-Host "  OK" -ForegroundColor Green
            Write-Log "Updated $($m.Name) OK"
        } catch {
            $hadErrors = $true
            Write-Host ("  ERROR: $($_.Exception.Message)") -ForegroundColor Red
            Write-Log "ERROR updating $($m.Name): $($_.Exception.Message)"
            # Rollback
            if ((Test-Path $bk) -and -not (Test-Path $m.Dir)) {
                Copy-Item $bk $m.Dir -Recurse -Force
                Write-Host ("  $($T.rollback) $($m.Name)") -ForegroundColor Magenta
            }
        } finally {
            if ($tmp -and (Test-Path $tmp)) { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
        }
    }

    Write-Host ''
    if ($hadErrors) { Write-Host $T.errors -ForegroundColor Red } else { Write-Host $T.done -ForegroundColor Green }
}
catch {
    Write-Host ''
    Write-Host ("FATAL: $($_.Exception.Message)") -ForegroundColor Red
    Write-Log "FATAL: $($_.Exception.Message)"
}
finally {
    # Write log next to game plugins
    try {
        if ($game -and $game.Plugins -and (Test-Path (Split-Path $game.Plugins -Parent))) {
            $LogLines | Set-Content (Join-Path $game.Plugins 'updater_log.txt') -Encoding UTF8
        } else {
            $LogLines | Set-Content (Join-Path $ScriptDir 'updater_log.txt') -Encoding UTF8
        }
    } catch {}
}

Pause-Exit 0
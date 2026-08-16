# ============================================================
#  PEAK ThunderStore Mod Updater by PonosNasral (i18n)
#  6 languages: en / ru / es / pt / de / fr
#  Auto-detect: lang.txt -> Windows UI language -> English
#  Change language: run with /lang argument
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

# ============================================================
#  LOCALIZATION TABLES
# ============================================================
$L = @{}

$L.en = @{
    err_not_game   = 'ERROR: the program is not in the game folder!'
    err_location   = 'Current location: {0}'
    err_move       = 'Move the program to PEAK\BepInEx\plugins and run again.'
    enter_exit     = 'Press Enter to exit'
    selftest_fail  = 'SELF-TEST ERROR: Compare-Versions "{0}" vs "{1}" = {2} (expected {3})'
    banner         = '=== PEAK Mod Updater (ThunderStore) by PonosNasral ==='
    fetching       = 'Fetching the PEAK mod catalog from ThunderStore...'
    attempt        = 'Attempt {0} of {1}. Please wait.. Reason: {2}'
    catalog_fail   = 'ERROR: could not fetch the ThunderStore catalog after {0} attempts.'
    catalog_count  = 'Mods found in catalog: {0}'
    installed_cnt  = 'ThunderStore mods installed: {0}'
    empty_folder   = '{0} (empty folder - possibly a broken install)'
    broken_mani    = '{0} (corrupted manifest.json)'
    res_header     = '--- CHECK RESULTS ---'
    notfound_note  = '{0} {1} (not on ThunderStore, skipped)'
    deps_header    = 'Missing dependencies (for mods being updated):'
    dep_missing    = '  [DEP] {0} - not installed'
    dep_hint       = '  Install them from ThunderStore, otherwise the mod may not work.'
    dll_header     = '.dll files directly in plugins (version cannot be determined):'
    dll_hint       = '  Tip: unzip the mod archive into plugins as a folder instead of dropping the .dll - then the script will work'
    skipped_hdr    = 'Skipped (non-ThunderStore folders):'
    summary        = 'Summary: up to date - {0}, to update - {1}, not found - {2}'
    all_uptodate   = 'All mods are up to date. No update required.'
    game_warn      = 'WARNING: the game PEAK is running. It is recommended to exit the game!'
    thanks         = 'Thanks for using my script! Feel free to subscribe to the PonosNasral channel'
    ask_update     = 'Do you want to update these mods? (Yes - 1, No - 2)'
    invalid_input  = 'Invalid input. Enter 1 or 2.'
    cancelled      = 'Update cancelled by user.'
    game_red       = 'WARNING: the game PEAK is currently running!'
    files_locked   = 'Mod files are locked, the update may fail with errors.'
    ask_anyway     = 'Continue the update anyway? (Yes - 1, No - 2)'
    cancel_close   = 'Update cancelled by user. Close the game and run the script again.'
    continuing     = 'Continuing by user decision...'
    starting       = 'Starting update of {0} mod(s)...'
    target_exists  = '    Target folder already exists, removing leftover: {0}'
    downloading    = '    Downloading (attempt {0})...'
    dl_failed      = '    Attempt {0} of {1} failed: {2}'
    dl_error       = 'could not download the archive'
    size_mismatch  = 'downloaded file size mismatch (expected {0} bytes, got {1} bytes)'
    not_zip        = 'downloaded file is not a zip archive'
    extracting     = '    Extracting...'
    no_manifest    = 'no manifest.json in the archive'
    backup_line    = '    Backup: {0}'
    done_line      = '    Done: {0}'
    error_line     = '    ERROR: {0}'
    rollback       = '    Rollback completed.'
    upd_header     = '--- UPDATE SUMMARY ---'
    updated_ok     = '  Successfully updated: {0}'
    errors_list    = '  Errors: {0}'
    backups_at     = '  Old version backups: {0}'
    backups_hint   = '  (You can delete the backups if the game works correctly)'
    lang_title     = '=== LANGUAGE SELECTION ==='
    lang_menu      = '  1 - English    2 - Русский'
    lang_menu2     = '  3 - Español    4 - Português  5 - Deutsch'
    lang_menu3     = '  6 - Français'
    lang_choose    = 'Choose language (1-6):'
    lang_saved     = 'Language saved: {0}'
    lang_invalid   = 'Invalid choice. Enter a number from 1 to 6.'
}

$L.ru = @{
    err_not_game   = 'ОШИБКА: программа находится не в папке игры!'
    err_location   = 'Текущее расположение: {0}'
    err_move       = 'Переместите программу в папку PEAK\BepInEx\plugins и запустите снова.'
    enter_exit     = 'Нажмите Enter для выхода'
    selftest_fail  = 'ОШИБКА САМОПРОВЕРКИ: Compare-Versions "{0}" vs "{1}" = {2} (ожидалось {3})'
    banner         = '=== PEAK Mod Updater (ThunderStore) by PonosNasral ==='
    fetching       = 'Получаю каталог модов PEAK с ThunderStore...'
    attempt        = 'Попытка {0} из {1}. Подождите.. Причина: {2}'
    catalog_fail   = 'ОШИБКА: не удалось получить каталог ThunderStore после {0} попыток.'
    catalog_count  = 'Найдено модов в каталоге: {0}'
    installed_cnt  = 'Установлено модов ThunderStore: {0}'
    empty_folder   = '{0} (пустая папка — возможно, битая установка)'
    broken_mani    = '{0} (битый manifest.json)'
    res_header     = '--- РЕЗУЛЬТАТ ПРОВЕРКИ ---'
    notfound_note  = '{0} {1} (нет на ThunderStore, пропущен)'
    deps_header    = 'Недостающие зависимости (для обновляемых модов):'
    dep_missing    = '  [DEP] {0} — не установлен'
    dep_hint       = '  Установите их с ThunderStore, иначе мод может не работать.'
    dll_header     = '.dll-файлы напрямую в plugins (версию определить нельзя):'
    dll_hint       = '  Совет: распакуйте zip мода в plugins папкой, а не кидайте .dll — тогда скрипт будет работать'
    skipped_hdr    = 'Пропущены (не ThunderStore-папки):'
    summary        = 'Итог: актуальных — {0}, к обновлению — {1}, не найдено — {2}'
    all_uptodate   = 'Все моды актуальны. Обновление не требуется.'
    game_warn      = 'ВНИМАНИЕ: Игра PEAK запущена. Рекомендую выйти из игры!'
    thanks         = 'Спасибо за использование моего скрипта! По желанию подпишитесь на канал PonosNasral'
    ask_update     = 'Хотите ли вы обновить данные моды? (Да - 1, Нет - 2)'
    invalid_input  = 'Неверный ввод. Введите 1 или 2.'
    cancelled      = 'Обновление отменено пользователем.'
    game_red       = 'ВНИМАНИЕ: игра PEAK сейчас запущена!'
    files_locked   = 'Файлы модов заблокированы, обновление может завершиться с ошибками.'
    ask_anyway     = 'Всё равно продолжить обновление? (Да - 1, Нет - 2)'
    cancel_close   = 'Обновление отменено пользователем. Закройте игру и запустите скрипт снова.'
    continuing     = 'Продолжаю по решению пользователя...'
    starting       = 'Начинаю обновление {0} мод(ов)...'
    target_exists  = '    Целевая папка уже существует, удаляю остаток: {0}'
    downloading    = '    Скачиваю (попытка {0})...'
    dl_failed      = '    Попытка {0} из {1} не удалась: {2}'
    dl_error       = 'не удалось скачать архив'
    size_mismatch  = 'размер скачанного файла не совпадает (ожидалось {0} байт, получено {1} байт)'
    not_zip        = 'скачанный файл не является zip-архивом'
    extracting     = '    Распаковываю...'
    no_manifest    = 'в архиве нет manifest.json'
    backup_line    = '    Бэкап: {0}'
    done_line      = '    Готово: {0}'
    error_line     = '    ОШИБКА: {0}'
    rollback       = '    Откат выполнен.'
    upd_header     = '--- ИТОГ ОБНОВЛЕНИЯ ---'
    updated_ok     = '  Успешно обновлено: {0}'
    errors_list    = '  Ошибки: {0}'
    backups_at     = '  Бэкапы старых версий: {0}'
    backups_hint   = '  (Бэкапы можно удалить, если игра работает корректно)'
    lang_title     = '=== ВЫБОР ЯЗЫКА ==='
    lang_menu      = '  1 - English    2 - Русский'
    lang_menu2     = '  3 - Español    4 - Português  5 - Deutsch'
    lang_menu3     = '  6 - Français'
    lang_choose    = 'Выберите язык (1-6):'
    lang_saved     = 'Язык сохранён: {0}'
    lang_invalid   = 'Неверный выбор. Введите число от 1 до 6.'
}


$L.es = @{
    err_not_game   = 'ERROR: ¡el programa no está en la carpeta del juego!'
    err_location   = 'Ubicación actual: {0}'
    err_move       = 'Mueve el programa a PEAK\BepInEx\plugins y ejecútalo de nuevo.'
    enter_exit     = 'Pulsa Enter para salir'
    selftest_fail  = 'ERROR DE AUTOTEST: Compare-Versions "{0}" vs "{1}" = {2} (se esperaba {3})'
    banner         = '=== PEAK Mod Updater (ThunderStore) by PonosNasral ==='
    fetching       = 'Obteniendo el catálogo de mods de PEAK desde ThunderStore...'
    attempt        = 'Intento {0} de {1}. Espera.. Motivo: {2}'
    catalog_fail   = 'ERROR: no se pudo obtener el catálogo de ThunderStore tras {0} intentos.'
    catalog_count  = 'Mods encontrados en el catálogo: {0}'
    installed_cnt  = 'Mods de ThunderStore instalados: {0}'
    empty_folder   = '{0} (carpeta vacía — posiblemente una instalación rota)'
    broken_mani    = '{0} (manifest.json corrupto)'
    res_header     = '--- RESULTADOS DE LA COMPROBACIÓN ---'
    notfound_note  = '{0} {1} (no está en ThunderStore, omitido)'
    deps_header    = 'Dependencias faltantes (para los mods a actualizar):'
    dep_missing    = '  [DEP] {0} — no instalado'
    dep_hint       = '  Instálalas desde ThunderStore, o el mod podría no funcionar.'
    dll_header     = 'Archivos .dll directamente en plugins (no se puede determinar la versión):'
    dll_hint       = '  Consejo: descomprime el zip del mod en plugins como carpeta en vez de soltar el .dll — así el script funcionará'
    skipped_hdr    = 'Omitidos (carpetas que no son de ThunderStore):'
    summary        = 'Resumen: actualizados — {0}, por actualizar — {1}, no encontrados — {2}'
    all_uptodate   = 'Todos los mods están actualizados. No se requiere actualización.'
    game_warn      = 'ATENCIÓN: el juego PEAK está en marcha. ¡Se recomienda salir del juego!'
    thanks         = '¡Gracias por usar mi script! Suscríbete al canal de PonosNasral si quieres'
    ask_update     = '¿Quieres actualizar estos mods? (Sí - 1, No - 2)'
    invalid_input  = 'Entrada no válida. Escribe 1 o 2.'
    cancelled      = 'Actualización cancelada por el usuario.'
    game_red       = 'ATENCIÓN: ¡el juego PEAK está en marcha!'
    files_locked   = 'Los archivos de los mods están bloqueados, la actualización puede fallar.'
    ask_anyway     = '¿Continuar la actualización de todos modos? (Sí - 1, No - 2)'
    cancel_close   = 'Actualización cancelada por el usuario. Cierra el juego y ejecuta el script de nuevo.'
    continuing     = 'Continuando por decisión del usuario...'
    starting       = 'Comenzando la actualización de {0} mod(s)...'
    target_exists  = '    La carpeta de destino ya existe, eliminando restos: {0}'
    downloading    = '    Descargando (intento {0})...'
    dl_failed      = '    El intento {0} de {1} falló: {2}'
    dl_error       = 'no se pudo descargar el archivo'
    size_mismatch  = 'el tamaño del archivo descargado no coincide (se esperaban {0} bytes, se obtuvieron {1} bytes)'
    not_zip        = 'el archivo descargado no es un archivo zip'
    extracting     = '    Extrayendo...'
    no_manifest    = 'no hay manifest.json en el archivo'
    backup_line    = '    Copia de seguridad: {0}'
    done_line      = '    Hecho: {0}'
    error_line     = '    ERROR: {0}'
    rollback       = '    Reversión completada.'
    upd_header     = '--- RESUMEN DE LA ACTUALIZACIÓN ---'
    updated_ok     = '  Actualizados con éxito: {0}'
    errors_list    = '  Errores: {0}'
    backups_at     = '  Copias de versiones antiguas: {0}'
    backups_hint   = '  (Puedes eliminar las copias si el juego funciona correctamente)'
    lang_title     = '=== SELECCIÓN DE IDIOMA ==='
    lang_menu      = '  1 - English    2 - Русский'
    lang_menu2     = '  3 - Español    4 - Português  5 - Deutsch'
    lang_menu3     = '  6 - Français'
    lang_choose    = 'Elige idioma (1-6):'
    lang_saved     = 'Idioma guardado: {0}'
    lang_invalid   = 'Elección no válida. Escribe un número del 1 al 6.'
}

$L.pt = @{
    err_not_game   = 'ERRO: o programa não está na pasta do jogo!'
    err_location   = 'Localização atual: {0}'
    err_move       = 'Mova o programa para PEAK\BepInEx\plugins e execute novamente.'
    enter_exit     = 'Pressione Enter para sair'
    selftest_fail  = 'ERRO DE AUTOTESTE: Compare-Versions "{0}" vs "{1}" = {2} (esperado {3})'
    banner         = '=== PEAK Mod Updater (ThunderStore) by PonosNasral ==='
    fetching       = 'Obtendo o catálogo de mods do PEAK no ThunderStore...'
    attempt        = 'Tentativa {0} de {1}. Aguarde.. Motivo: {2}'
    catalog_fail   = 'ERRO: não foi possível obter o catálogo do ThunderStore após {0} tentativas.'
    catalog_count  = 'Mods encontrados no catálogo: {0}'
    installed_cnt  = 'Mods do ThunderStore instalados: {0}'
    empty_folder   = '{0} (pasta vazia — possivelmente uma instalação corrompida)'
    broken_mani    = '{0} (manifest.json corrompido)'
    res_header     = '--- RESULTADO DA VERIFICAÇÃO ---'
    notfound_note  = '{0} {1} (não está no ThunderStore, ignorado)'
    deps_header    = 'Dependências ausentes (para os mods a serem atualizados):'
    dep_missing    = '  [DEP] {0} — não instalado'
    dep_hint       = '  Instale-as pelo ThunderStore, caso contrário o mod pode não funcionar.'
    dll_header     = 'Arquivos .dll diretamente em plugins (não é possível determinar a versão):'
    dll_hint       = '  Dica: extraia o zip do mod em plugins como pasta em vez de soltar o .dll — assim o script funcionará'
    skipped_hdr    = 'Ignorados (pastas que não são do ThunderStore):'
    summary        = 'Resumo: atualizados — {0}, para atualizar — {1}, não encontrados — {2}'
    all_uptodate   = 'Todos os mods estão atualizados. Nenhuma atualização necessária.'
    game_warn      = 'ATENÇÃO: o jogo PEAK está em execução. Recomendo sair do jogo!'
    thanks         = 'Obrigado por usar meu script! Se quiser, inscreva-se no canal PonosNasral'
    ask_update     = 'Deseja atualizar estes mods? (Sim - 1, Não - 2)'
    invalid_input  = 'Entrada inválida. Digite 1 ou 2.'
    cancelled      = 'Atualização cancelada pelo usuário.'
    game_red       = 'ATENÇÃO: o jogo PEAK está em execução!'
    files_locked   = 'Os arquivos dos mods estão bloqueados, a atualização pode falhar.'
    ask_anyway     = 'Continuar a atualização mesmo assim? (Sim - 1, Não - 2)'
    cancel_close   = 'Atualização cancelada pelo usuário. Feche o jogo e execute o script novamente.'
    continuing     = 'Continuando por decisão do usuário...'
    starting       = 'Iniciando a atualização de {0} mod(s)...'
    target_exists  = '    A pasta de destino já existe, removendo sobra: {0}'
    downloading    = '    Baixando (tentativa {0})...'
    dl_failed      = '    A tentativa {0} de {1} falhou: {2}'
    dl_error       = 'não foi possível baixar o arquivo'
    size_mismatch  = 'o tamanho do arquivo baixado não corresponde (esperado {0} bytes, obtido {1} bytes)'
    not_zip        = 'o arquivo baixado não é um arquivo zip'
    extracting     = '    Extraindo...'
    no_manifest    = 'não há manifest.json no arquivo'
    backup_line    = '    Backup: {0}'
    done_line      = '    Concluído: {0}'
    error_line     = '    ERRO: {0}'
    rollback       = '    Reversão concluída.'
    upd_header     = '--- RESUMO DA ATUALIZAÇÃO ---'
    updated_ok     = '  Atualizados com sucesso: {0}'
    errors_list    = '  Erros: {0}'
    backups_at     = '  Backups de versões antigas: {0}'
    backups_hint   = '  (Você pode excluir os backups se o jogo funcionar corretamente)'
    lang_title     = '=== SELEÇÃO DE IDIOMA ==='
    lang_menu      = '  1 - English    2 - Русский'
    lang_menu2     = '  3 - Español    4 - Português  5 - Deutsch'
    lang_menu3     = '  6 - Français'
    lang_choose    = 'Escolha o idioma (1-6):'
    lang_saved     = 'Idioma salvo: {0}'
    lang_invalid   = 'Escolha inválida. Digite um número de 1 a 6.'
}

$L.de = @{
    err_not_game   = 'FEHLER: Das Programm liegt nicht im Spielordner!'
    err_location   = 'Aktueller Speicherort: {0}'
    err_move       = 'Verschiebe das Programm nach PEAK\BepInEx\plugins und starte es erneut.'
    enter_exit     = 'Zum Beenden Enter drücken'
    selftest_fail  = 'SELBSTTEST-FEHLER: Compare-Versions "{0}" vs. "{1}" = {2} (erwartet {3})'
    banner         = '=== PEAK Mod Updater (ThunderStore) by PonosNasral ==='
    fetching       = 'Lade den PEAK-Mod-Katalog von ThunderStore...'
    attempt        = 'Versuch {0} von {1}. Bitte warten.. Grund: {2}'
    catalog_fail   = 'FEHLER: Der ThunderStore-Katalog konnte nach {0} Versuchen nicht geladen werden.'
    catalog_count  = 'Mods im Katalog gefunden: {0}'
    installed_cnt  = 'Installierte ThunderStore-Mods: {0}'
    empty_folder   = '{0} (leerer Ordner — möglicherweise eine defekte Installation)'
    broken_mani    = '{0} (beschädigte manifest.json)'
    res_header     = '--- PRÜFERGEBNIS ---'
    notfound_note  = '{0} {1} (nicht auf ThunderStore, übersprungen)'
    deps_header    = 'Fehlende Abhängigkeiten (für zu aktualisierende Mods):'
    dep_missing    = '  [DEP] {0} — nicht installiert'
    dep_hint       = '  Installiere sie von ThunderStore, sonst funktioniert der Mod evtl. nicht.'
    dll_header     = '.dll-Dateien direkt in plugins (Version kann nicht ermittelt werden):'
    dll_hint       = '  Tipp: Entpacke das Mod-Zip als Ordner in plugins, statt die .dll hineinzuwerfen — dann funktioniert das Skript'
    skipped_hdr    = 'Übersprungen (keine ThunderStore-Ordner):'
    summary        = 'Fazit: aktuell — {0}, zu aktualisieren — {1}, nicht gefunden — {2}'
    all_uptodate   = 'Alle Mods sind aktuell. Kein Update erforderlich.'
    game_warn      = 'ACHTUNG: Das Spiel PEAK läuft. Es wird empfohlen, das Spiel zu beenden!'
    thanks         = 'Danke für die Nutzung meines Skripts! Abonniere gerne den Kanal PonosNasral'
    ask_update     = 'Möchtest du diese Mods aktualisieren? (Ja - 1, Nein - 2)'
    invalid_input  = 'Ungültige Eingabe. Gib 1 oder 2 ein.'
    cancelled      = 'Update vom Benutzer abgebrochen.'
    game_red       = 'ACHTUNG: Das Spiel PEAK läuft gerade!'
    files_locked   = 'Die Mod-Dateien sind gesperrt, das Update kann fehlschlagen.'
    ask_anyway     = 'Update trotzdem fortsetzen? (Ja - 1, Nein - 2)'
    cancel_close   = 'Update vom Benutzer abgebrochen. Schließe das Spiel und starte das Skript erneut.'
    continuing     = 'Fahre auf Entscheidung des Benutzers fort...'
    starting       = 'Beginne das Update von {0} Mod(s)...'
    target_exists  = '    Zielordner existiert bereits, entferne Überbleibsel: {0}'
    downloading    = '    Lade herunter (Versuch {0})...'
    dl_failed      = '    Versuch {0} von {1} fehlgeschlagen: {2}'
    dl_error       = 'Archiv konnte nicht heruntergeladen werden'
    size_mismatch  = 'Dateigröße stimmt nicht überein (erwartet {0} Bytes, erhalten {1} Bytes)'
    not_zip        = 'die heruntergeladene Datei ist kein Zip-Archiv'
    extracting     = '    Entpacke...'
    no_manifest    = 'keine manifest.json im Archiv'
    backup_line    = '    Backup: {0}'
    done_line      = '    Fertig: {0}'
    error_line     = '    FEHLER: {0}'
    rollback       = '    Rollback durchgeführt.'
    upd_header     = '--- UPDATE-ERGEBNIS ---'
    updated_ok     = '  Erfolgreich aktualisiert: {0}'
    errors_list    = '  Fehler: {0}'
    backups_at     = '  Backups alter Versionen: {0}'
    backups_hint   = '  (Du kannst die Backups löschen, wenn das Spiel korrekt läuft)'
    lang_title     = '=== SPRACHAUSWAHL ==='
    lang_menu      = '  1 - English    2 - Русский'
    lang_menu2     = '  3 - Español    4 - Português  5 - Deutsch'
    lang_menu3     = '  6 - Français'
    lang_choose    = 'Sprache wählen (1-6):'
    lang_saved     = 'Sprache gespeichert: {0}'
    lang_invalid   = 'Ungültige Auswahl. Gib eine Zahl von 1 bis 6 ein.'
}

$L.fr = @{
    err_not_game   = 'ERREUR : le programme n''est pas dans le dossier du jeu !'
    err_location   = 'Emplacement actuel : {0}'
    err_move       = 'Déplacez le programme dans PEAK\BepInEx\plugins et relancez-le.'
    enter_exit     = 'Appuyez sur Entrée pour quitter'
    selftest_fail  = 'ERREUR D''AUTOTEST : Compare-Versions "{0}" vs "{1}" = {2} (attendu {3})'
    banner         = '=== PEAK Mod Updater (ThunderStore) by PonosNasral ==='
    fetching       = 'Récupération du catalogue de mods PEAK depuis ThunderStore...'
    attempt        = 'Tentative {0} sur {1}. Patientez.. Raison : {2}'
    catalog_fail   = 'ERREUR : impossible de récupérer le catalogue ThunderStore après {0} tentatives.'
    catalog_count  = 'Mods trouvés dans le catalogue : {0}'
    installed_cnt  = 'Mods ThunderStore installés : {0}'
    empty_folder   = '{0} (dossier vide — installation peut-être corrompue)'
    broken_mani    = '{0} (manifest.json corrompu)'
    res_header     = '--- RÉSULTAT DE LA VÉRIFICATION ---'
    notfound_note  = '{0} {1} (absent de ThunderStore, ignoré)'
    deps_header    = 'Dépendances manquantes (pour les mods à mettre à jour) :'
    dep_missing    = '  [DEP] {0} — non installé'
    dep_hint       = '  Installez-les depuis ThunderStore, sinon le mod risque de ne pas fonctionner.'
    dll_header     = 'Fichiers .dll directement dans plugins (version indéterminable) :'
    dll_hint       = '  Astuce : décompressez le zip du mod en dossier dans plugins au lieu d''y déposer le .dll — ainsi le script fonctionnera'
    skipped_hdr    = 'Ignorés (dossiers non-ThunderStore) :'
    summary        = 'Bilan : à jour — {0}, à mettre à jour — {1}, introuvables — {2}'
    all_uptodate   = 'Tous les mods sont à jour. Aucune mise à jour nécessaire.'
    game_warn      = 'ATTENTION : le jeu PEAK est en cours d''exécution. Il est conseillé de quitter le jeu !'
    thanks         = 'Merci d''utiliser mon script ! Abonnez-vous à la chaîne PonosNasral si vous le souhaitez'
    ask_update     = 'Voulez-vous mettre à jour ces mods ? (Oui - 1, Non - 2)'
    invalid_input  = 'Saisie invalide. Entrez 1 ou 2.'
    cancelled      = 'Mise à jour annulée par l''utilisateur.'
    game_red       = 'ATTENTION : le jeu PEAK est en cours d''exécution !'
    files_locked   = 'Les fichiers des mods sont verrouillés, la mise à jour peut échouer.'
    ask_anyway     = 'Continuer la mise à jour quand même ? (Oui - 1, Non - 2)'
    cancel_close   = 'Mise à jour annulée par l''utilisateur. Fermez le jeu et relancez le script.'
    continuing     = 'Poursuite selon la décision de l''utilisateur...'
    starting       = 'Début de la mise à jour de {0} mod(s)...'
    target_exists  = '    Le dossier cible existe déjà, suppression du reste : {0}'
    downloading    = '    Téléchargement (tentative {0})...'
    dl_failed      = '    La tentative {0} sur {1} a échoué : {2}'
    dl_error       = 'impossible de télécharger l''archive'
    size_mismatch  = 'la taille du fichier téléchargé ne correspond pas (attendu {0} octets, reçu {1} octets)'
    not_zip        = 'le fichier téléchargé n''est pas une archive zip'
    extracting     = '    Extraction...'
    no_manifest    = 'pas de manifest.json dans l''archive'
    backup_line    = '    Sauvegarde : {0}'
    done_line      = '    Terminé : {0}'
    error_line     = '    ERREUR : {0}'
    rollback       = '    Annulation effectuée.'
    upd_header     = '--- RÉSULTAT DE LA MISE À JOUR ---'
    updated_ok     = '  Mis à jour avec succès : {0}'
    errors_list    = '  Erreurs : {0}'
    backups_at     = '  Sauvegardes des anciennes versions : {0}'
    backups_hint   = '  (Vous pouvez supprimer les sauvegardes si le jeu fonctionne correctement)'
    lang_title     = '=== CHOIX DE LA LANGUE ==='
    lang_menu      = '  1 - English    2 - Русский'
    lang_menu2     = '  3 - Español    4 - Português  5 - Deutsch'
    lang_menu3     = '  6 - Français'
    lang_choose    = 'Choisissez la langue (1-6) :'
    lang_saved     = 'Langue enregistrée : {0}'
    lang_invalid   = 'Choix invalide. Entrez un nombre de 1 à 6.'
}

# ============================================================
#  LANGUAGE DETECTION: lang.txt -> Windows UI language -> en
# ============================================================
$LangFile = Join-Path $PluginsDir 'lang.txt'
$langNames = @{ en = 'English'; ru = 'Русский'; es = 'Español'; pt = 'Português'; de = 'Deutsch'; fr = 'Français' }
$langCodes = @('en','ru','es','pt','de','fr')

$lang = 'en'
if (Test-Path -LiteralPath $LangFile) {
    $saved = (Get-Content -LiteralPath $LangFile -Raw -ErrorAction SilentlyContinue).Trim().ToLower()
    if ($langCodes -contains $saved) { $lang = $saved }
} else {
    try {
        $uiLang = [System.Globalization.CultureInfo]::CurrentUICulture.TwoLetterISOLanguageName.ToLower()
        if ($langCodes -contains $uiLang) { $lang = $uiLang }
    } catch { }
}
$T = $L[$lang]

# ============================================================
#  /lang ARGUMENT -> language selection menu
# ============================================================
$langMode = $false
foreach ($a in @($args)) { if ("$a" -match '^[-/]lang$') { $langMode = $true } }

if ($langMode) {
    Write-Host ''
    Write-Host $T.lang_title -ForegroundColor Cyan
    Write-Host $T.lang_menu
    Write-Host $T.lang_menu2
    Write-Host $T.lang_menu3
    $pick = 0
    while ($pick -lt 1 -or $pick -gt 6) {
        $ans = Read-Host $T.lang_choose
        if ($ans -match '^\d+$') { $pick = [int]$ans }
        if ($pick -lt 1 -or $pick -gt 6) { Write-Host $T.lang_invalid -ForegroundColor Red }
    }
    $lang = $langCodes[$pick - 1]
    [IO.File]::WriteAllText($LangFile, $lang, (New-Object System.Text.UTF8Encoding $false))
    $T = $L[$lang]
    Write-Host ($T.lang_saved -f $langNames[$lang]) -ForegroundColor Green
    try { [void](Read-Host $T.enter_exit) } catch { }
    exit 0
}

# ============================================================
#  CONSOLE SETUP (font depends on language)
# ============================================================
try {
    Add-Type -AssemblyName System.Windows.Forms
    $cs = '[DllImport("user32.dll")] public static extern IntPtr GetConsoleWindow(); [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr hWnd, out RECT rect); [DllImport("user32.dll")] public static extern bool MoveWindow(IntPtr hWnd, int x, int y, int w, int h, bool repaint); public struct RECT { public int Left, Top, Right, Bottom; } public struct COORD { public short X; public short Y; } [DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int nStdHandle); [DllImport("kernel32.dll")] public static extern bool SetConsoleScreenBufferSize(IntPtr hConsoleOutput, COORD dwSize);'
    Add-Type -Name Win32 -Namespace Native -MemberDefinition $cs
    if (-not [Console]::IsOutputRedirected) {
        # For Chinese: UTF-8 codepage + CJK font
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
    if (-not [Console]::IsOutputRedirected) {
        try { & mode.com con cols=100 lines=30 | Out-Null } catch { }
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

try { $Host.UI.RawUI.WindowTitle = 'PEAK Mod Updater by PonosNasral' } catch { }
try {
    Add-Type -Name Title -Namespace Native -MemberDefinition '[DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)] public static extern bool SetConsoleTitleW(string lpConsoleTitle);'
    [void][Native.Title]::SetConsoleTitleW('PEAK Mod Updater by PonosNasral')
} catch { }

# ============================================================
#  PATH CHECK (must be in PEAK\BepInEx\plugins)
# ============================================================
$parentName = Split-Path -Leaf (Split-Path -Parent $PluginsDir)
$gameExe = Join-Path (Split-Path -Parent (Split-Path -Parent $PluginsDir)) 'PEAK.exe'
if ($parentName -ne 'BepInEx' -or -not (Test-Path -LiteralPath $gameExe)) {
    Write-Host $T.err_not_game -ForegroundColor Red
    Write-Host ($T.err_location -f $PluginsDir) -ForegroundColor Red
    Write-Host $T.err_move -ForegroundColor Red
    try { [void](Read-Host $T.enter_exit) } catch { }
    exit 1
}

# --- Log file ---
$LogFile = Join-Path $PluginsDir 'updater_log.txt'
try { Start-Transcript -Path $LogFile -Append | Out-Null } catch { }

$ApiUrl     = 'https://thunderstore.io/c/peak/api/v1/package/'
$BackupDir  = Join-Path $PluginsDir '.mod_backups'
$MaxRetries = 10

# --- Version comparison (semver-like) ---
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

# --- Self test ---
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
        Write-Host ($T.selftest_fail -f $vt[0], $vt[1], $r, $vt[2]) -ForegroundColor Red
        try { [void](Read-Host $T.enter_exit) } catch { }
        exit 1
    }
}

Write-Host $T.banner -ForegroundColor Cyan

# --- Fetch ThunderStore catalog ---
Write-Host "`n$($T.fetching)" -ForegroundColor Cyan
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$catalog = $null
for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
    try {
        $catalog = Invoke-RestMethod -Uri $ApiUrl -TimeoutSec 90
        break
    } catch {
        Write-Host ($T.attempt -f $attempt, $MaxRetries, $_.Exception.Message) -ForegroundColor DarkYellow
        if ($attempt -lt $MaxRetries) { Start-Sleep -Seconds 5 }
    }
}
if (-not $catalog) {
    Write-Host ($T.catalog_fail -f $MaxRetries) -ForegroundColor Red
    try { [void](Read-Host $T.enter_exit) } catch { }; exit 1
}

$byName     = @{}
$byFullName = @{}
foreach ($p in $catalog) {
    $key = $p.name.ToLower()
    if (-not $byName.ContainsKey($key)) { $byName[$key] = $p }
    $byFullName[$p.full_name.ToLower()] = $p
}
$byUuid = @{}
foreach ($p in $catalog) {
    foreach ($v in $p.versions) { $byUuid[$v.uuid4] = $p.full_name }
}
Write-Host ($T.catalog_count -f $catalog.Count) -ForegroundColor Gray

# --- Scan installed mods ---
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
            $skipped += ($T.empty_folder -f $dir.Name)
        }
        return
    }
    try {
        $m = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    } catch {
        $skipped += ($T.broken_mani -f $dir.Name)
        return
    }
    $installed += [PSCustomObject]@{
        Dir     = $dir
        Name    = $m.name
        Version = $m.version_number
    }
}

Write-Host ($T.installed_cnt -f $installed.Count) -ForegroundColor Gray

$dllMods = @(Get-ChildItem -LiteralPath $PluginsDir -File -Filter '*.dll' -ErrorAction SilentlyContinue)

# --- Compare versions ---
$upToDate = @(); $outdated = @(); $notFound = @()

foreach ($mod in $installed) {
    $pkg = $null
    $folderKey = ($mod.Dir.Name -replace '-\d+(\.\d+)*(-[\w.]+)?$', '').ToLower()
    if ($byFullName.ContainsKey($folderKey)) { $pkg = $byFullName[$folderKey] }
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

# --- Report ---
Write-Host "`n$($T.res_header)" -ForegroundColor Cyan
foreach ($m in $upToDate) {
    Write-Host ("  [OK]        {0} {1}" -f $m.Name, $m.Version) -ForegroundColor Green
}
foreach ($o in $outdated) {
    Write-Host ("  [UPDATE]    {0}: {1}  ->  {2}" -f $o.Mod.Name, $o.Mod.Version, $o.NewVer) -ForegroundColor Yellow
}
foreach ($m in $notFound) {
    Write-Host ('  [NOT FOUND] ' + ($T.notfound_note -f $m.Name, $m.Version)) -ForegroundColor DarkYellow
}
# --- Dependency check ---
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
    Write-Host "`n$($T.deps_header)" -ForegroundColor Yellow
    foreach ($d in $missingDeps) {
        Write-Host ($T.dep_missing -f $d) -ForegroundColor Yellow
    }
    Write-Host $T.dep_hint -ForegroundColor DarkYellow
}
if ($dllMods.Count -gt 0) {
    Write-Host "`n$($T.dll_header)" -ForegroundColor Yellow
    foreach ($d in $dllMods) {
        Write-Host ('  [DLL] {0}' -f $d.Name) -ForegroundColor Yellow
    }
    Write-Host $T.dll_hint -ForegroundColor DarkYellow
}
if ($skipped.Count -gt 0) {
    Write-Host "`n$($T.skipped_hdr)" -ForegroundColor DarkGray
    foreach ($s in $skipped) { Write-Host ("  - {0}" -f $s) -ForegroundColor DarkGray }
}
Write-Host ("`n" + ($T.summary -f $upToDate.Count, $outdated.Count, $notFound.Count)) -ForegroundColor Cyan

# --- Nothing to update ---
if ($outdated.Count -eq 0) {
    Write-Host "`n$($T.all_uptodate)" -ForegroundColor Green
    if (Get-Process -Name 'PEAK' -ErrorAction SilentlyContinue) {
        Write-Host $T.game_warn -ForegroundColor Yellow
    }
    Write-Host $T.thanks -ForegroundColor Magenta
    try { [void](Read-Host $T.enter_exit) } catch { }; exit 0
}

# --- Ask to update ---
$choice = 0
while ($choice -ne 1 -and $choice -ne 2) {
    $answer = Read-Host $T.ask_update
    if ($answer -eq '1') { $choice = 1 }
    elseif ($answer -eq '2') { $choice = 2 }
    else { Write-Host $T.invalid_input -ForegroundColor Red }
}
if ($choice -eq 2) {
    Write-Host "`n$($T.cancelled)" -ForegroundColor Cyan
    Write-Host $T.thanks -ForegroundColor Magenta
    try { [void](Read-Host $T.enter_exit) } catch { }; exit 0
}

# --- Game running check ---
$gameProc = Get-Process -Name 'PEAK' -ErrorAction SilentlyContinue
if ($gameProc) {
    Write-Host "`n$($T.game_red)" -ForegroundColor Red
    Write-Host $T.files_locked -ForegroundColor Red
    $choice = 0
    while ($choice -ne 1 -and $choice -ne 2) {
        $answer = Read-Host $T.ask_anyway
        if ($answer -eq '1') { $choice = 1 }
        elseif ($answer -eq '2') { $choice = 2 }
        else { Write-Host $T.invalid_input -ForegroundColor Red }
    }
    if ($choice -eq 2) {
        Write-Host "`n$($T.cancel_close)" -ForegroundColor Cyan
        Write-Host $T.thanks -ForegroundColor Magenta
        try { [void](Read-Host $T.enter_exit) } catch { }; exit 0
    }
    Write-Host $T.continuing -ForegroundColor DarkYellow
}

# --- Update ---
Write-Host ("`n" + ($T.starting -f $outdated.Count)) -ForegroundColor Cyan
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
        if (Test-Path -LiteralPath $newDirPath) {
            Write-Host ($T.target_exists -f $newDirName) -ForegroundColor DarkYellow
            Remove-Item -LiteralPath $newDirPath -Recurse -Force
        }

        $tmp = Join-Path $env:TEMP ("peakmod_" + [Guid]::NewGuid().ToString('N'))
        New-Item -ItemType Directory -Path $tmp | Out-Null
        $zipPath = Join-Path $tmp 'mod.zip'

        $downloaded = $false
        for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
            try {
                Write-Host ($T.downloading -f $attempt) -ForegroundColor Gray
                Invoke-WebRequest -Uri $dlUrl -OutFile $zipPath -TimeoutSec 120 -UseBasicParsing
                $downloaded = $true
                break
            } catch {
                Write-Host ($T.dl_failed -f $attempt, $MaxRetries, $_.Exception.Message) -ForegroundColor DarkYellow
                if ($attempt -lt $MaxRetries) { Start-Sleep -Seconds 5 }
            }
        }
        if (-not $downloaded) { throw $T.dl_error }

        $expectedSize = $o.Pkg.versions[0].filesize
        $actualSize = (Get-Item -LiteralPath $zipPath).Length
        if ($expectedSize -and $actualSize -ne $expectedSize) {
            throw ($T.size_mismatch -f $expectedSize, $actualSize)
        }

        $fs = [IO.File]::OpenRead($zipPath)
        try {
            $magic = New-Object byte[] 2
            [void]$fs.Read($magic, 0, 2)
        } finally { $fs.Close() }
        if ($magic[0] -ne 0x50 -or $magic[1] -ne 0x4B) {
            throw $T.not_zip
        }

        Write-Host $T.extracting -ForegroundColor Gray
        $extractDir = Join-Path $tmp 'extracted'
        Expand-Archive -LiteralPath $zipPath -DestinationPath $extractDir

        if (-not (Test-Path -LiteralPath (Join-Path $extractDir 'manifest.json'))) {
            throw $T.no_manifest
        }

        $backupPath = Join-Path $BackupDir ("{0}_{1}" -f $mod.Dir.Name, (Get-Date -Format 'yyyyMMdd_HHmmss'))
        Write-Host ($T.backup_line -f $backupPath) -ForegroundColor Gray
        Move-Item -LiteralPath $mod.Dir.FullName -Destination $backupPath

        Move-Item -LiteralPath $extractDir -Destination $newDirPath

        Write-Host ($T.done_line -f $newDirName) -ForegroundColor Green
        $success++
    }
    catch {
        Write-Host ($T.error_line -f $_.Exception.Message) -ForegroundColor Red
        $failed += $name
        if ($backupPath -and (Test-Path -LiteralPath $backupPath) -and -not (Test-Path -LiteralPath $mod.Dir.FullName)) {
            Move-Item -LiteralPath $backupPath -Destination $mod.Dir.FullName
            Write-Host $T.rollback -ForegroundColor Gray
        }
    }
    finally {
        if ($tmp -and (Test-Path -LiteralPath $tmp)) { Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue }
    }
}

# --- Backup cleanup (keep last 3 per mod) ---
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

# --- Summary ---
Write-Host "`n$($T.upd_header)" -ForegroundColor Cyan
Write-Host ($T.updated_ok -f $success) -ForegroundColor Green
if ($failed.Count -gt 0) {
    Write-Host ($T.errors_list -f ($failed -join ', ')) -ForegroundColor Red
}
Write-Host ($T.backups_at -f $BackupDir) -ForegroundColor Gray
Write-Host $T.backups_hint -ForegroundColor DarkGray
Write-Host $T.thanks -ForegroundColor Magenta

Write-Host ""
try { Stop-Transcript | Out-Null } catch { }
try { [void](Read-Host $T.enter_exit) } catch { }

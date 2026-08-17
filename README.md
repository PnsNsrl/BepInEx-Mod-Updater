# BepInEx Mod Updater (ThunderStore)

Universal mod updater for ANY game with BepInEx and a ThunderStore community. No launcher required!

## Features
- Scans ALL Steam libraries on ALL drives (C:, D:, ...) automatically
- Detects every installed game with BepInEx
- Matches games to their ThunderStore community automatically
- Compares installed mod versions with the latest on ThunderStore
- Updates outdated mods in one click with automatic backups and rollback on errors
- Warns if the game is running and if mod dependencies are missing
- 6 languages: English, Русский, Español, Português, Deutsch, Français

## Usage
1. Run `BepInExUpdater.ps1` (or the compiled exe) from anywhere
2. Select a game from the list (if several are found)
3. Review the check results and confirm the update

## Language
Run with the `/lang` argument to pick a language. It is saved to `lang.txt` next to the script and auto-detected on next start.

## Notes
- Mods must be installed as folders (ThunderStore style) in `BepInEx/plugins` for version detection to work.
- Old mod versions are backed up to `BepInEx/plugins/.mod_backups` (last 3 per mod are kept).
- A log is written to `BepInEx/plugins/updater_log.txt` of the selected game.

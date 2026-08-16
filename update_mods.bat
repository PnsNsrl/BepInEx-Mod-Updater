@echo off
rem PEAK ThunderStore mod updater launcher (runs update_mods.ps1)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0update_mods.ps1"
pause
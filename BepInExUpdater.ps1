# ============================================================
#  BepInEx ThunderStore Mod Updater by PonosNasral (universal)
#  Works with ANY game that has BepInEx + a ThunderStore community
#  Scans ALL Steam libraries on ALL drives (C:, D:, ...)
#  6 languages: en / ru / es / pt / de / fr
# ============================================================

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'

$exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
if ($exePath -and $exePath.EndsWith('.exe') -and ((Split-Path -Leaf $exePath) -notmatch 'powershell|pwsh')) {
    $SelfDir = Split-Path -Parent $exePath
} elseif ($PSCommandPath) {
    $SelfDir = Split-Path -Parent $PSCommandPath
} else {
    $SelfDir = $PSScriptRoot
}

Write-Host '=== BepInEx Mod Updater (ThunderStore) by PonosNasral ===' -ForegroundColor Cyan
Write-Host 'placeholder - full version pending editor availability'
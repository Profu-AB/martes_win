# Determine the directory of the current script
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define variables
$StartMenu = Join-Path $env:APPDATA "ProgramData\Microsoft\Windows\Start Menu\Programs\MDEV"


$ShortcutName = "MDEV.lnk"

# Ensure the MDEV folder exists
if (-not (Test-Path -Path $StartMenu)) {
    New-Item -ItemType Directory -Path $StartMenu -Force | Out-Null
}

# Construct the target path: adjust as needed
$TargetPath = Join-Path (Join-Path $ScriptDir "..\start") "start.bat"

$IconLocation = "$env:SystemRoot\system32\shell32.dll,1"

# Define the full path for the shortcut
$ShortcutPath = Join-Path $StartMenu $ShortcutName

# Create the shortcut
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = $TargetPath
$Shortcut.WorkingDirectory = Split-Path -Path $TargetPath
$Shortcut.IconLocation = $IconLocation
$Shortcut.Save()

Write-Output "Shortcut created at '$ShortcutPath' pointing to '$TargetPath'"

@echo off
setlocal

REM Define where the Start Menu folder is (for current user)
set "StartMenu=%AppData%\Microsoft\Windows\Start Menu\Programs\MyApp"

REM Create the directory if it doesn't exist
if not exist "%StartMenu%" mkdir "%StartMenu%"

REM Define variables for the shortcut
set "ShortcutName=MyBatchShortcut.lnk"
set "TargetPath=C:\Path\To\YourScript.bat"
set "IconLocation=%SystemRoot%\system32\shell32.dll,1"  REM example icon

REM Use a fully qualified path for the temporary VBScript file
set "VBSFile=%TEMP%\CreateShortcut.vbs"

REM Create a temporary VBScript file to create a shortcut
(
echo Set oWS = WScript.CreateObject("WScript.Shell")
echo sLinkFile = "%StartMenu%\%ShortcutName%"
echo Set oLink = oWS.CreateShortcut(sLinkFile)
echo oLink.TargetPath = "%TargetPath%"
echo oLink.WorkingDirectory = "%~dp0"
echo oLink.IconLocation = "%IconLocation%"
echo oLink.Save
) > "%VBSFile%"

REM Check if the VBScript file was created
if not exist "%VBSFile%" (
    echo Failed to create VBScript file at "%VBSFile%".
    pause
    exit /b 1
)

REM Run the VBScript to create the shortcut
cscript //nologo "%VBSFile%"

REM Optionally delete the temporary VBScript
del "%VBSFile%"

echo Shortcut created at "%StartMenu%\%ShortcutName%"
pause

@echo off
:: Get the current folder (where this BAT is located)
set "current_folder=%~dp0"

:: Get the desktop path for the current user
set "desktop=%USERPROFILE%\Desktop"

:: Create a temporary VBScript for creating the shortcut
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%temp%\CreateShortcut.vbs"
echo sLinkFile = "%desktop%\Martes.lnk" >> "%temp%\CreateShortcut.vbs"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%temp%\CreateShortcut.vbs"
echo oLink.TargetPath = "%current_folder%Martes.hta" >> "%temp%\CreateShortcut.vbs"
echo oLink.WorkingDirectory = "%current_folder%" >> "%temp%\CreateShortcut.vbs"
echo oLink.IconLocation = "%current_folder%Profu.ico, 0" >> "%temp%\CreateShortcut.vbs"
echo oLink.Save >> "%temp%\CreateShortcut.vbs"

:: Run the VBScript
cscript //nologo "%temp%\CreateShortcut.vbs"

:: Remove the temporary VBScript
del "%temp%\CreateShortcut.vbs"

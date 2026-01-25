@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

set "ENV_FILE=%~dp0..\.env"

for /f "tokens=1,* delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
  if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

set "PARENT_PATH=%~dp0.."
pushd "%PARENT_PATH%" >nul
set "PARENT_PATH=%cd%"
popd >nul

echo PARENT_PATH (Windows) = %PARENT_PATH%

for /f "delims=" %%i in ('wsl -d %DISTRO_NAME% wslpath "%PARENT_PATH%"') do set "WSL_PARENT_PATH=%%i"

set "RESTORE_PATH=%WSL_PARENT_PATH%/install/backup.sh"
set "BACKUP_PATH=%WSL_PARENT_PATH%/backup"

echo RESTORE_PATH = %RESTORE_PATH%
echo BACKUP_PATH  = %BACKUP_PATH%

wsl -d %DISTRO_NAME% --exec bash -lc "cd '%WSL_PARENT_PATH%' && chmod +x 'install/backup.sh' && 'install/backup.sh' '%BACKUP_PATH%'"

pause

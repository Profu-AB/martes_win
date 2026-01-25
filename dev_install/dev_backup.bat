@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul

REM ===========================
REM Load settings from ..\.env
REM ===========================

set "ENV_FILE=%~dp0..\.env"
if not exist "%ENV_FILE%" (
  echo ERROR: Hittar inte .env: "%ENV_FILE%"
  pause
  exit /b 1
)

for /f "usebackq tokens=1,* delims==" %%a in (`findstr /r "^[^#]" "%ENV_FILE%"`) do (
  if /I "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
  if /I "%%a"=="LINUX_USER_NAME"   set "LINUX_USER_NAME=%%b"
)

if "%DISTRO_NAME%"=="" (
  echo ERROR: DISTRO_DEFAULT_NAME saknas i "%ENV_FILE%"
  pause
  exit /b 1
)

echo Kör dev_backup.sh i WSL distribution "%DISTRO_NAME%"...

REM ===========================
REM Compute project root (parent path)
REM ===========================

set "PARENT_PATH=%~dp0.."
pushd "%PARENT_PATH%" >nul
set "PARENT_PATH=%cd%"
popd >nul

echo PARENT_PATH (Windows) = %PARENT_PATH%

REM ===========================
REM Compute script path
REM ===========================

set "SCRIPT_WIN=%~dp0dev_backup.sh"
if not exist "%SCRIPT_WIN%" (
  echo ERROR: Hittar inte script: "%SCRIPT_WIN%"
  pause
  exit /b 1
)

echo SCRIPT_WIN = %SCRIPT_WIN%

REM ===========================
REM Create dated backup folder (Windows)
REM ===========================

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set "TODAY=%%i"

set "BACKUP_ROOT=%PARENT_PATH%\backups"
set "BACKUP_DIR=%BACKUP_ROOT%\%TODAY%"

if not exist "%BACKUP_DIR%" (
  mkdir "%BACKUP_DIR%"
  if %errorlevel% neq 0 (
    echo ERROR: Kunde inte skapa backup-katalog: "%BACKUP_DIR%"
    pause
    exit /b 1
  )
)

echo BACKUP_DIR (Windows) = %BACKUP_DIR%

REM ===========================
REM Convert paths to WSL paths
REM ===========================

for /f "delims=" %%i in ('wsl -d %DISTRO_NAME% wslpath "%SCRIPT_WIN%"') do set "SCRIPT_WSL=%%i"
for /f "delims=" %%i in ('wsl -d %DISTRO_NAME% wslpath "%PARENT_PATH%"') do set "PARENT_WSL=%%i"
for /f "delims=" %%i in ('wsl -d %DISTRO_NAME% wslpath "%BACKUP_DIR%"') do set "BACKUP_WSL=%%i"

if "%SCRIPT_WSL%"=="" (
  echo ERROR: Kunde inte konvertera SCRIPT_WIN till WSL-path.
  pause
  exit /b 1
)
if "%PARENT_WSL%"=="" (
  echo ERROR: Kunde inte konvertera PARENT_PATH till WSL-path.
  pause
  exit /b 1
)
if "%BACKUP_WSL%"=="" (
  echo ERROR: Kunde inte konvertera BACKUP_DIR till WSL-path.
  pause
  exit /b 1
)

echo SCRIPT_WSL = %SCRIPT_WSL%
echo PARENT_WSL = %PARENT_WSL%
echo BACKUP_WSL = %BACKUP_WSL%

REM ===========================
REM Run backup in WSL
REM Args to dev_backup.sh:
REM   $1 = project root (WSL path)
REM   $2 = backup destination (WSL path)
REM ===========================

wsl -d %DISTRO_NAME% bash -lc "bash '%SCRIPT_WSL%' '%PARENT_WSL%' '%BACKUP_WSL%'"


set "RC=%errorlevel%"

if not "%RC%"=="0" (
  echo ERROR: Backup misslyckades. Exit code: %RC%
  pause
  exit /b %RC%
)

echo klart! "%DISTRO_NAME%".
pause
exit /b 0

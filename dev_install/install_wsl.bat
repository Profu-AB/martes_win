@echo off



REM Detect the current Linux username
for /f "tokens=* delims=" %%i in ('wsl whoami') do set LINUX_USER=%%i
echo Detected Linux user: %LINUX_USER%

REM Check if WSL is installed
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo WSL is not installed. Please install WSL first.
    pause
    exit /b
)

REM Combine sudo commands to avoid multiple password prompts
wsl bash -c "sudo bash -c 'id -u martes &>/dev/null || adduser --disabled-password --gecos \"\" martes; echo \"%LINUX_USER% ALL=(martes) NOPASSWD: ALL\" > /etc/sudoers.d/%LINUX_USER%; echo \"martes ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/martes; rm -rf /home/martes/martes_setup'"

REM Clone the repository if it doesn't exist, otherwise pull the latest changes as martes user
wsl bash -c "sudo -u martes bash -c 'if [ ! -d ~/martes_setup ]; then git clone https://github.com/mmagnemyr/martes_setup.git ~/martes_setup; else cd ~/martes_setup && git pull; fi'"

REM Run setup.sh in the martes_setup folder as martes user
wsl bash -c "sudo -u martes bash -c 'cd ~/martes_setup && bash setup_new.sh'"

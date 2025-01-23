REM Run setup.sh in the martes_setup folder as martes user
wsl bash -c "sudo -u martes bash -c 'cd ~/martes_setup && bash user_access.sh'"
wsl bash -c "sudo service docker restart"
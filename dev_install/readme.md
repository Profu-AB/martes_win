# Utvecklingsmiljö


# wsl

## download distro ubuntu-24.04.3-wsl-amd64.gz

download https://releases.ubuntu.com/noble/ubuntu-24.04.3-wsl-amd64.wsl?_gl=1*1kx7ywm*_gcl_au*OTI3Mjg4Njk2LjE3NTU4NDE3MTg.

## install/import wsl distro to prefered local location
wsl --import Ubuntu-24.04 F:\wsl\Ubuntu2404 F:\ubuntu-24.04.3-wsl-amd64.gz


## 01. Uppdatera .env filen 

DISTRO_NAME=profu-martes
DISTRO_DEFAULT_NAME=Ubuntu-24.04
LICENSE=[din licenskod för martes]
LINUX_USER_NAME=[ditt linux user name som du skall använda i linux tex martin]


## 02. Run add_default_user.bat
Run add_default_user.bat

## 03. 

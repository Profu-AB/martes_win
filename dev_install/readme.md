# Utvecklingsmiljö


# wsl

## 01. download distro ubuntu-24.04.3-wsl-amd64.gz

download https://releases.ubuntu.com/noble/ubuntu-24.04.3-wsl-amd64.wsl?_gl=1*1kx7ywm*_gcl_au*OTI3Mjg4Njk2LjE3NTU4NDE3MTg.

place it in a folder i.e F:\distro
create a folder where you would like the virtual disc to be created on you machine. i.e. F:\wsl\[your selected distro name for the development]

## 02. install/import wsl distro to prefered local location
pick a name that you would like to use for the distro. It could be i.e martes-dev

wsl --import [your selected distro name for the development] F:\wsl\[your selected distro name for the development] F:\distro\ubuntu-24.04.3-wsl-amd64.gz

i.e 
wsl --import martes-dv F:\wsl\martes-dev F:\distro\ubuntu-24.04.3-wsl-amd64.gz


## 01. Uppdatera .env filen in this repo 
if there is no .env file yet just copy .env.template to .env

DISTRO_NAME=profu-martes
DISTRO_DEFAULT_NAME=[your selected distro name for the development]
LICENSE=[din licenskod för martes]
LINUX_USER_NAME=[ditt linux user name som du skall använda i linux tex martin]


## 02. Run setup_wsl.bat
This will install docker and create the user martes etc...

## 03. Run add_default_user.bat
Run add_default_user.bat

this will add the user you selected in the .env file

## 04. Run setpwd.bat with a selected password for the user
./setpwd.bat mynewpassword

## 05. Run user_access.bat
This will give the user name selected in the .env file access to the user martes 


## 06. install vs code server
run ./install_code_server.bat

## 07. clone repo martes_doc
start wsl: wsl -d [DISTRO_NAME]
cd /home/martes
git clone https://github.com/Profu-AB/martes_doc.git

## 08. Configure git
in martes_doc there is a file called setup_git.md 
read it and do what it says

this will configure git so that you can push the code

## 09-get the source code
start wsl: wsl -d [DISTRO_NAME]
cd /home/martes
git clone https://github.com/Profu-AB/martes.git

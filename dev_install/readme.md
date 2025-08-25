# Setup Martes Development Server (WSL)

if you want to completly remove a previous wsl distro run:
wsl --unregister <DistroName>

i.e 
wsl --unregister martes-dev

But be aware of that everyting will be deleted!

## Start
First, clone this repository (If you’re reading this locally, you’ve already done this and can skip the step.)
    git clone https://github.com/Profu-AB/martes_win.git
    
make sure your in \martes_win i.e c:\martes_win if you cloned from c:

## 01. Uppdatera .env filen in this repo 
if there is no .env file yet just copy .env.template to .env
Update the settings in the .env file:

    DISTRO_NAME=profu-martes
    DISTRO_DEFAULT_NAME=[your selected distro name for the development]
    LICENSE=[din licenskod för martes]
    LINUX_USER_NAME=[ditt linux user name som du skall använda i linux tex martin]


## 02. download distro ubuntu-24.04.3-wsl-amd64.gz

download https://releases.ubuntu.com/noble/ubuntu-24.04.3-wsl-amd64.wsl?_gl=1*1kx7ywm*_gcl_au*OTI3Mjg4Njk2LjE3NTU4NDE3MTg.

place it in a folder i.e F:\distro
create a folder where you would like the virtual disc to be created on you machine. i.e. F:\wsl\[your selected distro name for the development]

## 03. install/import wsl distro to prefered local location
pick a name that you would like to use for the distro. It could be i.e martes-dev

wsl --import [your selected distro name for the development] F:\wsl\[your selected distro name for the development] F:\distro\ubuntu-24.04.3-wsl-amd64.gz

i.e 
wsl --import martes-dev F:\wsl\martes-dev F:\distro\ubuntu-24.04.3-wsl-amd64.gz

wsl --import martes-dev c:\wsl\martes-dev c:\users\marti\downloads\ubuntu-24.04.3-wsl-amd64.gz


## 02. Run setup_wsl.bat

cd dev_install (now you should be in martes_win/dev_install)

./setup_wsl.bat

This will install docker and create the user martes etc...


## 03. Run add_default_user.bat
Run add_default_user.bat to add a user with the name you selected in step #01 (LINUX_USER_NAME). This will be the default user.

./add_default_user.bat



## 04. Run setpwd.bat with a selected password for the user
./setpwd.bat [your password]

replace [your password] with a prefered password for the LINUX_USER_NAME

i.e ./setpwd.bat mypwd

## 05. Run user_access.bat
This will give the user name selected in the .env file access to the user martes 

./user_access.bat

## 06. install vs code server
./install_code_server.bat


## 07. clone repo martes_doc
start wsl: wsl -d [DISTRO_NAME] --exec bash -c "cd /home/martes/ && exec bash"
i.e. 
wsl -d martes-dev --exec bash -c "cd /home/martes/ && exec bash"

git clone https://github.com/Profu-AB/martes_doc.git

## 08. Configure git
go to 
cd /home/martes/martes_doc
run code so that you can read setup_git.md
code .

Follow the instructions in setup_git.md
this will configure git so that you can clone private repos

## 09 setup docker
docker login

use user name: dev.martes@profu.se

## 10 OPTIONAL setup firebase
firebase login

## 11. source code
cd ..
you should now be in /home/martes

git clone https://github.com/mmagnemyr/martes.git

this only works if you have successfully configured git

## 12. start dev
- cd /home/martes/martes/docker/dev
- make sure home.sh sets env variable MARTES_HOME to root folder for the source code (open with nano or just cat ./home.sh)
- run the script
-   source ./home.sh

### 12.1 run the dev containers
- ./up.sh
- the frontend container (angular) mounts (volume) folder app to the frontend folder in MARTES_HOME (/martes/frontend)
    - so just go to \martes\frontend and start code . to start develop
    - if you need to bash into the container use
        - ./docker_bash.sh
            - here you can i.e build the code with ng build --configuration web
            - then you can exit the bash with exit and do a firebase deploy to the web if you want to

- the backend container (python) mounts (volume) app to the backend folder in MARTES_HOME (/martes/backend/app)
    - so just go to \martes\backend\app and start code . to start develop
    - if you need to bash into the container use ./martes/backend/docker_bash.sh
    - output logs from the flask app can be seen herer ./martes/backend/

### 12.2 build new versions of the dev containers
- ./build.sh

### 12.3 stop the dev containers
- ./down.sh

### 12.4 update the dev containers from docker
- ./update.sh


### start the back end container
cd /home/martes/backend
./docker_bash.sh

start the python server
python server.py

### View container home pages:
in your local browser go to the py server page
 http://localhost:9000/
and then the frontend 
http://localhost:4200 

### install mongodb compass on your local host (windows)

#### download link
https://downloads.mongodb.com/compass/mongodb-compass-1.46.8-win32-x64.exe

install

create a new connection (make sure the containers are running in wsl)
mongodb exposes port 27019 to windows
in advanced connection options
go to tab "Authentication"
Authentication method: Username/password
Username:admin
Password:secret
Authentication database:admin

# YOURE DONE!!!!!

# tips
stop the production containers if you do not need them during development to save memory!


# repositories
 - files for windows 
    - https://github.com/mmagnemyr/martes_win.git
 
 - installation files for linux
    - https://github.com/mmagnemyr/martes_setup.git
 
 - souce code for the app (frontend and backend)
    - https://github.com/mmagnemyr/martes.git


# notes
## dos2unix tool
sudo apt install dos2unix

## git add .gitattributes
touch .gitattributes
nano .gitattributes
    install/user_access.sh text eol=lf
git add .gitattributes
git commit -m "Add .gitattributes to enforce LF for install/user_access.sh"
git push

## 09-get the source code
start wsl: wsl -d [DISTRO_NAME]
cd /home/martes
git clone https://github.com/Profu-AB/martes.git


## 10 download and start martes docker images
wsl -d [DISTRO_NAME]
wsl -d martes-dev


cd /home/martes/martes/docker/dev
./up.sh
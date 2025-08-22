## setting up git in linux
1. update the .env file so that contains your email and your name
2. run the script setupgit.sh
3. got to https://github.com/settings/keys and paste the ssh-key here
    this step requires that you are logged in in github and have access to the repo. You also need to setup authenticator.


# script example
git config --global user.email "martin.magnemyr@gmail.com"
git config --global user.name "Martin Magnemyr"

ssh-keygen -t rsa -b 4096 -C "martin.magnemyr@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

## add ssh key to github
    - https://github.com/settings/keys
    - this step includes uploading (pasting) your ssh key in git 

    - copy key from cat.. step
    - open settings in github
    - choose SSH and GPG keys in the left menu
    -   in the page find button "New SSH key"
    -   give it a name and scope and paste your ssh key

## back in linux again
ssh -T git@github.com

- expected output
    - Hi username! You've successfully authenticated, but GitHub does not provide shell access.


## : Configure Git to Use SSH by Default
git config --global url."git@github.com:".insteadOf "https://github.com/"


## setup docker
docker login

## setup firebase
firebase login

## source code
git clone https://github.com/mmagnemyr/martes.git

## start dev
- cd \home\username\martes\docker\dev
- make sure home.sh sets env variable MARTES_HOME to root folder for the source code (open with nano or just cat ./home.sh)
- run the script
-   ./home.sh

### run the dev containers
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

### build new versions of the dev containers
- ./build.sh

### stop the dev containers
- ./down.sh


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
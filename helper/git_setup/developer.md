## setting up git in linux

ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

## add ssh key to github
    - https://github.com/settings/keys

## back in linux again
ssh -T git@github.com

- expected output
    - Hi username! You've successfully authenticated, but GitHub does not provide shell access.


## : Configure Git to Use SSH by Default
git config --global url."git@github.com:".insteadOf "https://github.com/"


## docker
docker login




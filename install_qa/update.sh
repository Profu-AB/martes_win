#!/bin/bash

# Get the current directory (Linux path)
CURRENT_PATH=$(pwd)

# turn off the running containers
docker compose -f ./install_qa/docker-compose.yaml down

# pull updates (:test images)
docker compose -f ./install_qa/docker-compose.yaml pull

# start containers
docker compose -f ./install_qa/docker-compose.yaml up -d

# remove any unused containers
docker image prune -f

#!/bin/bash

# Self-heal: ensure install/.env exists (created from .env.template if missing).
# Required because docker-compose.yaml uses ${MONGO_INITDB_ROOT_USERNAME} etc.
if [ ! -f ./install/.env ] && [ -f ./install/.env.template ]; then
    cp ./install/.env.template ./install/.env
    echo "install/.env created from template (self-heal)"
fi

# turn off the running containers
docker compose -f ./install/docker-compose.yaml down

# pull updates
docker compose -f ./install/docker-compose.yaml pull

# start containers
docker compose -f ./install/docker-compose.yaml up -d

# remove any unused containers
docker image prune -f

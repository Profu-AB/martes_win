#!/bin/bash

# Get the current directory (Linux path)
CURRENT_PATH=$(pwd)

# Check if JOULE_OLLAMA is enabled in .env
PROFILE_FLAG=""
if [ -f ".env" ]; then
    JOULE_OLLAMA=$(grep -E "^JOULE_OLLAMA=" .env | cut -d= -f2)
    if [ "$JOULE_OLLAMA" = "true" ]; then
        PROFILE_FLAG="--profile ollama"
        echo "Joule AI (Ollama) enabled - updating with Ollama profile"
    else
        echo "Standard update (without Ollama)"
    fi
else
    echo "No .env file found - standard update"
fi

# turn off the running containers
docker compose -f ./install/docker-compose.yaml $PROFILE_FLAG down

# pull updates
docker compose -f ./install/docker-compose.yaml $PROFILE_FLAG pull

# start containers
docker compose -f ./install/docker-compose.yaml $PROFILE_FLAG up -d

# remove any unused containers
docker image prune -f

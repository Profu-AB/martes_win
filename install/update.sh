
#!/bin/bash

# Get the current directory (Linux path)
CURRENT_PATH=$(pwd)

# turn off the running containers
docker compose -f ./install/docker-compose.yaml down


# pull updates
docker compose  -f ./install/docker-compose.yaml  pull

# start conntainers
# docker compose  -f ./install/docker-compose.yaml up -d

# remove any unused containers
docker image prune -f


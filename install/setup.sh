#!/bin/sh


# Update Alpine and install dependencies
echo "Updating Alpine and installing dependencies..."
apk update
apk add --no-cache \
    curl \
    bash \
    ca-certificates \
    gnupg \
    libseccomp \
    util-linux \
    lsb-release \
    shadow \
    sudo \
    git \
    dbus \
    openrc \
    docker

# Create the necessary directory for Docker Compose v2 plugin
echo "Creating directory for Docker Compose v2 plugin..."
sudo mkdir -p /usr/lib/docker/cli-plugins

# Install Docker Compose v2 (Docker Compose as a plugin)
DOCKER_COMPOSE_VERSION="v2.19.0"  # Latest version of Docker Compose v2
echo "Downloading Docker Compose v2..."
curl -SL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-x86_64 -o /usr/lib/docker/cli-plugins/docker-compose

# Make Docker Compose executable
echo "Making Docker Compose executable..."
chmod +x /usr/lib/docker/cli-plugins/docker-compose

# Ensure Docker daemon starts automatically in the background
echo "Starting Docker daemon..."

# Add Docker start command to ~/.bashrc for automatic startup
echo "nohup sudo dockerd > /dev/null 2>&1 &" >> ~/.bashrc

# Add an echo message to ~/.bashrc to verify it runs
echo "echo 'Welcome to Martes! Docker daemon started.'" >> ~/.bashrc

# Ensure ~/.bashrc is sourced from both ~/.bash_profile and ~/.profile
echo "if [ -f ~/.bashrc ]; then source ~/.bashrc; fi" >> ~/.bash_profile
echo "if [ -f ~/.bashrc ]; then source ~/.bashrc; fi" >> ~/.profile

# Docker daemon configured to start automatically when opening a new terminal
echo "Docker daemon configured to start automatically when opening a new terminal."

# Verify Docker and Docker Compose installation
echo "Verifying Docker installation..."
docker --version
docker compose version

# Configure WSL to enable systemd
echo "Configuring WSL to enable systemd..."
sudo tee /etc/wsl.conf > /dev/null <<EOL
[boot]
systemd=true
EOL

# Set CURRENT_DIR to the directory where the script is located
CURRENT_DIR=$(pwd)

# Finish
echo "Docker and Docker Compose v2 have been installed successfully inside Alpine."
echo "Please run 'wsl --shutdown' from PowerShell or Command Prompt to restart WSL and apply systemd changes."

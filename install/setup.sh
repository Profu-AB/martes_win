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
    dbus-x11 \
    docker

# Enable systemd in WSL
echo "Configuring WSL to enable systemd..."
sudo tee /etc/wsl.conf > /dev/null <<EOL
[boot]
systemd=true
EOL

# Ensure dbus works
echo "Ensuring /run/dbus directory exists..."
mkdir -p /run/dbus

# Ensure Docker daemon starts automatically in the background
echo "Setting up Docker to start on login..."

# Add Docker start command to ~/.bashrc for automatic startup
echo "nohup sudo dockerd > /dev/null 2>&1 &" >> ~/.bashrc

# Add an echo message to ~/.bashrc to verify it runs
echo "echo 'Welcome to Martes! Docker daemon started.'" >> ~/.bashrc

# Ensure ~/.bashrc is sourced from ~/.profile
echo "if [ -f ~/.bashrc ]; then source ~/.bashrc; fi" >> ~/.profile

# Verify Docker and Docker Compose installation
echo "Verifying Docker installation..."
docker --version
docker compose version

# Set CURRENT_DIR to the directory where the script is located
CURRENT_DIR=$(pwd)

# Finish
echo "Docker and Docker Compose v2 have been installed successfully inside Alpine."
echo "Please run 'wsl --shutdown' from PowerShell or Command Prompt to restart WSL and apply systemd changes."

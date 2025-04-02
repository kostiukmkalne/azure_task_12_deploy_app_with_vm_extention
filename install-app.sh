#!/bin/bash
# Script to silently install and start the todo web app on the virtual machine.
# This script runs under root user via VM extension mechanism.

set -e  # Exit immediately if a command exits with a non-zero status.

# Update system and install required packages
echo "Updating system packages..."
apt-get update -yq
apt-get install -yq python3-pip git

# Create a directory for the app and clone the repository
echo "Cloning the application repository..."
APP_DIR="/app"
REPO_URL="https://github.com/Uklonsd/azure_task_12_deploy_app_with_vm_extention.git"

if [ -d "$APP_DIR" ]; then
    rm -rf "$APP_DIR"
fi
mkdir -p "$APP_DIR"
git clone "$REPO_URL" "$APP_DIR"

# Move the systemd service file
echo "Configuring systemd service..."
mv "$APP_DIR/todoapp.service" /etc/systemd/system/

# Reload systemd, start and enable the service
echo "Starting the application service..."
systemctl daemon-reload
systemctl start todoapp
systemctl enable todoapp

# Verify service status
if systemctl is-active --quiet todoapp; then
    echo "Application service started successfully."
else
    echo "Failed to start the application service." >&2
    exit 1
fi

#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "--- Starting Setup Script ---"

# 1. Update package lists and install fastfetch
echo "1. Installing fastfetch..."
sudo apt update
sudo apt install -y fastfetch

# 2. Install lsix library
echo "2. Installing lsix..."
sudo apt install -y lsix

# 3. Move fastfetch contents
# Source directory (Relative path: assumes script is run from project root)
SOURCE_DIR="./fastfetch"
# Destination directory (Using $HOME to target the current user's home folder)
TARGET_DIR="$HOME/.config/fastfetch"

echo "3. Copying configuration files..."

# Check if the source directory exists before copying
if [ -d "$SOURCE_DIR" ]; then
    # Create the destination directory if it does not exist
    mkdir -p "$TARGET_DIR"

    # Copy all contents recursively from source to destination
    cp -r "$SOURCE_DIR/"* "$TARGET_DIR/"
    
    echo "Files copied successfully to: $TARGET_DIR"
else
    echo "Error: Source directory '$SOURCE_DIR' not found!"
    echo "Please ensure you are running the script from the same directory as the fastfetch folder."
    exit 1
fi

echo "--- Setup Completed Successfully ---"
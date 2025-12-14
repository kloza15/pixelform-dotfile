#!/bin/bash

# Exit immediately if a command exits with a non-zero status
# We turn this off temporarily during installation to handle errors gracefully
set -e

echo "--- Starting Advanced Setup Script (Fixed for Fedora) ---"

# 1. Detect System / Distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "Detected System: $NAME ($ID)"
else
    echo "Warning: Unable to detect specific distribution."
fi

# 2. Cleanup: Remove old fastfetch configuration
CONFIG_PATH="$HOME/.config/fastfetch"
echo "Cleaning up old configuration at: $CONFIG_PATH"
if [ -d "$CONFIG_PATH" ]; then
    rm -rf "$CONFIG_PATH"
    echo "Old configuration removed."
else
    echo "No old configuration found. Proceeding..."
fi

# Helper function to install lsix manually from source
# Used when package manager doesn't have lsix (like Fedora)
install_lsix_manually() {
    echo "Attempting to install 'lsix' manually from GitHub..."
    if command -v git &> /dev/null; then
        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/hackerb9/lsix.git "$TEMP_DIR"
        
        # Install to /usr/local/bin so all users can use it
        echo "Installing lsix to /usr/local/bin..."
        sudo cp "$TEMP_DIR/lsix" /usr/local/bin/
        sudo chmod +x /usr/local/bin/lsix
        
        rm -rf "$TEMP_DIR"
        echo "lsix installed successfully via manual method."
    else
        echo "Error: 'git' is required to install lsix manually but it wasn't found."
    fi
}

# 3. Universal Installation Function
install_packages() {
    echo "--- Installing Packages ---"
    
    # Common packages that usually exist in all repos
    # We separated lsix because it often causes errors on Fedora/Arch
    BASE_PACKAGES="fastfetch zsh fish chafa git"
    
    if command -v apt &> /dev/null; then
        # Debian / Ubuntu / Kali
        echo "Using 'apt' package manager..."
        sudo apt update
        # apt usually has lsix, so we try installing it with base packages
        sudo apt install -y $BASE_PACKAGES lsix

    elif command -v pacman &> /dev/null; then
        # Arch Linux
        echo "Using 'pacman' package manager..."
        sudo pacman -Syu --noconfirm $BASE_PACKAGES
        
        # Try installing lsix, if fails, use manual method
        if ! sudo pacman -S --noconfirm lsix 2>/dev/null; then
            install_lsix_manually
        fi

    elif command -v dnf &> /dev/null; then
        # Fedora / RHEL
        echo "Using 'dnf' package manager..."
        # NOTE: We do NOT include lsix here because Fedora repos don't have it.
        # Adding --skip-broken to ignore "already installed" errors if any arise
        sudo dnf install -y $BASE_PACKAGES --skip-broken
        
        # Fedora requires manual install for lsix
        install_lsix_manually

    elif command -v zypper &> /dev/null; then
        # openSUSE
        echo "Using 'zypper' package manager..."
        sudo zypper install -y $BASE_PACKAGES
        install_lsix_manually

    elif command -v apk &> /dev/null; then
        # Alpine Linux
        echo "Using 'apk' package manager..."
        sudo apk add $BASE_PACKAGES lsix

    else
        echo "Error: No supported package manager found."
        exit 1
    fi
}

# Run the installation
install_packages

# 4. Move new configuration files
SOURCE_DIR="./fastfetch"
TARGET_DIR="$HOME/.config/fastfetch"

echo "--- Copying Configuration ---"

# Check if the source directory exists
if [ -d "$SOURCE_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    cp -r "$SOURCE_DIR/"* "$TARGET_DIR/"
    echo "Configuration successfully copied to: $TARGET_DIR"
else
    echo "Error: Source directory '$SOURCE_DIR' not found!"
    echo "Please ensure you are running the script from the same directory as the fastfetch folder."
    exit 1
fi

echo "--- Setup Completed Successfully ---"
echo ""
echo "Installed Shells:"
echo "- Bash: $(command -v bash)"
echo "- Zsh:  $(command -v zsh)"
echo "- Fish: $(command -v fish)"
echo ""
echo "Image Support:"
echo "- lsix: Installed manually/via repo (Best for Konsole)."
echo "- chafa: Installed (Universal fallback for all terminals)."
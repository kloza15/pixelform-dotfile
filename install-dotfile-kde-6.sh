#!/bin/bash

# Exit immediately if a command exits with a non-zero status
# (We will handle specific commands that might fail gracefully)
set -e

echo "--- Starting Setup Script ---"

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

# Helper function to install lsix manually (for Fedora/Arch if repo fails)
install_lsix_manually() {
    echo "Installing 'lsix' manually from GitHub..."
    if command -v git &> /dev/null; then
        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/hackerb9/lsix.git "$TEMP_DIR"
        
        echo "Installing lsix binary to /usr/local/bin..."
        sudo cp "$TEMP_DIR/lsix" /usr/local/bin/
        sudo chmod +x /usr/local/bin/lsix
        
        rm -rf "$TEMP_DIR"
        echo "lsix installed successfully."
    else
        echo "Warning: 'git' is not installed. Cannot install lsix manually."
    fi
}

# 3. Install Packages (fastfetch, chafa, lsix)
install_packages() {
    echo "--- Installing Packages ---"
    
    # We install 'chafa' as a universal fallback for image support
    # We install 'lsix' if available in repo, otherwise manual
    
    if command -v apt &> /dev/null; then
        # Debian / Ubuntu
        echo "Using 'apt'..."
        sudo apt update
        sudo apt install -y fastfetch chafa lsix git

    elif command -v dnf &> /dev/null; then
        # Fedora / RHEL
        echo "Using 'dnf'..."
        # Fedora does NOT have lsix in default repos, so we skip it here to avoid errors
        # using --skip-broken or just installing available ones
        sudo dnf install -y fastfetch chafa git
        
        # Install lsix manually for Fedora
        install_lsix_manually

    elif command -v pacman &> /dev/null; then
        # Arch Linux
        echo "Using 'pacman'..."
        sudo pacman -Syu --noconfirm fastfetch chafa git
        
        # Try installing lsix from repo, if fail, manual
        if ! sudo pacman -S --noconfirm lsix 2>/dev/null; then
            install_lsix_manually
        fi

    elif command -v zypper &> /dev/null; then
        # openSUSE
        echo "Using 'zypper'..."
        sudo zypper install -y fastfetch chafa git
        install_lsix_manually

    elif command -v apk &> /dev/null; then
        # Alpine
        echo "Using 'apk'..."
        sudo apk add fastfetch chafa lsix git

    else
        echo "Error: No supported package manager found."
        exit 1
    fi
}

install_packages

# 4. Move fastfetch contents
SOURCE_DIR="./fastfetch"
TARGET_DIR="$HOME/.config/fastfetch"

echo "--- Copying Configuration ---"

if [ -d "$SOURCE_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    cp -r "$SOURCE_DIR/"* "$TARGET_DIR/"
    echo "Configuration copied to: $TARGET_DIR"
else
    echo "Error: Source directory '$SOURCE_DIR' not found!"
    exit 1
fi

# 5. Add 'fastfetch' to Shell Configs (ONLY if not present)
echo "--- Updating Shell Configurations ---"

# Helper function to append fastfetch command
add_fastfetch_to_rc() {
    local rc_file="$1"
    
    # Only proceed if the file exists
    if [ -f "$rc_file" ]; then
        # Check if fastfetch is already in the file
        if ! grep -q "^fastfetch" "$rc_file" && ! grep -q " fastfetch" "$rc_file"; then
            echo "" >> "$rc_file"
            echo "fastfetch" >> "$rc_file"
            echo "Added fastfetch to $rc_file"
        else
            echo "fastfetch already exists in $rc_file"
        fi
    fi
}

# Apply to Bash
add_fastfetch_to_rc "$HOME/.bashrc"

# Apply to Zsh
add_fastfetch_to_rc "$HOME/.zshrc"

# Apply to Fish
FISH_CONFIG="$HOME/.config/fish/config.fish"
if [ -f "$FISH_CONFIG" ]; then
    if ! grep -q "fastfetch" "$FISH_CONFIG"; then
        echo "" >> "$FISH_CONFIG"
        echo "fastfetch" >> "$FISH_CONFIG"
        echo "Added fastfetch to $FISH_CONFIG"
    else
        echo "fastfetch already exists in $FISH_CONFIG"
    fi
fi

echo "--- Setup Completed Successfully ---"
#!/bin/bash

# ==============================================================================
# Script Name: 1-install-fastfetch-v1-pixelform-dotfile.sh
# Description: Installs fastfetch, tools, fonts, and deploys pixelform configs.
# STATUS: FIXED (lsix manual install enforced for Ubuntu)
# ==============================================================================

# 1. Safety & Configuration
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 2. Path Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_FOLDER_NAME="fastfetch-pixelform-dotfile" 
SOURCE_PATH="${SCRIPT_DIR}/${SOURCE_FOLDER_NAME}"
TARGET_PATH="${HOME}/.config/fastfetch"
FONT_DIR="${HOME}/.local/share/fonts"

# 3. Logging Helper Functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 4. Helper: Manual Install for lsix
install_lsix_manually() {
    log_info "Installing 'lsix' manually from GitHub..."
    if command -v git &> /dev/null; then
        local TEMP_DIR
        TEMP_DIR=$(mktemp -d)
        git clone https://github.com/hackerb9/lsix.git "$TEMP_DIR"
        
        log_info "Copying lsix binary to /usr/local/bin..."
        sudo cp "$TEMP_DIR/lsix" /usr/local/bin/
        sudo chmod +x /usr/local/bin/lsix
        
        rm -rf "$TEMP_DIR"
        log_success "lsix installed successfully."
    else
        log_warn "'git' is missing. Skipping lsix manual install."
    fi
}

# 5. Step 1: Install Dependencies
install_packages() {
    log_info "Detecting System and Installing Packages..."
    
    local TOOLS="git unzip wget"

    if [ -f /etc/os-release ]; then
        . /etc/os-release
        log_info "System: $NAME ($ID)"
        
        if command -v apt &> /dev/null; then
            # Debian / Ubuntu / Mint
            sudo apt update
            # REMOVED 'lsix' from apt because it is not in standard repos
            sudo apt install -y fastfetch chafa $TOOLS
            
            # Trigger manual install for lsix
            install_lsix_manually

        elif command -v dnf &> /dev/null; then
            # Fedora
            sudo dnf install -y fastfetch chafa $TOOLS
            install_lsix_manually

        elif command -v pacman &> /dev/null; then
            # Arch Linux
            sudo pacman -Syu --noconfirm fastfetch chafa $TOOLS
            # Try installing lsix, if fails, do manual
            if ! sudo pacman -S --noconfirm lsix 2>/dev/null; then
                install_lsix_manually
            fi

        elif command -v zypper &> /dev/null; then
            # OpenSUSE
            sudo zypper install -y fastfetch chafa $TOOLS
            install_lsix_manually

        elif command -v apk &> /dev/null; then
            # Alpine
            sudo apk add fastfetch chafa lsix $TOOLS
        else
            log_error "No supported package manager found."
            exit 1
        fi
    else
        log_error "Unable to detect OS distribution."
        exit 1
    fi
    log_success "Packages installed successfully."
}

# 6. Step 2: Deploy Config Files
deploy_configs() {
    log_info "Deploying Configuration..."
    log_info "Source: $SOURCE_PATH"
    
    if [ ! -d "$SOURCE_PATH" ]; then
        log_error "Source directory not found!"
        echo "       Expected path: $SOURCE_PATH"
        exit 1
    fi

    # Clean old config
    if [ -d "$TARGET_PATH" ]; then
        log_warn "Removing old configuration..."
        rm -rf "$TARGET_PATH"
    fi

    # Copy new config
    mkdir -p "$TARGET_PATH"
    cp -r "$SOURCE_PATH/"* "$TARGET_PATH/"
    
    # Set permissions (Corrected from 777 to 755)
    chmod -R 755 "$TARGET_PATH"
    
    log_success "Configuration copied to $TARGET_PATH"
}

# 7. Step 3: Install Hack Font
install_fonts() {
    log_info "Checking Fonts..."
    mkdir -p "$FONT_DIR"

    local TEMP_DIR
    TEMP_DIR=$(mktemp -d)
    local ZIP_FILE="$TEMP_DIR/Hack.zip"
    local URL="https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip"

    log_info "Downloading Hack Font..."
    if wget -O "$ZIP_FILE" "$URL"; then
        log_info "Extracting..."
        unzip -o -q "$ZIP_FILE" -d "$FONT_DIR"
        
        log_info "Updating font cache..."
        fc-cache -fv > /dev/null
        
        rm -rf "$TEMP_DIR"
        log_success "Hack Font installed."
    else
        log_error "Failed to download font."
    fi
}

# 8. Step 4: Update Shell RC Files
update_shell_config() {
    local FILE="$1"
    local CMD="fastfetch"

    if [ -f "$FILE" ]; then
        if ! grep -q "$CMD" "$FILE"; then
            echo "" >> "$FILE"
            echo "# Auto-added by setup script" >> "$FILE"
            echo "$CMD" >> "$FILE"
            log_success "Added $CMD to $FILE"
        else
            log_info "$CMD already exists in $FILE"
        fi
    fi
}

setup_shells() {
    log_info "Updating Shell Configurations..."
    update_shell_config "$HOME/.bashrc"
    update_shell_config "$HOME/.zshrc"
    update_shell_config "$HOME/.config/fish/config.fish"
}

# 9. Main Execution
main() {
    echo ""
    echo "-----------------------------------------------------"
    echo "   Starting Fastfetch & Pixelform Setup              "
    echo "-----------------------------------------------------"

    install_packages
    deploy_configs
    install_fonts
    setup_shells

    echo ""
    echo "#########################################################"
    echo -e "   ${GREEN}SETUP COMPLETED SUCCESSFULLY${NC}"
    echo "#########################################################"
    echo "# ACTION REQUIRED: KDE System Settings                  #"
    echo "# 1. Go to: System Settings -> Fonts                    #"
    echo "# 2. Locate: 'Fixed width'                              #"
    echo "# 3. Change it to: Hack 10pt                            #"
    echo "# 4. Click Apply.                                       #"
    echo "#########################################################"
    echo ""
}

main
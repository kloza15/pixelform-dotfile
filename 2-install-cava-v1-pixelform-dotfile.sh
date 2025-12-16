#!/bin/bash

# ==============================================================================
# Script Name: 2-install-cava-v1-pixelform-dotfile.sh
# Description: Automates the re-installation of 'cava' and deploys custom dotfiles.
# Author:      [Automated Script]
# ==============================================================================

# 1. Safety & Configuration
# ------------------------------------------------------------------------------
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error.
# -o pipefail: Return value of a pipeline is the status of the last command to exit with a non-zero status.
set -euo pipefail

# ANSI Color Codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 2. Path Variables (Relative Logic)
# ------------------------------------------------------------------------------
# Get the absolute path of the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define folder names
SOURCE_FOLDER="cava-pixelform-dotfile"
SOURCE_PATH="${SCRIPT_DIR}/${SOURCE_FOLDER}"
TARGET_PATH="${HOME}/.config/cava"

# 3. Helper Functions
# ------------------------------------------------------------------------------

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 4. Core Logic: Re-install Cava
# ------------------------------------------------------------------------------
install_cava() {
    log_info "Detecting Operating System..."

    if [ -f /etc/os-release ]; then
        # Load OS details
        . /etc/os-release
        log_info "System Detected: $NAME ($ID)"

        case $ID in
            debian|ubuntu|linuxmint|kali|pop|neon|zorin)
                log_warn "Purging old Cava installation..."
                sudo apt remove --purge -y cava || true
                sudo apt autoremove -y
                
                log_info "Installing Cava via apt..."
                sudo apt update
                sudo apt install -y cava
                ;;

            fedora|rhel|centos|nobara)
                log_warn "Removing old Cava installation..."
                sudo dnf remove -y cava || true
                
                log_info "Installing Cava via dnf..."
                sudo dnf install -y cava
                ;;

            arch|manjaro|endeavouros|garuda)
                log_warn "Removing old Cava installation..."
                sudo pacman -Rns --noconfirm cava || true
                
                log_info "Installing Cava via pacman..."
                sudo pacman -Syu --noconfirm cava
                ;;

            opensuse*|suse)
                log_warn "Removing old Cava installation..."
                sudo zypper remove -u -y cava || true
                
                log_info "Installing Cava via zypper..."
                sudo zypper install -y cava
                ;;

            alpine)
                log_warn "Removing old Cava installation..."
                sudo apk del cava || true
                
                log_info "Installing Cava via apk..."
                sudo apk add cava
                ;;

            *)
                log_error "Unsupported distribution: $ID"
                log_info "Please install 'cava' manually."
                exit 1
                ;;
        esac
    else
        log_error "Cannot detect OS: /etc/os-release not found."
        exit 1
    fi
    
    log_success "Cava installed successfully."
}

# 5. Core Logic: Deploy Dotfiles
# ------------------------------------------------------------------------------
deploy_configs() {
    log_info "Preparing to deploy configurations..."
    log_info "Source: ${SOURCE_PATH}"
    log_info "Target: ${TARGET_PATH}"

    # Verify source exists
    if [ ! -d "${SOURCE_PATH}" ]; then
        log_error "Source directory not found!"
        echo "       Expected at: ${SOURCE_PATH}"
        echo "       Please ensure the folder '${SOURCE_FOLDER}' is next to this script."
        exit 1
    fi

    # Clean target
    if [ -d "${TARGET_PATH}" ]; then
        log_warn "Cleaning up existing configuration at target..."
        rm -rf "${TARGET_PATH}"
    fi

    # Create target and copy
    mkdir -p "${TARGET_PATH}"
    log_info "Copying files..."
    cp -r "${SOURCE_PATH}/"* "${TARGET_PATH}/"

    # Set permissions (As requested: 777)
    log_info "Setting permissions to 777..."
    chmod -R 777 "${TARGET_PATH}"

    log_success "Configuration deployed successfully."
}

# 6. Main Execution Flow
# ------------------------------------------------------------------------------
main() {
    echo ""
    echo "-----------------------------------------------------"
    echo "   Starting Cava Setup & Pixelform Dotfile Deploy    "
    echo "-----------------------------------------------------"
    
    install_cava
    echo "-----------------------------------------------------"
    deploy_configs
    
    echo ""
    echo "#####################################################"
    echo -e "   ${GREEN}All tasks completed successfully!${NC}"
    echo "#####################################################"
    echo ""
}

# Run the main function
main
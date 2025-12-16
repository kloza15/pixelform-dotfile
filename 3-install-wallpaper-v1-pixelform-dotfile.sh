#!/bin/bash

# ==============================================================================
# Script Name: 3-install-wallpaper-v1-pixelform-dotfile.sh
# Description: Detects images in the source folder and applies them as wallpaper.
# Author:      [Automated Script]
# ==============================================================================

# 1. Safety & Configuration
# ------------------------------------------------------------------------------
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 2. Path Variables (Relative Logic)
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source folder name (Must be next to the script)
SOURCE_FOLDER_NAME="wallpaper-pixelform-dotfile"
SOURCE_PATH="${SCRIPT_DIR}/${SOURCE_FOLDER_NAME}"

# Target destination to store the wallpaper permanently
TARGET_DIR="${HOME}/Pictures/Wallpapers/Pixelform"

# 3. Helper Functions
# ------------------------------------------------------------------------------
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 4. Step 1: Find and Copy Wallpaper
# ------------------------------------------------------------------------------
prepare_wallpaper() {
    log_info "Searching for wallpaper in: $SOURCE_PATH"

    # Verify source folder exists
    if [ ! -d "$SOURCE_PATH" ]; then
        log_error "Source folder '$SOURCE_FOLDER_NAME' not found!"
        log_info "Please ensure the folder is located next to this script."
        exit 1
    fi

    # Find the first image file (jpg, jpeg, png, webp)
    # We take the first match found.
    IMAGE_FILE=$(find "$SOURCE_PATH" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | head -n 1)

    if [ -z "$IMAGE_FILE" ]; then
        log_error "No valid image files (jpg, png, webp) found inside '$SOURCE_FOLDER_NAME'."
        exit 1
    fi

    log_info "Found image: $(basename "$IMAGE_FILE")"

    # Create target directory
    mkdir -p "$TARGET_DIR"

    # Copy the image to the target directory
    # We rename it to ensure consistency or keep original name. Let's keep original.
    FILENAME=$(basename "$IMAGE_FILE")
    FINAL_WALLPAPER_PATH="${TARGET_DIR}/${FILENAME}"

    cp "$IMAGE_FILE" "$FINAL_WALLPAPER_PATH"
    
    log_success "Wallpaper copied to: $FINAL_WALLPAPER_PATH"
    
    # Export the path for the next function to use
    export WALLPAPER_TO_APPLY="$FINAL_WALLPAPER_PATH"
}

# 5. Step 2: Apply Wallpaper (Environment Detection)
# ------------------------------------------------------------------------------
apply_wallpaper() {
    local WP_PATH="$WALLPAPER_TO_APPLY"
    log_info "Attempting to apply wallpaper to all screens..."
    
    # Detect Desktop Environment
    local DE="${XDG_CURRENT_DESKTOP:-}"
    
    # Check for KDE Plasma
    if [[ "$DE" == *"KDE"* ]]; then
        log_info "Environment detected: KDE Plasma"
        
        # Try the modern command line tool for KDE
        if command -v plasma-apply-wallpaperimage &> /dev/null; then
            plasma-apply-wallpaperimage "$WP_PATH"
            log_success "Wallpaper applied via plasma-apply-wallpaperimage."
        else
            log_warn "'plasma-apply-wallpaperimage' command not found."
            log_info "Please set the wallpaper manually from: $WP_PATH"
        fi

    # Check for GNOME
    elif [[ "$DE" == *"GNOME"* ]]; then
        log_info "Environment detected: GNOME"
        gsettings set org.gnome.desktop.background picture-uri "file://$WP_PATH"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WP_PATH"
        log_success "Wallpaper applied via gsettings."

    # Check for XFCE
    elif [[ "$DE" == *"XFCE"* ]]; then
        log_info "Environment detected: XFCE"
        # XFCE is tricky, needs to loop through monitors.
        # This is a basic attempt for the first monitor/workspace.
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WP_PATH"
        log_success "Wallpaper applied via xfconf-query (Monitor 0)."

    # Fallback / Window Managers (i3, bspwm, etc.) using 'feh'
    else
        log_info "Environment detected: Other / Window Manager ($DE)"
        
        if command -v feh &> /dev/null; then
            feh --bg-fill "$WP_PATH"
            log_success "Wallpaper applied via feh."
            
            # Suggest adding to config
            log_info "Tip: Add 'feh --bg-fill $WP_PATH' to your startup config."
        else
            log_warn "'feh' is not installed. Installing it to apply wallpaper..."
            
            # Quick install attempt based on distro
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case $ID in
                    debian|ubuntu|kali|pop) sudo apt install -y feh ;;
                    arch|manjaro) sudo pacman -S --noconfirm feh ;;
                    fedora) sudo dnf install -y feh ;;
                    opensuse*) sudo zypper install -y feh ;;
                    alpine) sudo apk add feh ;;
                esac
            fi
            
            if command -v feh &> /dev/null; then
                feh --bg-fill "$WP_PATH"
                log_success "Wallpaper applied via feh."
            else
                log_error "Could not install 'feh'. Please set wallpaper manually."
            fi
        fi
    fi
}

# 6. Main Execution
# ------------------------------------------------------------------------------
main() {
    echo ""
    echo "-----------------------------------------------------"
    echo "   Starting Wallpaper Setup (Pixelform)              "
    echo "-----------------------------------------------------"

    prepare_wallpaper
    apply_wallpaper

    echo ""
    echo "#####################################################"
    echo -e "   ${GREEN}WALLPAPER SETUP COMPLETED${NC}"
    echo "#####################################################"
    echo "# Location: $TARGET_DIR"
    echo "#####################################################"
    echo ""
}

main
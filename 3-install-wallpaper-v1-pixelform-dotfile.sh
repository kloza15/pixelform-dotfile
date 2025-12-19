#!/bin/bash

# ==============================================================================
# Script Name: 3-install-wallpaper-v1-pixelform-dotfile.sh
# Description: Detects images in the source folder and applies them as wallpaper.
# STATUS: OK (Optimized)
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
SOURCE_FOLDER_NAME="wallpaper-pixelform-dotfile"
SOURCE_PATH="${SCRIPT_DIR}/${SOURCE_FOLDER_NAME}"
TARGET_DIR="${HOME}/Pictures/Wallpapers/Pixelform"

# 3. Helper Functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 4. Step 1: Find and Copy Wallpaper
prepare_wallpaper() {
    log_info "Searching for wallpaper in: $SOURCE_PATH"

    if [ ! -d "$SOURCE_PATH" ]; then
        log_error "Source folder '$SOURCE_FOLDER_NAME' not found!"
        log_info "Please ensure the folder is located next to this script."
        exit 1
    fi

    # Find the first image file (jpg, jpeg, png, webp)
    IMAGE_FILE=$(find "$SOURCE_PATH" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | head -n 1)

    if [ -z "$IMAGE_FILE" ]; then
        log_error "No valid image files (jpg, png, webp) found inside '$SOURCE_FOLDER_NAME'."
        exit 1
    fi

    log_info "Found image: $(basename "$IMAGE_FILE")"

    mkdir -p "$TARGET_DIR"

    FILENAME=$(basename "$IMAGE_FILE")
    FINAL_WALLPAPER_PATH="${TARGET_DIR}/${FILENAME}"

    cp "$IMAGE_FILE" "$FINAL_WALLPAPER_PATH"
    
    log_success "Wallpaper copied to: $FINAL_WALLPAPER_PATH"
    
    export WALLPAPER_TO_APPLY="$FINAL_WALLPAPER_PATH"
}

# 5. Step 2: Apply Wallpaper (Environment Detection)
apply_wallpaper() {
    local WP_PATH="$WALLPAPER_TO_APPLY"
    log_info "Attempting to apply wallpaper to all screens..."
    
    local DE="${XDG_CURRENT_DESKTOP:-}"
    
    # KDE Plasma
    if [[ "$DE" == *"KDE"* ]]; then
        log_info "Environment detected: KDE Plasma"
        if command -v plasma-apply-wallpaperimage &> /dev/null; then
            plasma-apply-wallpaperimage "$WP_PATH"
            log_success "Wallpaper applied via plasma-apply-wallpaperimage."
        else
            log_warn "'plasma-apply-wallpaperimage' not found. Please set manually."
        fi

    # GNOME
    elif [[ "$DE" == *"GNOME"* ]]; then
        log_info "Environment detected: GNOME"
        gsettings set org.gnome.desktop.background picture-uri "file://$WP_PATH"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$WP_PATH"
        log_success "Wallpaper applied via gsettings."

    # XFCE
    elif [[ "$DE" == *"XFCE"* ]]; then
        log_info "Environment detected: XFCE"
        # Attempt to set for the first monitor/workspace
        if command -v xfconf-query &> /dev/null; then
            xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s "$WP_PATH"
            log_success "Wallpaper applied via xfconf-query."
        else
             log_warn "xfconf-query not found."
        fi

    # Fallback / Window Managers
    else
        log_info "Environment detected: Other / Window Manager ($DE)"
        
        if command -v feh &> /dev/null; then
            feh --bg-fill "$WP_PATH"
            log_success "Wallpaper applied via feh."
        else
            log_warn "'feh' is not installed. Attempting to install..."
            
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
    echo ""
}

main
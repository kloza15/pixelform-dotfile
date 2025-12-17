<div align="center">
  
  # Pixelform Dotfiles Auto-Installer 🎨
  
  **Automate your Linux aesthetic setup with one click.**
  
  <!-- PREVIEW SECTION -->
  <!-- Terminal Preview -->
  <img src="./screenshots/preview.png" alt="Terminal Preview" width="100%" style="border-radius: 10px; margin-bottom: 20px;">
  
  <br>
  
  <!-- Wallpaper Preview -->
  <img src="./screenshots/wallpaper.png" alt="Wallpaper Preview" width="100%" style="border-radius: 10px; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">

  <br><br>

  [![Bash](https://img.shields.io/badge/language-Bash-4EAA25.svg)](https://www.gnu.org/software/bash/)
  [![Linux](https://img.shields.io/badge/OS-Linux-FCC624.svg)](https://www.linux.org/)

</div>

---

## 📖 Overview

Automate the setup of **Fastfetch**, **Cava**, and **Wallpapers** with a specific "Pixelform" aesthetic. These scripts are designed to be distro-agnostic (Debian, Fedora, Arch, OpenSUSE, Alpine) and handle dependencies, configurations, and assets automatically using relative paths.

## 📂 Required Directory Structure

**Important:** These scripts rely on **relative paths**. Ensure your folder structure looks exactly like this before running the scripts. The configuration folders must be in the same directory as the `.sh` files.

```text
/Your-Project-Folder/
│
├── screenshots/                       <-- Create this folder for README images
│   ├── preview.png                    <-- The terminal screenshot
│   └── wallpaper.png                  <-- The wallpaper preview image
│
├── 1-install-fastfetch-v1-pixelform-dotfile.sh
├── fastfetch-pixelform-dotfile/       <-- Contains config.jsonc, logos, etc.
│
├── 2-install-cava-v1-pixelform-dotfile.sh
├── cava-pixelform-dotfile/            <-- Contains config files
│
└── 3-install-wallpaper-v1-pixelform-dotfile.sh
└── wallpaper-pixelform-dotfile/       <-- Contains your .jpg or .png images
```

---

## 🚀 Installation & Usage

First, clone this repository or download the files to your machine. Open your terminal in the directory where the files are located.

### 1. Grant Execution Permissions
Before running any script, you must make them executable:

```bash
chmod +x *.sh
```

### 2. Run Scripts (Individual Mode)
You can run the scripts one by one depending on what you need.

**Step 1: Install Fastfetch, Fonts & Shell Configs**
```bash
./1-install-fastfetch-v1-pixelform-dotfile.sh
```

**Step 2: Install Cava & Audio Configs**
```bash
./2-install-cava-v1-pixelform-dotfile.sh
```

**Step 3: Apply Wallpaper**
```bash
./3-install-wallpaper-v1-pixelform-dotfile.sh
```

---

### 3. Run All Scripts (Combined Mode)
To install everything at once, copy and paste the following command block into your terminal:

```bash
chmod +x *.sh && \
./1-install-fastfetch-v1-pixelform-dotfile.sh && \
./2-install-cava-v1-pixelform-dotfile.sh && \
./3-install-wallpaper-v1-pixelform-dotfile.sh
```
---

## ⌨️ How to Run Manually

Once installed, here is how you can use the tools directly from your terminal:

### 🖥️ Fastfetch
The installer automatically adds Fastfetch to your shell startup (so it appears when you open a new window). To run it manually on demand, simply type:

```bash
fastfetch
```
*Note: This will load the custom Pixelform configuration automatically.*

### 🎵 Cava (Audio Visualizer)
To start the visualizer, play some audio on your system and run:

```bash
cava
```
**Controls:**
*   **UP / DOWN Arrows:** Increase or decrease sensitivity.
*   **LEFT / RIGHT Arrows:** Change bar width.
*   **q** or **CTRL+C:** Quit the application.

---

## 🛠️ Script Details

### 1️⃣ Fastfetch Setup (`1-install-fastfetch...`)
This script configures the terminal system information tool.
*   **System Detection:** Automatically detects OS (Ubuntu, Arch, Fedora, etc.) and uses the correct package manager (`apt`, `dnf`, `pacman`, `zypper`, `apk`).
*   **Dependencies:** Installs `fastfetch`, `chafa` (for images), `git`, `unzip`, and `wget`.
*   **Lsix Support:** If `lsix` isn't in your repo, it compiles it manually from GitHub.
*   **Fonts:** Downloads and installs **Hack Nerd Font** (v3.003) to `~/.local/share/fonts` and updates the cache.
*   **Shell Integration:** Automatically adds `fastfetch` to the startup of `.bashrc`, `.zshrc`, and `config.fish`.
*   **Config Deployment:** Copies configs from the local folder to `~/.config/fastfetch`.

### 2️⃣ Cava Setup (`2-install-cava...`)
This script handles the Cava audio visualizer.
*   **Clean Install:** Performs a `remove --purge` on existing Cava installations to ensure no conflicts occur.
*   **Installation:** Re-installs the latest version via your package manager.
*   **Config Deployment:** Copies your custom dotfiles to `~/.config/cava`.
*   **Permissions:** Automatically sets read/write/execute permissions (777) on the config folder.

### 3️⃣ Wallpaper Setup (`3-install-wallpaper...`)
This script manages your desktop background.
*   **Image Detection:** Scans the `wallpaper-pixelform-dotfile` folder and picks the first image found.
*   **Archiving:** Copies the image to `~/Pictures/Wallpapers/Pixelform/` for safekeeping.
*   **Auto-Apply:** Detects your Desktop Environment and applies the wallpaper:
    *   **KDE Plasma:** Uses `plasma-apply-wallpaperimage`.
    *   **GNOME:** Uses `gsettings`.
    *   **XFCE:** Uses `xfconf-query`.
    *   **WMs (i3, bspwm, etc.):** Auto-installs and uses `feh` as a fallback.

---

### ⚠️ Manual Font Setup
For icons to appear correctly, you must set your **Terminal Font** or **Monospace Font** to **"Hack"**.

*   **KDE Plasma:** System Settings ➜ Appearance ➜ Fonts ➜ Fixed width ➜ **Hack 10pt**.
*   **GNOME Terminal:** Menu ➜ Preferences ➜ Profiles ➜ Text ➜ Custom font ➜ **Hack**.
*   **XFCE Terminal:** Edit ➜ Preferences ➜ Appearance ➜ Font ➜ **Hack**.
*   **Other Terminals:** Go to your terminal settings and select **Hack Nerd Font**.



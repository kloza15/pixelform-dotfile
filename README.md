<div align="center">
  
  # 🎨 Pixelform Dotfiles Auto-Installer
  
  **Transform your Linux aesthetic in seconds.**
  
  <!-- PREVIEW SECTION -->
  <img src="./screenshots/preview.png" alt="Terminal Preview" width="100%" style="border-radius: 10px; margin-bottom: 20px;">
  <img src="./screenshots/wallpaper.png" alt="Wallpaper Preview" width="100%" style="border-radius: 10px; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">

  <br><br>

  [![Bash](https://img.shields.io/badge/language-Bash-4EAA25.svg)](https://www.gnu.org/software/bash/)
  [![Linux](https://img.shields.io/badge/OS-Linux-FCC624.svg)](https://www.linux.org/)

</div>

---

## 🧩 Compatibility & Details

*   **Supported OS:** Debian, Ubuntu, Fedora, Arch Linux, OpenSUSE, Alpine.
*   **Wallpaper Support:** Works automatically on KDE Plasma, GNOME, XFCE, and Window Managers (via `feh`).
*   **Directory Structure:** The scripts use **relative paths**. Do not move the `.sh` files outside the main folder, or they will lose access to the configuration files.

---

## ⚡ Quick Start (Recommended)

Don't want to read? Just copy and paste this entire block into your terminal to install **Fastfetch**, **Cava**, and the **Wallpaper** all at once.

```bash
# 1. Clone repository
git clone https://github.com/kloza15/pixelform-dotfile.git
cd pixelform-dotfile

# 2. Grant permissions and install everything
chmod +x *.sh && \
./1-install-fastfetch-v1-pixelform-dotfile.sh && \
./2-install-cava-v1-pixelform-dotfile.sh && \
./3-install-wallpaper-v1-pixelform-dotfile.sh
```

---

## 🛠️ Custom Installation (Advanced)

If you only want specific parts of the setup, run these scripts individually inside the folder:

| Component | Command | Description |
| :--- | :--- | :--- |
| **System Info** | `./1-install-fastfetch-v1-pixelform-dotfile.sh` | Installs Fastfetch, Fonts, and configures `.bashrc` / `.zshrc`. |
| **Visualizer** | `./2-install-cava-v1-pixelform-dotfile.sh` | Installs Cava and applies audio visualizer configs. |
| **Wallpaper** | `./3-install-wallpaper-v1-pixelform-dotfile.sh` | Detects your desktop (KDE/GNOME/etc.) and applies the background. |

---

## ⚠️ Important: Final Step

**To make the icons appear correctly, you must manually change your terminal font.**

The installer adds **Hack Nerd Font** to your system, but it cannot change your terminal settings for you.

1.  Open your Terminal **Settings** or **Preferences**.
2.  Find the **Font** or **Appearance** section.
3.  Select **"Hack Nerd Font"** (or just "Hack").
4.  *Restart your terminal to see the changes.*

---

## 🎮 How to Use

Once installed, here is how to control your new tools:

### 🖥️ Fastfetch (System Info)
It launches automatically when you open a terminal. To run it again manually:
```bash
fastfetch
```

### 🎵 Cava (Music Visualizer)
Play some music, then run:
```bash
cava
```
**Controls:**
*   `Arrow Keys`: Adjust sensitivity and bar width.
*   `Q`: Quit.

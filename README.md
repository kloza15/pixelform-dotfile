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
*   **Smart Dependency Handling:** Automatically compiles tools like `lsix` from source if they are missing from your distribution's repositories (e.g., on Ubuntu).
*   **Security:** Config files are deployed with secure permissions (`755`), ensuring your system remains safe.
*   **Directory Structure:** The scripts use **relative paths**. Do not move the `.sh` files outside the main folder, or they will lose access to the configuration files.

---

## 🚀 One-Line Installation (Full Setup)

Use this method to install **Fastfetch**, **Cava**, and the **Wallpaper** all at once. Just copy and paste this entire block into your terminal:

```bash
git clone https://github.com/kloza15/pixelform-dotfile.git && \
cd pixelform-dotfile && \
chmod +x *.sh && \
./1-install-fastfetch-v1-pixelform-dotfile.sh && \
./2-install-cava-v1-pixelform-dotfile.sh && \
./3-install-wallpaper-v1-pixelform-dotfile.sh
```

---

## 📦 Individual Module Installation (Single Code)

If you do not want the full package, you can install **just one specific component**.

First, clone the repository and enter the folder:
```bash
git clone https://github.com/kloza15/pixelform-dotfile.git
cd pixelform-dotfile
chmod +x *.sh
```

Then, run **only** the script you need:

### 1️⃣ Install System Info Only (Fastfetch)
Installs Fastfetch, Hack Nerd Font, and terminal configs.
```bash
./1-install-fastfetch-v1-pixelform-dotfile.sh
```

### 2️⃣ Install Visualizer Only (Cava)
Installs the Cava music visualizer and the custom gradient config.
```bash
./2-install-cava-v1-pixelform-dotfile.sh
```

### 3️⃣ Install Wallpaper Only
Detects your desktop environment and applies the Pixelform wallpaper.
```bash
./3-install-wallpaper-v1-pixelform-dotfile.sh
```

---

## ⚠️ Important: Final Step (Fix Broken Icons)

**Do not skip this step.**
If you open your terminal and see **squares (□□□)** or weird question marks instead of icons, it means your terminal is not using the correct font yet.

The script has installed **"Hack Nerd Font"** into your system, but for security reasons, it **cannot** force your terminal to use it. You must change this setting manually.

### How to set the font (Choose your desktop):

#### 1. Konsole (Default for KDE Plasma, Kubuntu, Steam Deck)
1.  Open Konsole.
2.  Go to **Settings** → **Edit Current Profile**.
3.  Click the **Appearance** tab.
4.  Click **Choose Font**.
5.  Select **`Hack Nerd Font`** from the list.
6.  Click OK → Apply.

#### 2. GNOME Terminal (Default for Ubuntu, Fedora, Debian)
1.  Open Terminal.
2.  Click the **Menu button (≡)** in the top right corner → **Preferences**.
3.  Click on your profile (usually named "Unnamed" or "Default") on the left sidebar.
4.  Check the box **"Custom font"**.
5.  Click the font name button and search for **`Hack Nerd Font`**.
6.  Select **Regular** or **Mono** and click Select.

#### 3. Cinnamon Terminal (Default for Linux Mint)
1.  Open Terminal.
2.  Go to **Edit** → **Preferences** (or right-click anywhere and select Preferences).
3.  Select your **Profile** (usually "Unnamed") on the left sidebar.
4.  Click the **Text** tab.
5.  Check the box **"Custom font"**.
6.  Click the button next to it and choose **`Hack Nerd Font`**.

#### 4. XFCE Terminal (Default for Kali Linux, Xubuntu, Lite)
1.  Open Terminal.
2.  Go to **Edit** → **Preferences**.
3.  Click the **Appearance** tab.
4.  Click on the current font name.
5.  Search for **`Hack`** or **`Hack Nerd Font`** and select it.

#### 5. Window Managers & Wayland Compositors
*Includes: **Hyprland**, Sway, Wayfire, River, Niri (Wayland)*
*Includes: **i3**, bspwm, AwesomeWM, Qtile, DWM, Xmonad, Openbox (X11)*

In these environments, the font is controlled by your **Terminal's Configuration File**, not a system menu. Identify which terminal you are using below and update its config:

*   **Kitty** (Default for Hyprland):
    1.  Open: `~/.config/kitty/kitty.conf`
    2.  Add/Edit:
        ```properties
        font_family      Hack Nerd Font
        bold_font        auto
        italic_font      auto
        bold_italic_font auto
        ```

*   **Alacritty** (Popular on i3, bspwm, Wayfire):
    1.  Open: `~/.config/alacritty/alacritty.toml`
    2.  Add/Edit under `[font]`:
        ```toml
        [font]
        normal = { family = "Hack Nerd Font", style = "Regular" }
        size = 12.0
        ```

*   **Foot** (Default for Sway, River):
    1.  Open: `~/.config/foot/foot.ini`
    2.  Add/Edit under `[main]`:
        ```ini
        font=Hack Nerd Font:size=11
        ```

*   **WezTerm** (Advanced Users):
    1.  Open: `~/.config/wezterm/wezterm.lua`
    2.  Add to your config object:
        ```lua
        config.font = wezterm.font 'Hack Nerd Font'
        ```

*   **URxvt / XTerm** (Old school X11 / DWM / Xmonad):
    1.  Open: `~/.Xresources` or `~/.Xdefaults`
    2.  Add:
        ```properties
        URxvt.font: xft:Hack Nerd Font:size=11
        ```
    3.  Reload: `xrdb ~/.Xresources`

---

## 🎮 How to Use Your New Tools

Here is a guide on how to control and customize the tools you just installed.

### 🖥️ Fastfetch (System Information)
This tool displays your system specs (OS, RAM, CPU) alongside a beautiful logo.

*   **Automatic:** It runs automatically every time you open a new terminal window.
*   **Manual Run:**
    ```bash
    fastfetch
    ```
*   **⚙️ Customization (Pro Tip):**
    Want to change the logo, colors, or modules? Edit the configuration file here:
    ```bash
    nano ~/.config/fastfetch/config.jsonc
    ```

### 🎵 Cava (Audio Visualizer)
This tool creates graphical bars that dance to the beat of your music.

1.  **Start Music:** Open Spotify, YouTube, or a music player and play a song.
2.  **Launch Cava:**
    ```bash
    cava
    ```

**⌨️ Keyboard Controls:**
| Key | Action |
| :--- | :--- |
| **`Up` / `Down`** | Increase or decrease sensitivity (if bars are too low or too high). |
| **`Left` / `Right`** | Increase or decrease the width of the bars. |
| **`F` / `B`** | Change the foreground/background color (temporary). |
| **`Q`** or **`Esc`** | Quit and close Cava. |

*   **⚙️ Customization (Pro Tip):**
    To permanently change colors, sensitivity, or frame rate, edit the config:
    ```bash
    nano ~/.config/cava/config
    ```

---

## 🆘 Troubleshooting & Common Issues

If you encounter any issues, find your problem below and copy the commands to fix it.

### 1. 🚫 Permission Denied
*   **Problem:** The terminal says `bash: ./1-install...: Permission denied`.
*   **Reason:** Linux blocks scripts from running for security until you approve them.
*   **Solution:** Run this command inside the folder to unlock all scripts:
    ```bash
    chmod +x *.sh
    ```
### 3. 🖼️ Images/Logo Not Showing in Terminal
*   **Problem:** Fastfetch displays the text logo (ASCII art) instead of the actual image, or `lsix` command runs but shows nothing.
*   **Reason:** **This is a software limitation, not a bug.**
    To display images inside a terminal, the terminal emulator must support specific graphics protocols (like **Sixel** or **Kitty Graphics Protocol**). Most default Linux terminals are designed for *text only* and cannot render pixels.

    **Check your terminal against this list:**

    *   ❌ **Unsupported Terminals (Text Only):**
        *   **GNOME Terminal** (Default on Ubuntu, Fedora, Debian)
        *   **MATE Terminal**
        *   **Terminator**
        *   **Guake**
        *   **Tilix**
        *   **Pantheon Terminal** (Elementary OS)
        *   **LXTerminal**
        *   **XFCE Terminal** (Older versions < 0.9.0)

    *   ✅ **Supported Terminals (Graphics Ready):**
        *   **Kitty** (Highly recommended, best performance)
        *   **Konsole** (Default on KDE Plasma v22.04+)
        *   **WezTerm** (Cross-platform, high feature set)
        *   **Foot** (Fast, Wayland only)
        *   **Ghostty** (Modern, GPU accelerated)
        *   **mlterm**
        *   **XTerm** (If compiled with Sixel support)

*   **Solution:**
    1.  **Test your current terminal:**
        Run the command below. If you see a grid of tiny images, your terminal works. If you see nothing or text, it is incompatible.
        ```bash
        lsix
        ```
    2.  **The Fix:** Install a modern terminal that supports images.
        *   **Option A (Recommended for standard users):** Install **Konsole**.
            ```bash
            sudo apt install konsole     # Debian/Ubuntu
            sudo dnf install konsole     # Fedora
            ```
        *   **Option B (Recommended for power users):** Install **Kitty**.
            ```bash
            sudo apt install kitty       # Debian/Ubuntu
            sudo pacman -S kitty         # Arch
            ```

### 3. 🟥 Broken Icons (Squares/Boxes like □□□)
*   **Problem:** Fastfetch shows squares or weird symbols instead of icons.
*   **Reason:** Your terminal is not using a "Nerd Font". The script installs the font, but **you** must tell the terminal to use it.
*   **Solution:**
    1.  Refresh the system font cache:
        ```bash
        fc-cache -fv
        ```
    2.  **Crucial Step:** Open your Terminal **Preferences/Settings** → **Appearance** → **Font** → Select **"Hack Nerd Font"**.

### 3. 🎵 Cava (Visualizer) Is Frozen or crashing
*   **Problem:** Cava opens, but the bars don't move, or it closes immediately.
*   **Reason:** Cava might be trying to listen to the wrong audio driver (e.g., ALSA instead of PulseAudio/Pipewire).
*   **Solution:** Edit the config file to force the correct audio driver.
    1.  Open the config file:
        ```bash
        nano ~/.config/cava/config
        ```
    2.  Look for `[input]` and change `method`. Try `pulse` first (most common), or `pipewire`:
        ```ini
        # Change this line inside the file:
        method = pulse
        ```
    3.  Press `Ctrl+X`, then `Y`, then `Enter` to save.

### 4. 🖼️ Wallpaper Didn't Change
*   **Problem:** The background is black or didn't change.
*   **Reason:** Your desktop environment might block external scripts, or you are using a Window Manager without a wallpaper tool.
*   **Solution (Manual):**
    *   **GNOME/KDE:** Right-click your desktop → "Change Background" → Pick the image from `pixelform-dotfile/screenshots/wallpaper.png`.
    *   **i3 / bspwm / Hyprland:** Install `feh` and set it manually:
        ```bash
        # Install feh
        sudo apt install feh   # Debian/Ubuntu
        sudo pacman -S feh     # Arch

        # Apply wallpaper
        feh --bg-fill ~/pixelform-dotfile/wallpaper-pixelform-dotfile/wallpaper.png
        ```

### 5. ⏳ Script Stuck at "Installing lsix..."
*   **Problem:** The script seems to freeze when installing `lsix`.
*   **Reason:** On Ubuntu/Debian, `lsix` isn't in the app store. The script is downloading source code and compiling it.
*   **Solution:** **Wait.** It usually takes 30-60 seconds. Do not close the terminal.

### 6. 🔒 "Could not get lock /var/lib/dpkg/lock"
*   **Problem:** You see an error saying "Could not get lock" or "Resource temporarily unavailable".
*   **Reason:** Another update process or "Software Center" is running in the background.
*   **Solution:** Kill the background process and try again:
    ```bash
    sudo killall apt apt-get
    sudo rm /var/lib/apt/lists/lock
    sudo rm /var/cache/apt/archives/lock
    sudo rm /var/lib/dpkg/lock*
    
    # Then run the script again
    ./1-install-fastfetch-v1-pixelform-dotfile.sh
    ```   

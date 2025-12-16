***

# Pixelform Dotfiles Auto-Installer 🎨

Automate the setup of **Fastfetch**, **Cava**, and **Wallpapers** with a specific "Pixelform" aesthetic. These scripts are designed to be distro-agnostic (Debian, Fedora, Arch, OpenSUSE, Alpine) and handle dependencies, configurations, and assets automatically using relative paths.

## 📂 Required Directory Structure

**Important:** These scripts rely on **relative paths**. Ensure your folder structure looks exactly like this before running the scripts. The configuration folders must be in the same directory as the `.sh` files.

```text
/Your-Project-Folder/
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

## ⚠️ Manual Action Required (KDE Users)

The scripts handle almost everything, but GUI settings for fonts in KDE Plasma cannot be changed via script reliably.

1.  Open **System Settings**.
2.  Go to **Appearance** -> **Fonts**.
3.  Find **Fixed width** (Monospace).
4.  Change it to **Hack 10pt**.
5.  Click **Apply**.

---

## 🤝 Contributing
Feel free to fork this repository and submit pull requests if you want to add support for more window managers or specific configurations.

## 📄 License
This project is open-source. Feel free to use and modify it.

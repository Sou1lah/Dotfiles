# ⚡ Hyprland Dotfiles — by sou1lah

A full custom Wayland desktop setup built around **Hyprland**, optimized for speed, minimalism, and eye-candy — with a touch of style and utility.

![screenshot](assets/theme15.png)

---

## 📦 Components

### 🪟 Window Manager
| Tool         | Description                       |
|--------------|-----------------------------------|
| **Hyprland** | Tiling WM with dynamic animations |
| **Waybar**   | Clean status bar with modules     |
| **Rofi**     | App launcher & powermenu (games UI too) |
| **Wlogout**  | Logout UI with style              |
| **Swaync**   | Notification daemon               |
| **Eww**      | Optional widgets & overlays       |
| **Ax-Shell** | Fabric-powered HUD and extras     |

---

### 🎨 Theming

| Tool         | Purpose                            |
|--------------|------------------------------------|
| **Wallust**  | Pywal alternative (GTK/Qt sync)    |
| **Matugen**  | Wallpaper-based color generation   |
| **GTK 2/3/4**| Consistent GTK theming             |
| **QT5ct/6ct**| Set QT themes                      |
| **Kvantum**  | QT theming engine                  |
| **Kitty**    | Themed GPU terminal emulator       |
| **Starship** | Beautiful shell prompt             |

---

### 🧰 Utilities

| Tool         | Purpose                         |
|--------------|---------------------------------|
| **Neovim**   | Full-featured text editor       |
| **Tmux**     | Terminal multiplexer            |
| **Ranger**   | Terminal file manager           |
| **Swappy**   | Wayland screenshot editor       |
| **Fastfetch**| System info fetcher             |
| **Neofetch** | Optional fetch tool             |
| **Btop**     | Graphical resource monitor      |
| **Nix**      | Declarative config (optional)   |
| **Fabric**   | Backend for Ax-Shell            |

---

## 📸 Screenshots

| Theme         | Preview                          |
|---------------|----------------------------------|
| `theme12`     | ![](assets/theme12.png)          |
| `theme13`     | ![](assets/theme13.png)          |
| `theme15`     | ![](assets/theme15.png)          |
| `theme21`     | ![](assets/theme21.png)          |
| `theme31`     | ![](assets/theme31.png)          |
| `16`          | ![](assets/16.png)               |
| `17`          | ![](assets/17.png)               |
| `22`          | ![](assets/22.png)               |
| `23`          | ![](assets/23.png)               |
| `24`          | ![](assets/24.png)               |

---

## 🚀 Features

- 💨 Fast, minimal Hyprland setup
- 🎯 App & game launchers via Rofi
- 🧱 Full modular theming (GTK, QT, Wallpaper)
- 🧼 Clean animations & blur
- 💻 Dev-ready: Neovim, Tmux, Kitty
- 📦 Optional Nix support

---

## ⚙️ Structure

```bash
~/.config/
├── hypr         # Hyprland config
├── waybar       # Bar config
├── rofi         # App launcher
├── Ax-Shell     # Shell UI
├── swaync       # Notifications
├── eww          # Widgets
├── wlogout      # Logout menu
├── kitty        # Terminal
├── nvim         # Neovim setup
├── starship     # Prompt theme
├── ranger       # Terminal file manager
├── matugen      # Wallpaper color extractor
├── wallust      # Theming engine
├── qt5ct / qt6ct / Kvantum # QT theming
├── gtk-2.0 / 3.0 / 4.0      # GTK themes
├── fastfetch / neofetch / btop / swappy
├── nix          # Optional Nix config

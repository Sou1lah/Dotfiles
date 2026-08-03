[![Typing SVG](https://readme-typing-svg.demolab.com?font=Fira+Code&size=30&duration=2000&pause=3000&color=F7F7F7&center=true&vCenter=true&width=500&lines=Wael's+Hyprland+Dotfiles)](https://git.io/typing-svg)

<p align="center">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/n1.png?raw=true" width="49%">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/n2.png?raw=true" width="49%">
</p>
<p align="center">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/b2.png?raw=true" width="49%">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/b4.png?raw=true" width="49%">
</p>
<p align="center">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/p2.png?raw=true" width="49%">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/p6.png?raw=true" width="49%">
</p>
<p align="center">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/r2.png?raw=true" width="49%">
  <img src="https://github.com/Sou1lah/Dotfiles/blob/main/assets/r3.png?raw=true" width="49%">
</p>

---

This repo contains my **Fedora** + **Hyprland** dotfiles:  
A clean, fast, and minimal Wayland rice with custom scripts, tweaked configs, and a sharp look.

---

### 🚀 One-Line Automated Installation

To install and set up this entire configuration on a new system, simply run:

```bash
curl -fsSL https://raw.githubusercontent.com/Sou1lah/Dotfiles/main/install.sh | bash
```

<details>
<summary>📦 Manual Installation</summary>

```bash
# 1. Clone the repository
git clone https://github.com/Sou1lah/Dotfiles.git ~/hyprland-dotfiles

# 2. Navigate to directory and execute setup
cd ~/hyprland-dotfiles
chmod +x install.sh
./install.sh
```

</details>

---

### 🙏 Special Thanks

Big thanks to [JaKooLit](https://github.com/JaKooLit/Fedora-Hyprland) for his Fedora Hyprland setup — it helped me get started and inspired many parts of this rice.

---

### 🛠️ Tools & Themes Used

| Category       | Tools / Apps                        |
|----------------|-------------------------------------|
| Shell          | Zsh, Starship                       |
| Terminal       | Kitty                               |
| Editor         | Neovim                              |
| Compositor     | Hyprland                            |
| Bar / Shell    | QuickShell / Noctalia / Waybar      |
| Launcher       | Rofi, Rofi-Games                    |
| Wallpaper      | Swww, Wallust, Matugen              |
| Notifications  | Swaync                              |
| Lock/Logout    | Wlogout, hyprlock                   |
| File Manager   | Thunar + Yazi                       |
| System Info    | Fastfetch                           |
| Multiplexer    | Tmux                                |

---

## 🧠 Neovim Setup

<details>
<summary>⌨️ Neovim Custom Keybinds</summary>

```text
╔═══════════════════════════════════════════════════╗
║               🧠 Keybind Cheatsheet               ║
╠═════════════════╬═════════════════════════════════╣
║ Ctrl + o        ║ Save                            ║
║ x (after o)     ║ Save & Exit                     ║
║ Ctrl + q        ║ Quit                            ║
║ Ctrl + c        ║ Force Quit (no save)            ║
║ Ctrl + x        ║ Cut Line (to clipboard)         ║
║ Ctrl + k        ║ Close side Pane                 ║
║ Ctrl + y        ║ Redo                            ║
║ Ctrl + z/_      ║ Undo                            ║
║ Ctrl + a        ║ Select All                      ║
║ Ctrl + c (V)    ║ Copy to Clipboard (visual)      ║
║ Ctrl + v        ║ Paste from Clipboard            ║
║ <C-n>           ║ Toggle Nvim Tree                ║
║ <Tab>           ║ Cycle to Next Buffer            ║
║ <S-Tab>         ║ Cycle to Previous Buffer        ║
║ <C-p>           ║ Open Telescope Find Files       ║
║ <C-l>           ║ Vertical Split                  ║
║ <C-h>           ║ Horizontal Split                ║
║ <C-k>           ║ Close Current Split Pane        ║
║ <C-a>           ║ Select All                      ║
║ <C-Left>        ║ Move to Previous Pane           ║
║ <C-r>           ║ Open Recent Files (Telescope)   ║
╚═════════════════╝═════════════════════════════════╝
```

<details>
<summary>🎥 themes</summary>

![Demo](assets/demo.gif)

</details>
</details>

---

## ⭐ Support

If you find this setup helpful or inspiring, consider giving the repo a ⭐.

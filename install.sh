#!/usr/bin/env bash

# ==============================================================================
# Dotfiles Setup & Installation Script
# Repository: https://github.com/Sou1lah/Dotfiles.git
# ==============================================================================

set -e

DOTFILES_REPO="https://github.com/Sou1lah/Dotfiles.git"
DOTFILES_DIR="$HOME/hyprland-dotfiles"
CONFIG_DIR="$HOME/.config"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Starting Hyprland & Dotfiles Setup ===${NC}\n"

# 1. Detect Package Manager and Install Dependencies
install_dependencies() {
    echo -e "${GREEN}[1/5] Checking and installing required packages...${NC}"
    
    COMMON_PACKAGES=(
        hyprland hyprpaper hyprlock hypridle
        waybar swaync rofi-wayland kitty zsh starship
        fastfetch btop yazi swappy wlogout wallust
        kvantum qt5ct qt6ct Polkit-gnome cliphist
        brightnessctl pamixer bluez bluez-utils blueman network-manager-applet
    )

    if command -v dnf &> /dev/null; then
        echo -e "${BLUE}Detected Fedora (dnf)...${NC}"
        sudo dnf check-update || true
        sudo dnf install -y "${COMMON_PACKAGES[@]}" git curl stow || true
    elif command -v pacman &> /dev/null; then
        echo -e "${BLUE}Detected Arch Linux (pacman)...${NC}"
        sudo pacman -Sy --needed --noconfirm "${COMMON_PACKAGES[@]}" git curl stow || true
    elif command -v apt &> /dev/null; then
        echo -e "${BLUE}Detected Debian/Ubuntu (apt)...${NC}"
        sudo apt update
        sudo apt install -y git curl stow zsh || true
    else
        echo -e "${YELLOW}Package manager not recognized automatically. Please ensure basic packages (hyprland, zsh, git, rofi, waybar) are installed manually.${NC}"
    fi
}

# 2. Clone or Update Dotfiles Repo
clone_dotfiles() {
    echo -e "${GREEN}[2/5] Fetching Dotfiles repository...${NC}"
    if [ -d "$DOTFILES_DIR/.git" ]; then
        echo -e "${BLUE}Dotfiles directory exists. Pulling latest updates...${NC}"
        cd "$DOTFILES_DIR" && git pull origin main
    else
        echo -e "${BLUE}Cloning repository to $DOTFILES_DIR...${NC}"
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
}

# 3. Deploy .config Files
deploy_configs() {
    echo -e "${GREEN}[3/5] Deploying configuration files...${NC}"
    mkdir -p "$CONFIG_DIR"

    if [ -d "$DOTFILES_DIR/.config" ]; then
        for item in "$DOTFILES_DIR/.config"/*; do
            filename=$(basename "$item")
            target="$CONFIG_DIR/$filename"

            if [ -e "$target" ] || [ -L "$target" ]; then
                echo -e "${YELLOW}Backing up existing config: $target -> $target.bak${NC}"
                mv "$target" "$target.bak.$(date +%Y%m%d_%H%M%S)"
            fi

            echo -e "${BLUE}Linking $filename to ~/.config/${NC}"
            ln -s "$item" "$target"
        done
    fi

    # Link top-level dotfiles (e.g. .zshrc if tracked)
    if [ -f "$DOTFILES_DIR/.zshrc" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            mv "$HOME/.zshrc" "$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"
        fi
        ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    fi
}

# 4. Set Default Shell to Zsh
setup_shell() {
    echo -e "${GREEN}[4/5] Setting up Zsh...${NC}"
    if [ "$SHELL" != "$(which zsh)" ] && command -v zsh &> /dev/null; then
        echo -e "${BLUE}Changing default shell to zsh...${NC}"
        chsh -s "$(which zsh)" || echo -e "${YELLOW}Could not run chsh automatically. Run 'chsh -s $(which zsh)' manually.${NC}"
    fi
}

# 5. Post-installation Checklist / Instructions
post_install() {
    echo -e "\n${GREEN}=== Installation Completed Successfully! ===${NC}\n"
    echo -e "${BLUE}Next Steps:${NC}"
    echo -e " 1. Create a wallpapers directory at ${YELLOW}~/Pictures/wallpapers${NC} and add your background images."
    echo -e " 2. Log out and select ${YELLOW}Hyprland${NC} at your display manager login screen."
    echo -e " 3. If using custom API keys or private tokens, add them to ${YELLOW}~/.config/secrets.conf${NC} or your ${YELLOW}~/.zshrc${NC}."
    echo -e "\n${GREEN}Enjoy your new setup!${NC}"
}

install_dependencies
clone_dotfiles
deploy_configs
setup_shell
post_install

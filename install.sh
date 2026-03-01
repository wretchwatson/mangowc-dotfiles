#!/bin/bash

# --- Color Definitions ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting DOTFILES Restore Script...${NC}"

# 1. Update system
echo -e "${GREEN}Updating system packages...${NC}"
sudo pacman -Syu --noconfirm

# 2. Install base packages
echo -e "${GREEN}Installing base packages from pkglist.txt...${NC}"
if [ -f "pkglist.txt" ]; then
    sudo pacman -S --needed - < pkglist.txt
fi

# 3. Check for AUR Helper (paru)
if ! command -v paru &> /dev/null; then
    echo -e "${GREEN}AUR Helper 'paru' not found. Installing...${NC}"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru && makepkg -si
    cd -
fi

# 4. Install AUR packages
echo -e "${GREEN}Installing AUR packages from aurlist.txt...${NC}"
if [ -f "aurlist.txt" ]; then
    paru -S --needed - < aurlist.txt
fi

# 5. Restore configs
echo -e "${GREEN}Restoring configuration files to ~/.config...${NC}"
mkdir -p "$HOME/.config"
cp -rv .config/* "$HOME/.config/"

# 6. Restore custom scripts
echo -e "${GREEN}Restoring custom scripts to ~/.local/bin...${NC}"
mkdir -p "$HOME/.local/bin"
cp -rv .local/bin/* "$HOME/.local/bin/"
chmod +x $HOME/.local/bin/*.sh

# 7. Restore dconf settings (GTK themes, font settings, etc.)
echo -e "${GREEN}Restoring dconf settings...${NC}"
if [ -f "dconf_settings.ini" ]; then
    dconf load / < dconf_settings.ini
fi

echo -e "${GREEN}Restore complete! Please reload your window manager or restart your session.${NC}"

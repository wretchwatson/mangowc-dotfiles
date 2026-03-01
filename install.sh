#!/bin/bash

# --- Error Handling ---
set -e # Exit immediately if a command exits with a non-zero status.

# --- Color Definitions ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting DOTFILES Restore Script...${NC}"

# 1. Update system
echo -e "${GREEN}Updating system packages...${NC}"
if ! sudo pacman -Syu; then
    echo -e "${RED}Error during system update. Please check for conflicts!${NC}"
    exit 1
fi

# 2. Install base packages
echo -e "${GREEN}Installing base packages from pkglist.txt...${NC}"
if [ -f "pkglist.txt" ]; then
    if ! sudo pacman -S --needed - < pkglist.txt; then
        echo -e "${RED}Conflict or error detected in pacman packages. Stopping for safety!${NC}"
        exit 1
    fi
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
    if ! paru -S --needed - < aurlist.txt; then
        echo -e "${RED}Conflict or error detected in AUR packages (paru). Stopping for safety!${NC}"
        exit 1
    fi
fi

# 5. Setup Zsh (Oh-My-Zsh, Plugins, Themes)
echo -e "${GREEN}Setting up Zsh and Oh-My-Zsh...${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

# 6. Restore Home Dotfiles (.zshrc, .p10k.zsh, etc.)
echo -e "${GREEN}Restoring home directory dotfiles...${NC}"
if [ -d "home" ]; then
    cp -rv home/.zshrc home/.p10k.zsh "$HOME/" 2>/dev/null || true
fi

# 7. Restore configs
echo -e "${GREEN}Restoring configuration files to ~/.config...${NC}"
mkdir -p "$HOME/.config"
cp -rv .config/* "$HOME/.config/"

# 8. Restore custom scripts
echo -e "${GREEN}Restoring custom scripts to ~/.local/bin...${NC}"
mkdir -p "$HOME/.local/bin"
cp -rv .local/bin/* "$HOME/.local/bin/"
chmod +x $HOME/.local/bin/*.sh

# 9. Restore wallpaper
echo -e "${GREEN}Restoring wallpaper...${NC}"
mkdir -p "$HOME/.local/share/wallpaper"
cp -rv .local/share/wallpaper/* "$HOME/.local/share/wallpaper/"

# 10. Restore dconf settings (GTK themes, font settings, etc.)
echo -e "${GREEN}Restoring dconf settings...${NC}"
if [ -f "dconf_settings.ini" ]; then
    dconf load / < dconf_settings.ini
fi

# 11. Restore system configurations (requires sudo)
echo -e "${GREEN}Restoring system-wide configurations...${NC}"
if [ -d "etc" ]; then
    sudo cp -rv etc/* /etc/
fi

# 12. Enable system services
echo -e "${GREEN}Enabling system services (SDDM)...${NC}"
sudo systemctl enable sddm

echo -e "${GREEN}Restore complete! Please reload your window manager or restart your session.${NC}"

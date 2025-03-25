#!/bin/bash

# Update packages
echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

# Install alternative key bindings for switching workspaces
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Alt>h']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Alt>l']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Alt>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Alt>2']"

# Function to check if the program is installed
check_installed() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "$1 is already installed!"
  else
    echo "$1 not found. Installing..."
    return 1
  fi
}

# Install tmux if necessary
check_installed tmux || sudo apt install tmux -y

# Install the latest version of nvim (Neovim)
# check_installed nvim || (
#   echo "Installing the latest version of Neovim..."
#   sudo apt install -y software-properties-common
#   sudo add-apt-repository ppa:neovim-ppa/stable -y
#   sudo apt update
#   sudo apt install neovim -y
# )

# Install Alacritty
check_installed alacritty || (
  echo "Installing Alacritty..."
  # Add the Alacritty repository
  sudo add-apt-repository ppa:aslatter/ppa -y
  sudo apt update
  sudo apt install alacritty -y
)

echo "Installation complete!"

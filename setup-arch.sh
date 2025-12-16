#!/bin/bash

# Hyprland
if [ -L ~/.config/hypr ]; then
  echo "Removing existing Hyprland symlink..."
  rm ~/.config/hypr
elif [ -e ~/.config/hypr ]; then
  echo "Backing up existing Hyprland config..."
  mv ~/.config/hypr ~/.config/hypr.backup
fi
ln -s ~/.dotfiles/hypr ~/.config/hypr
echo "Symlink created for Hyprland."

# Neovim 
if command -v nvim &> /dev/null; then
  echo "Neovim is already installed."
else
  sudo pacman -S neovim --noconfirm
fi

if [ -L ~/.config/nvim ]; then
  echo "Removing existing Neovim symlink..."
  rm ~/.config/nvim
elif [ -e ~/.config/nvim ]; then
  echo "Backing up existing nvim config..."
  mv ~/.config/nvim ~/.config/nvim.backup
fi
ln -s ~/.dotfiles/nvim ~/.config/nvim
echo "Symlink created for Neovim."

# tmux 
if command -v tmux &> /dev/null; then
  echo "tmux is already installed."
else
  sudo pacman -S tmux --noconfirm
fi

if [ -L ~/.tmux.conf ]; then
  echo "Removing existing tmux symlink..."
  rm ~/.tmux.conf
elif [ -e ~/.tmux.conf ]; then
  echo "Backing up existing tmux.conf..."
  mv ~/.tmux.conf ~/.tmux.conf.backup
fi
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
echo "Symlink created for tmux."

# zsh
if command -v zsh &> /dev/null; then
  echo "zsh is already installed."
else
  sudo pacman -S zsh --noconfirm
fi

if [ -L ~/.zshrc ]; then
  echo "Removing existing zsh symlink..."
  rm ~/.zshrc
elif [ -e ~/.zshrc ]; then
  echo "Backing up existing zshrc..."
  mv ~/.zshrc ~/.zshrc.backup
fi
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
echo "Symlink created for zsh."

# Jetbrains fonts
sudo pacman -S ttf-jetbrains-mono-nerd --noconfirm

# Mycli symlink
if [ -L ~/.myclirc ]; then
  echo "Removing existing Mycli symlink..."
  rm ~/.myclirc
elif [ -e ~/.myclirc ]; then
  echo "Backing up existing mycli config..."
  mv ~/.myclirc ~/.myclirc.backup
fi
ln -s ~/.dotfiles/mycli/.myclirc ~/.myclirc
echo "Symlink created for Mycli."

# oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh is already installed."
else
   echo "Installing oh-my-zsh..."
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ -L ~/.oh-my-zsh ]; then
  echo "Removing existing oh-my-zsh symlink..."
  rm ~/.oh-my-zsh
elif [ -e ~/.oh-my-zsh ]; then
  echo "Backing up existing oh-my-zsh folder..."
  mv ~/.oh-my-zsh ~/.oh-my-zsh-backup
fi
ln -s ~/.dotfiles/oh-my-zsh ~/.oh-my-zsh
echo "Symlink created for oh-my-zsh."

# kitty
if [ -L ~/.config/kitty ]; then
  echo "Removing existing kitty symlink..."
  rm ~/.config/kitty
elif [ -e ~/.config/kitty ]; then
  echo "Backing up existing kitty config..."
  mv ~/.config/kitty ~/.config/kitty.backup
fi
ln -s ~/.dotfiles/kitty ~/.config/kitty
echo "Symlink created for kitty."

# Firefox
if command -v firefox &> /dev/null; then
  echo "Firefox is already installed."
else
  sudo pacman -S firefox --noconfirm
fi

# superfile
if command -v superfile &> /dev/null; then
  echo "Superfile is already installed."
else
  sudo pacman -S superfile --noconfirm
fi

# Yay
if command -v yay &> /dev/null; then
  echo "Yay is already installed."
else
    echo "Installing Yay..."
    # Usando subshell () para garantir que o script não se perca de pasta
    (sudo pacman -S --needed git base-devel --noconfirm && git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay && makepkg -si --noconfirm)
fi

# Vicinae
if command -v vicinae &> /dev/null; then
  echo "Vicinae is already installed."
else
  yay -S vicinae --noconfirm
fi

# Garoa
if command -v garoa &> /dev/null; then
  echo "Garoa is already installed."
else
  yay -S garoa --noconfirm
fi

# Unzip
if command -v unzip &> /dev/null; then
  echo "Unzip is already installed."
else
  sudo pacman -S unzip --noconfirm
fi

echo ""
echo "-------------------------------------------------------"
echo "Configuration finished!"
echo "TIP: Type 'chsh -s $(which zsh)' to define zsh as default."
echo "-------------------------------------------------------"

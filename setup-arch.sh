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

# dunst
if [ -L ~/.config/dunst ]; then
  echo "Removing existing dunst symlink..."
  rm ~/.config/dunst
  elif [ -e ~/.config/dunst ]; then
    echo "Backing up existing dunst config..."
    mv ~/.config/dunst ~/.config/dunst.backup
fi
ln -s ~/.dotfiles/dunst ~/.config/dunst
echo "Symlink created for dunst."


#fcitx5
if [ -L ~/.config/fcitx5 ]; then
  echo "Removing existing fcitx5 symlink..."
  rm ~/.config/fcitx5
elif [ -e ~/.config/fcitx5 ]; then
  echo "Backing up existing fcitx5 config..."
  mv ~/.config/fcitx5 ~/.config/fcitx5.backup
fi
ln -s ~/.dotfiles/fcitx5 ~/.config/fcitx5
echo "Symlink created for fcitx5."

# Opencode
if [ -L ~/.config/opencode ]; then
  echo "Removing existing Opencode symlink..."
  rm ~/.config/opencode/config.json
elif [ -e ~/.config/opencode ]; then
  echo "Backing up existing Opencode config..."
  mv ~/.config/opencode ~/.config/opencode.backup
fi
ln -s ~/.dotfiles/opencode/config.json ~/.config/opencode/config.json
echo "Symlink created for Opencode."


#clibboard
sudo pacman -S wl-clipboard --noconfirm

# less
sudo pacman -S less --noconfirm

# Waybar
if command -v waybar &> /dev/null; then
  echo "Waybar is already installed."
else
  sudo pacman -S waybar --noconfirm
fi
if [ -L ~/.config/waybar ]; then
  echo "Removing existing Waybar symlink..."
  rm ~/.config/waybar
elif [ -e ~/.config/waybar ]; then
  echo "Backing up existing Waybar config..."
  mv ~/.config/waybar ~/.config/waybar.backup
fi
ln -s ~/.dotfiles/waybar ~/.config/waybar
echo "Symlink created for Waybar."

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

#git
if [ -L ~/.gitconfig ]; then
  echo "Removing existing gitconfig symlink..."
  rm ~/.gitconfig
elif [ -e ~/.gitconfig ]; then
  echo "Backing up existing gitconfig..."
  mv ~/.gitconfig ~/.gitconfig.backup
fi
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
echo "Symlink created for git."

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

# zoxide
if command -v zoxide &> /dev/null; then
  echo "zoxide is already installed."
else
  sudo pacman -S zoxide
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

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

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

#PDF reader
if command -v zathura &> /dev/null; then
  echo "Zathura is already installed."
else
  sudo pacman -S zathura --noconfirm
fi

#git-delta
if command -v git-delta &> /dev/null; then
  echo "git-delta is already installed."
else
  sudo pacman -S git-delta --noconfirm
fi

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

# awww
if command -v awww &> /dev/null; then
  echo "awww is already installed."
else
  yay -S awww --noconfirm
fi

# Wlogout
if command -v wlogout &> /dev/null; then
  echo "Wlogout is already installed."
else
  yay -S wlogout --noconfirm
fi

# Hyprshot
if command -v hyprshot &> /dev/null; then
  echo "Hyprshot is already installed."
else
  yay -S hyprshot --noconfirm
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

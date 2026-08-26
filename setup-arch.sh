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
sudo pacman -S --needed --noconfirm \
  fcitx5 \
  fcitx5-configtool \
  fcitx5-gtk \
  fcitx5-qt

if [ -L ~/.config/fcitx5 ]; then
  echo "Removing existing fcitx5 symlink..."
  rm ~/.config/fcitx5
elif [ -e ~/.config/fcitx5 ]; then
  echo "Backing up existing fcitx5 config..."
  mv ~/.config/fcitx5 ~/.config/fcitx5.backup
fi
ln -s ~/.dotfiles/fcitx5 ~/.config/fcitx5
echo "Symlink created for fcitx5."

mkdir -p ~/.local/share/fcitx5/themes
if [ -L ~/.local/share/fcitx5/themes/nord-waybar ]; then
  echo "Removing existing fcitx5 nord-waybar theme symlink..."
  rm ~/.local/share/fcitx5/themes/nord-waybar
elif [ -e ~/.local/share/fcitx5/themes/nord-waybar ]; then
  echo "Backing up existing fcitx5 nord-waybar theme..."
  mv ~/.local/share/fcitx5/themes/nord-waybar ~/.local/share/fcitx5/themes/nord-waybar.backup
fi
ln -s ~/.dotfiles/fcitx5/themes/nord-waybar ~/.local/share/fcitx5/themes/nord-waybar
echo "Symlink created for fcitx5 nord-waybar theme."

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

# Network and Bluetooth managers
sudo pacman -S --needed --noconfirm \
  networkmanager \
  network-manager-applet \
  bluez \
  bluez-utils \
  blueman

if systemctl is-enabled NetworkManager.service &> /dev/null; then
  echo "NetworkManager.service is already enabled."
else
  sudo systemctl enable NetworkManager.service
fi
sudo systemctl start NetworkManager.service

if systemctl is-enabled bluetooth.service &> /dev/null; then
  echo "bluetooth.service is already enabled."
else
  sudo systemctl enable bluetooth.service
fi
sudo systemctl start bluetooth.service

# Audio control GUI (pavucontrol) — switch output between headphones/HDMI/etc
if command -v pavucontrol &> /dev/null; then
  echo "pavucontrol is already installed."
else
  sudo pacman -S pavucontrol --noconfirm
fi

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

if command -v tree-sitter &> /dev/null; then
  echo "Tree-sitter CLI is already installed."
else
  sudo pacman -S tree-sitter-cli --noconfirm
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

# Fonts
sudo pacman -S --needed --noconfirm \
  ttf-jetbrains-mono-nerd \
  ttf-hack-nerd \
  noto-fonts-emoji \
  noto-fonts-cjk \
  otf-font-awesome

mkdir -p ~/.config/fontconfig
if [ -L ~/.config/fontconfig/fonts.conf ]; then
  echo "Removing existing fontconfig symlink..."
  rm ~/.config/fontconfig/fonts.conf
elif [ -e ~/.config/fontconfig/fonts.conf ]; then
  echo "Backing up existing fontconfig config..."
  mv ~/.config/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf.backup
fi
ln -s ~/.dotfiles/fontconfig/fonts.conf ~/.config/fontconfig/fonts.conf
echo "Symlink created for fontconfig."
fc-cache -fv

# GTK and KDE/Qt app themes
for gtk_version in gtk-3.0 gtk-4.0; do
  mkdir -p ~/.config/"$gtk_version"
  for file in settings.ini gtk.css; do
    if [ -L ~/.config/"$gtk_version"/"$file" ]; then
      echo "Removing existing $gtk_version $file symlink..."
      rm ~/.config/"$gtk_version"/"$file"
    elif [ -e ~/.config/"$gtk_version"/"$file" ]; then
      echo "Backing up existing $gtk_version $file..."
      mv ~/.config/"$gtk_version"/"$file" ~/.config/"$gtk_version"/"$file".backup
    fi
    ln -s ~/.dotfiles/"$gtk_version"/"$file" ~/.config/"$gtk_version"/"$file"
    echo "Symlink created for $gtk_version $file."
  done
done

# Advertise the dark color preference to browsers and websites.
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
echo "System color scheme set to dark."

if [ -L ~/.config/kdeglobals ]; then
  echo "Removing existing kdeglobals symlink..."
  rm ~/.config/kdeglobals
elif [ -e ~/.config/kdeglobals ]; then
  echo "Backing up existing kdeglobals..."
  mv ~/.config/kdeglobals ~/.config/kdeglobals.backup
fi
ln -s ~/.dotfiles/kde/kdeglobals ~/.config/kdeglobals
echo "Symlink created for kdeglobals."

if [ -L ~/.config/dolphinrc ]; then
  echo "Removing existing dolphinrc symlink..."
  rm ~/.config/dolphinrc
elif [ -e ~/.config/dolphinrc ]; then
  echo "Backing up existing dolphinrc..."
  mv ~/.config/dolphinrc ~/.config/dolphinrc.backup
fi
ln -s ~/.dotfiles/kde/dolphinrc ~/.config/dolphinrc
echo "Symlink created for dolphinrc."

mkdir -p ~/.local/share/color-schemes
if [ -L ~/.local/share/color-schemes/WaybarTerminal.colors ]; then
  echo "Removing existing WaybarTerminal color scheme symlink..."
  rm ~/.local/share/color-schemes/WaybarTerminal.colors
elif [ -e ~/.local/share/color-schemes/WaybarTerminal.colors ]; then
  echo "Backing up existing WaybarTerminal color scheme..."
  mv ~/.local/share/color-schemes/WaybarTerminal.colors ~/.local/share/color-schemes/WaybarTerminal.colors.backup
fi
ln -s ~/.dotfiles/kde/color-schemes/WaybarTerminal.colors ~/.local/share/color-schemes/WaybarTerminal.colors
echo "Symlink created for WaybarTerminal color scheme."

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
if pacman -Q yay-bin &> /dev/null; then
  echo "Yay prebuilt is already installed."
elif command -v yay &> /dev/null; then
  echo "Switching Yay to the prebuilt package..."
  if ! yay -S yay-bin --noconfirm; then
    yay_bin_pkg=(~/.cache/yay/yay-bin/yay-bin-[0-9]*-x86_64.pkg.tar.zst)
    if [ -f "${yay_bin_pkg[0]}" ]; then
      for old_pkg in yay yay-debug; do
        if pacman -Q "$old_pkg" &> /dev/null; then
          sudo pacman -R --noconfirm "$old_pkg"
        fi
      done
      sudo pacman -U --noconfirm "${yay_bin_pkg[0]}"
    else
      exit 1
    fi
  fi
else
    echo "Installing Yay prebuilt..."
    # Usando subshell () para garantir que o script não se perca de pasta
    (sudo pacman -S --needed git base-devel --noconfirm && git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si --noconfirm)
fi
if pacman -Q yay-bin &> /dev/null && pacman -Q yay-debug &> /dev/null; then
  echo "Removing old Yay debug package from the source build..."
  sudo pacman -R --noconfirm yay-debug
fi

# Tokyonight GTK theme — required by GTK_THEME=Tokyonight-Dark (hypr env + gtk-3.0/4.0 settings).
# Without it, GTK apps (e.g. pavucontrol) fall back to a broken light theme with washed-out text.
if [ -d /usr/share/themes/Tokyonight-Dark ]; then
  echo "Tokyonight GTK theme is already installed."
else
  yay -S tokyonight-gtk-theme-git --noconfirm
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

# flameshot
if command -v flameshot &> /dev/null; then
  echo "flameshot is already installed."
else
  yay -S flameshot-git --noconfirm
fi

# Hyprshot
if command -v hyprshot &> /dev/null; then
  echo "Hyprshot is already installed."
else
  yay -S hyprshot --noconfirm
fi

# Vicinae
if pacman -Q vicinae-bin &> /dev/null; then
  echo "Vicinae prebuilt is already installed."
else
  if ! yay -S vicinae-bin --noconfirm; then
    vicinae_bin_pkg=(~/.cache/yay/vicinae-bin/vicinae-bin-[0-9]*-x86_64.pkg.tar.zst)
    if [ -f "${vicinae_bin_pkg[0]}" ]; then
      for old_pkg in vicinae vicinae-debug; do
        if pacman -Q "$old_pkg" &> /dev/null; then
          sudo pacman -R --noconfirm "$old_pkg"
        fi
      done
      sudo pacman -U --noconfirm "${vicinae_bin_pkg[0]}"
    else
      exit 1
    fi
  fi
fi
if pacman -Q vicinae-bin &> /dev/null && pacman -Q vicinae-debug &> /dev/null; then
  echo "Removing old Vicinae debug package from the source build..."
  sudo pacman -R --noconfirm vicinae-debug
fi

mkdir -p ~/.local/share/vicinae/themes
if [ -L ~/.local/share/vicinae/themes/dotfiles-nord.toml ]; then
  rm ~/.local/share/vicinae/themes/dotfiles-nord.toml
elif [ -e ~/.local/share/vicinae/themes/dotfiles-nord.toml ]; then
  mv ~/.local/share/vicinae/themes/dotfiles-nord.toml ~/.local/share/vicinae/themes/dotfiles-nord.toml.backup
fi
ln -s ~/.dotfiles/vicinae/dotfiles-nord.toml ~/.local/share/vicinae/themes/dotfiles-nord.toml
echo "Symlink created for the Vicinae Dotfiles Nord theme."

vicinae theme set dotfiles-nord

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

# SDDM + Astronaut theme (Keyitdev/sddm-astronaut-theme)
# Guard: disable any competing display manager that may be enabled on other machines
for dm in gdm lightdm lxdm greetd ly; do
  if systemctl is-enabled "${dm}.service" &> /dev/null; then
    echo "Disabling ${dm}.service (replacing with sddm)..."
    sudo systemctl disable "${dm}.service"
  fi
done

# Install SDDM and theme dependencies
if command -v sddm &> /dev/null; then
  echo "SDDM is already installed."
else
  sudo pacman -S sddm --noconfirm
fi
sudo pacman -S --needed --noconfirm qt6-svg qt6-virtualkeyboard qt6-multimedia

# Enable SDDM
if systemctl is-enabled sddm.service &> /dev/null; then
  echo "sddm.service is already enabled."
else
  sudo systemctl enable sddm.service
fi

# Install Astronaut theme
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
if [ -d "$SDDM_THEME_DIR" ]; then
  echo "sddm-astronaut-theme already present, pulling latest..."
  sudo git -C "$SDDM_THEME_DIR" pull --ff-only || true
else
  echo "Cloning sddm-astronaut-theme..."
  sudo git clone --depth 1 https://github.com/Keyitdev/sddm-astronaut-theme.git "$SDDM_THEME_DIR"
fi

# Install theme fonts
if [ -d "$SDDM_THEME_DIR/Fonts" ]; then
  sudo cp -r "$SDDM_THEME_DIR"/Fonts/* /usr/share/fonts/
fi

# Select 'astronaut' variant
sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/astronaut.conf|' "$SDDM_THEME_DIR/metadata.desktop"

# Point SDDM at the theme
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf > /dev/null
echo -e "[General]\nInputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null

echo ""
echo "-------------------------------------------------------"
echo "Configuration finished!"
echo "TIP: Type 'chsh -s $(which zsh)' to define zsh as default."
echo "-------------------------------------------------------"

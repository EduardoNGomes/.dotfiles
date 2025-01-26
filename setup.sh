# Neovim symlink
if [ -L ~/.config/nvim ]; then
  echo "Removing existing Neovim symlink..."
  rm ~/.config/nvim
elif [ -e ~/.config/nvim ]; then
  echo "Backing up existing nvim config..."
  mv ~/.config/nvim ~/.config/nvim.backup
fi
ln -s ~/.dotfiles/nvim ~/.config/nvim
echo "Symlink created for Neovim."


# tmux symlink
if [ -L ~/.tmux.conf ]; then
  echo "Removing existing tmux symlink..."
  rm ~/.tmux.conf
elif [ -e ~/.tmux.conf ]; then
  echo "Backing up existing tmux.conf..."
  mv ~/.tmux.conf ~/.tmux.conf.backup
fi
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
echo "Symlink created for tmux."


# zsh symlink
if [ -L ~/.zshrc ]; then
  echo "Removing existing zsh symlink..."
  rm ~/.zshrc
elif [ -e ~/.zshrc ]; then
  echo "Backing up existing zshrc..."
  mv ~/.zshrc ~/.zshrc.backup
fi
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
echo "Symlink created for zsh."


# fonts symlink
if [ -L ~/.fonts ]; then
  echo "Removing existing fonts symlink..."
  rm ~/.fonts
elif [ -e ~/.fonts ]; then
  echo "Backing up existing fonts..."
  mv ~/.fonts ~/.fonts.backup
fi
ln -s ~/.dotfiles/fonts/.fonts/ ~/.fonts
echo "Symlink created for fonts."


# Mycli symlink
if [ -L ~/.myclirc ]; then
  echo "Removing existing Neovim symlink..."
  rm ~/.myclirc
elif [ -e ~/.myclirc ]; then
  echo "Backing up existing nvim config..."
  mv ~/.myclirc ~/.myclirc.backup
fi
ln -s ~/.dotfiles/mycli/.myclirc ~/.myclirc
echo "Symlink created for Mycli."


# Alacritty symlink
if [ -L ~/.config/alacritty/ ]; then
  echo "Removing existing Alacritty symlink..."
  rm ~/.config/alacritty
elif [ -e ~/.config/alacritty/ ]; then
  echo "Backing up existing Alacritty config..."
  mv ~/.config/alacritty ~/.config/alacritty-backup
fi
ln -s ~/.dotfiles/alacritty/ ~/.config/alacritty
echo "Symlink created for Alacritty."


#oh-my-zsh themes symlink
if [ -L ~/.oh-my-zsh/themes ]; then
  echo "Removing existing oh-my-zsh themes symlink..."
  rm ~/.oh-my-zsh/themes
elif [ -e ~/.oh-my-zsh/themes ]; then
  echo "Backing up existing oh-my-zsh themes config..."
  mv ~/.oh-my-zsh/themes ~/.oh-my-zsh/themes-backup
fi
ln -s ~/.dotfiles/oh-my-zsh/themes ~/.oh-my-zsh/themes
echo "Symlink created for oh-my-zsh/themes."


# Themes symlink
if [ -L ~/.themes ]; then
  echo "Removing existing themes symlink..."
  rm ~/.themes
elif [ -e ~/.themes ]; then
  echo "Backing up existing themes config..."
  mv ~/.themes ~/.themes-backup
fi
ln -s ~/.dotfiles/themes ~/.themes
echo "Symlink created for themes."	


echo "All done!"


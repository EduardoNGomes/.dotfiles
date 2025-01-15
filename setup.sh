# Neovim symlink
if [ -e ~/.config/nvim ]; then
  echo "Backing up existing nvim config..."
  mv ~/.config/nvim ~/.config/nvim.backup
fi
ln -s ~/.dotfiles/nvim ~/.config/nvim
echo "Symlink created for Neovim."

# tmux symlink
if [ -e ~/.tmux.conf ]; then
  echo "Backing up existing tmux.conf..."
  mv ~/.tmux.conf ~/.tmux.conf.backup
fi
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
echo "Symlink created for tmux."

echo "All done!"

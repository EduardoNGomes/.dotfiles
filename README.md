# Dotfiles

My personal Linux workstation configuration, centered on **Arch Linux + Hyprland** with a smaller set of configs available for Ubuntu.

<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/b25e31f2-e971-4121-912b-05e936b964ff" />


The setup combines a Tokyo Night-inspired desktop, a keyboard-driven Hyprland workflow, a customized Waybar, and a development environment built around Neovim, Zsh, tmux, Kitty, and Alacritty.

> [!WARNING]
> These are personal, opinionated dotfiles—not a universal installer. Read the setup script before running it. Some settings are hardware-specific, and the Arch installer installs packages, enables system services, disables other display managers, and configures SDDM.

## What's included

| Area | Configuration |
| --- | --- |
| Desktop | Hyprland, Waybar, Dunst, GTK 3/4, KDE/Qt colors, Tokyo Night themes |
| Terminals | Kitty and Alacritty |
| Shell | Zsh, Oh My Zsh, custom functions, aliases, and zoxide |
| Editor | Neovim with `lazy.nvim`, LSP support, Treesitter, Telescope, completion, and formatting |
| Terminal multiplexer | tmux with vi-style navigation and a custom status line |
| Input | fcitx5 and a custom `nord-waybar` theme |
| Utilities | Wallpaper rotation, screenshots, volume controls, DND mode, and Waybar style switching |
| Extras | Git/Delta, mycli, OpenCode, Vicinae, fonts, wallpapers, and Codex skills |

## Installation

### Arch Linux

The repository must live at `~/.dotfiles`, because several configs and scripts reference that path directly.

```bash
git clone https://github.com/EduardoNGomes/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
less setup-arch.sh
./setup-arch.sh
```

The Arch setup script:

- creates symlinks for the desktop, terminal, shell, editor, font, and application configs;
- installs several official-repository and AUR packages;
- enables NetworkManager, Bluetooth, and SDDM;
- disables another enabled display manager before switching to SDDM;
- installs the SDDM Astronaut theme; and
- moves existing non-symlink configs to a neighboring `.backup` path where supported.

Hyprland and programs referenced by its config should already be available, including Kitty, Dolphin, Wofi, Dunst, PipeWire tools, `brightnessctl`, and `playerctl`. After installation, optionally make Zsh your default shell:

```bash
chsh -s "$(command -v zsh)"
```

Log out or reboot after the setup finishes so the display manager and session services start cleanly.

### Ubuntu

Ubuntu support is intentionally smaller. The dependency script updates the system, configures GNOME workspace shortcuts, and installs tmux and Alacritty when needed. The setup script then links Neovim, tmux, Zsh, fonts, mycli, Alacritty, Oh My Zsh, and themes.

```bash
git clone https://github.com/EduardoNGomes/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
less ubuntu-dependency.sh setup-ubuntu.sh
./ubuntu-dependency.sh
./setup-ubuntu.sh
```

Neovim installation is currently disabled in `ubuntu-dependency.sh`, so install it separately before using the included configuration.

### Install only selected configs

If you do not want the full setup, link individual configs yourself. For example:

```bash
mkdir -p ~/.config
ln -s ~/.dotfiles/nvim ~/.config/nvim
ln -s ~/.dotfiles/kitty ~/.config/kitty
ln -s ~/.dotfiles/waybar ~/.config/waybar
ln -s ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
```

Back up or remove an existing destination before creating a symlink.

## Hyprland shortcuts

`Super` is the main modifier.

| Shortcut | Action |
| --- | --- |
| `Super + Q` | Open Kitty in the current Dolphin directory when possible |
| `Super + C` | Close the active window |
| `Super + E` | Open Dolphin |
| `Super + R` | Open the Wofi application launcher |
| `Super + Space` | Toggle Vicinae |
| `Super + H/J/K/L` | Move focus |
| `Super + Shift + H/J/K/L` | Move the active window |
| `Super + 1..0` | Switch workspace |
| `Super + Shift + 1..0` | Move a window to a workspace |
| `Print` | Toggle the Flameshot capture UI |
| `Super + Shift + W` | Start random wallpaper rotation |
| `Super + Ctrl + W` | Choose a wallpaper with Vicinae |
| `Super + Ctrl + Shift + W` | Restore the default wallpaper |
| `Super + Ctrl + B` | Toggle the Waybar style |

## Repository layout

```text
.
├── hypr/             # Hyprland configuration
├── waybar/           # Status bar config and switchable styles
├── nvim/             # Neovim Lua configuration and plugin lockfile
├── zsh/              # Shell config and reusable functions
├── tmux/             # tmux configuration
├── kitty/            # Kitty config and themes
├── alacritty/        # Alacritty config and color schemes
├── dunst/            # Notification daemon config
├── fcitx5/           # Input method config and theme
├── gtk-3.0, gtk-4.0/ # GTK appearance
├── kde/              # Qt/KDE application appearance
├── themes/           # Desktop themes
├── wallpaper/        # Wallpaper collection
├── scripts/          # Desktop helper scripts
├── skills/           # Personal Codex skills
├── setup-arch.sh     # Arch package and symlink setup
└── setup-ubuntu.sh   # Ubuntu symlink setup
```

## Customization notes

Before using the full desktop configuration, review these machine-specific values:

- monitor names, resolution, and refresh rate in `hypr/hyprland.conf`;
- CPU and GPU `hwmon` paths in `waybar/config.jsonc`;
- the optional `$HOME/memory-clean/mclean` Hyprland autostart command;
- the Git identity in `.gitconfig`; and
- the default wallpaper and transition settings in `scripts/wallpaper.sh`.

Private shell additions can live outside the repository in:

```text
~/.zsh-custom/aliases.zsh
~/.zsh-custom/env_vars.zsh
~/.zsh-custom/functions.zsh
```

The main Zsh config loads these files automatically when they exist.

## Useful commands

```bash
# Reload Waybar
waybar-reload

# Toggle between the natural and pill Waybar styles
~/.dotfiles/scripts/waybar-style.sh

# Open the Neovim configuration
nvconf

# Jump to this repository
dtconf
```

## License

No license is currently provided. Unless a license is added, the repository is shared for reference rather than redistribution.

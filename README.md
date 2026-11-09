# 🐧 Dotfiles

My personal Arch Linux dotfiles, built around **Hyprland**, with a focus on customisation, workflow, and a clean desktop experience.

This repository contains my current unfinished configurations, scripts, themes and package lists, alongside an installation script to help recreate my setup on a fresh Arch Linux installation.

> These dotfiles are a personal, evolving project. Things may change, break or be reworked as I continue experimenting.

## ✨ What's included?

| Component | Description |
|---|---|
| [Hyprland](https://hypr.land/) | Wayland compositor and window management |
| [QuickShell](https://quickshell.outfoxxed.me/) | Custom desktop shell and widgets |
| [Neovim](https://neovim.io/) | Editor configuration with extensive LSP support |
| [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal emulator |
| [rmpc](https://mierak.dev/rmpc/) | Terminal-based music player |
| [Rofi](https://github.com/davatorium/rofi) | Application launcher and menus |
| [Yazi](https://yazi-rs.github.io/) | Terminal file manager |
| [Zsh](https://www.zsh.org/) | Shell configuration, aliases and functions |

Also included:
- Custom shell scripts and utilities.
- Hyprland animations, keybindings, window rules and theming.
- Custom QuickShell modules and services.
- Neovim plugin and language server configurations.
- Pacman and AUR package lists.
- An automated installation and update script.

## 📁 Repository structure

```text
dotfiles/
├── hypr/          # Hyprland configuration
├── kitty/         # Kitty terminal
├── nvim/          # Neovim configuration
├── quickshell/    # Custom desktop shell
├── rmpc/          # Music player configuration
├── rofi/          # Launcher configuration
├── yazi/          # File manager configuration
├── zsh/           # Zsh configuration
├── scripts/       # Personal utility scripts
├── packages/      # Pacman and AUR package lists
├── backups/       # Previous configurations
├── install.sh     # Installation manager
└── .gitignore
```

## 🚀 Installation

**Requirements**
- Arch Linux
- Git
- Internet connection
- An AUR helper (`paru` or `yay`) if AUR packages are listed
- `sudo` privileges

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git
cd dotfiles
```

### 2. Review the configuration

Before installing, check the package lists and configuration files.

In particular, review `packages/pacman.txt` and `packages/aur.txt` to see what will be installed.

### 3. Run the installer

```bash
chmod +x install.sh
./install.sh install
```

The installer will:
1. Check that you're running Arch Linux as a normal user.
2. Install essential dependencies, including Git and GNU Stow.
3. Install the packages listed in the package lists.
4. Preview the proposed dotfile symlinks.
5. Ask for confirmation before applying them.

### Installer commands

| Command | Description |
|---|---|
| `./install.sh install` | Fresh installation |
| `./install.sh update` | Update packages and configurations |
| `./install.sh packages` | Install listed packages |
| `./install.sh stow` | Restore dotfile symlinks |
| `./install.sh help` | Display help |

## 🔗 GNU Stow

Configurations are organised into Stow packages, allowing them to be symlinked into their respective locations in `$HOME`.

The installer currently manages:

- Hyprland
- Kitty
- Neovim
- QuickShell
- rmpc
- Scripts
- Zsh

Rofi and Yazi are included in the repository but aren't currently part of the installer's automatic Stow package list.

## ⚠️ Disclaimer

These configurations are tailored to my own system and preferences.

- Some scripts and settings may require modification for your hardware or environment.
- Not every configuration will work out of the box on another machine.
- Review scripts before executing them.
- Package availability and dependencies may change over time.

**Use at your own discretion.**

## 🛠️ Built with

A collection of tools from the Linux ecosystem, brought together and customised to create a desktop environment that feels like home.

---

*Configured with curiosity, maintained with questionable amounts of tweaking.*

#!/usr/bin/env bash

set -Eeuo pipefail

# ==========================================================
# Arch Rice Manager
# Manage packages, dotfiles.
# ==========================================================

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACMAN_LIST="$DOTFILES_DIR/packages/pacman.txt"
AUR_LIST="$DOTFILES_DIR/packages/aur.txt"

STOW_PACKAGES=(hypr kitty nvim quickshell rmpc rofi yazi scripts zsh)

# ==========================================================
# Colours
# ==========================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[INFO]${RESET} $*"; }
success() { echo -e "${GREEN}[OK]${RESET} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET} $*"; }
error()   { echo -e "${RED}[ERROR]${RESET} $*" >&2; }

# ==========================================================
# Utilities
# ==========================================================

confirm() {
    local answer
    read -r -p "$1 [y/N] " answer
    [[ "$answer" =~ ^[Yy]$ ]]
}

check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        error "This script is designed for Arch Linux."
        exit 1
    fi
}

check_not_root() {
    if [[ "$EUID" -eq 0 ]]; then
        error "Please run this script as your normal user, not root."
        exit 1
    fi
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

read_packages() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        warn "Package list not found: $file"
        return 0
    fi

    sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$file" |
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# ==========================================================
# Dependencies
# ==========================================================

bootstrap() {
    info "Checking essential tools..."

    local missing=()

    for package in git stow; do
        if ! pacman -Q "$package" &>/dev/null; then
            missing+=("$package")
        fi
    done

    if ((${#missing[@]})); then
        info "Installing: ${missing[*]}"
        sudo pacman -S --needed "${missing[@]}"
    fi

    local missing_build=()

    while IFS= read -r package; do
        [[ -n "$package" ]] || continue

        if ! pacman -Q "$package" &>/dev/null; then
            missing_build+=("$package")
        fi
    done < <(pacman -Sgq base-devel)

    if ((${#missing_build[@]})); then
        info "Installing missing base-devel packages..."
        sudo pacman -S --needed "${missing_build[@]}"
    fi

    success "Essential tools are ready."
}

get_aur_helper() {
    if check_command paru; then
        echo "paru"
    elif check_command yay; then
        echo "yay"
    else
        echo ""
    fi
}

# ==========================================================
# Package management
# ==========================================================

install_packages() {
    info "Installing official repository packages..."

    local packages=()
    mapfile -t packages < <(read_packages "$PACMAN_LIST")

    if ((${#packages[@]})); then
        sudo pacman -S --needed "${packages[@]}"
    else
        warn "No official packages listed."
    fi

    info "Installing AUR packages..."

    local aur_packages=()
    mapfile -t aur_packages < <(read_packages "$AUR_LIST")

    if ((${#aur_packages[@]})); then
        local helper
        helper="$(get_aur_helper)"

        if [[ -z "$helper" ]]; then
            error "AUR packages are listed, but neither paru nor yay is installed."
            error "Install an AUR helper, then run this command again."
            return 1
        fi

        "$helper" -S --needed "${aur_packages[@]}"
    else
        warn "No AUR packages listed."
    fi

    success "Package installation finished."
}

update_packages() {
    info "Updating Arch packages..."
    sudo pacman -Syu

    local helper
    helper="$(get_aur_helper)"

    if [[ -n "$helper" ]]; then
        info "Updating AUR packages..."
        "$helper" -Sua
    else
        warn "No AUR helper found. Skipping AUR updates."
    fi

    success "Package updates finished."
}

# ==========================================================
# Stow management
# ==========================================================

valid_stow_package() {
    local package="$1"

    case "$package" in
        hypr|kitty|nvim|quickshell|rmpc)
            [[ -d "$DOTFILES_DIR/$package/.config" ]]
            ;;
        scripts)
            [[ -d "$DOTFILES_DIR/scripts/.local" ]]
            ;;
        zsh)
            [[ -d "$DOTFILES_DIR/zsh/.config" ||
               -f "$DOTFILES_DIR/zsh/.zshrc" ]]
            ;;
        *)
            return 1
            ;;
    esac
}

stow_configs() {
    info "Checking Stow packages..."

    local packages=()

    for package in "${STOW_PACKAGES[@]}"; do
        if valid_stow_package "$package"; then
            packages+=("$package")
        else
            warn "Skipping $package: expected directory structure not found."
        fi
    done

    if ((${#packages[@]} == 0)); then
        error "No valid Stow packages found."
        return 1
    fi

    info "The following packages will be stowed:"
    printf '  - %s\n' "${packages[@]}"

    echo
    info "Simulating Stow..."

    stow --simulate --restow \
        --dir="$DOTFILES_DIR" \
        --target="$HOME" \
        "${packages[@]}"

    echo

    if confirm "Apply these Stow changes?"; then
        stow --restow \
            --dir="$DOTFILES_DIR" \
            --target="$HOME" \
            "${packages[@]}"

        success "Dotfiles successfully stowed."
    else
        warn "Stow cancelled. No changes made."
    fi
}

# ==========================================================
# Git synchronisation
# ==========================================================

sync_git() {
    if ! git -C "$DOTFILES_DIR" rev-parse --is-inside-work-tree &>/dev/null; then
        warn "Dotfiles directory is not a Git repository."
        return 0
    fi

    if [[ -n "$(git -C "$DOTFILES_DIR" status --porcelain)" ]]; then
        warn "You have uncommitted dotfile changes."
        warn "Commit or stash them before pulling remote changes."
        return 0
    fi

    if ! git -C "$DOTFILES_DIR" rev-parse --abbrev-ref '@{upstream}' &>/dev/null; then
        warn "No Git upstream configured. Skipping pull."
        return 0
    fi

    if confirm "Pull latest dotfiles from Git?"; then
        git -C "$DOTFILES_DIR" pull --ff-only
        success "Dotfiles synchronised."
    fi
}

# ==========================================================
# Main operations
# ==========================================================

do_install() {
    info "Starting Arch rice installation..."

    bootstrap
    install_packages
    stow_configs

    success "Installation tasks finished!"
}

do_update() {
    info "Starting Arch rice update..."

    sync_git
    update_packages
    stow_configs

    success "Update tasks finished!"
}

# ==========================================================
# Command line interface
# ==========================================================

show_help() {
    cat <<EOF

Arch Rice Manager

Usage:
    ./install.sh install     Fresh installation
    ./install.sh update      Update system and rice
    ./install.sh packages    Install listed packages
    ./install.sh stow        Restore dotfile symlinks
    ./install.sh help        Show this help

EOF
}

main() {
    case "${1:-help}" in
        help|-h|--help)
            show_help
            return 0
            ;;
    esac

    check_not_root
    check_arch

    case "${1:-help}" in
        install)
            do_install
            ;;
        update)
            do_update
            ;;
        packages)
            bootstrap
            install_packages
            ;;
        stow)
            stow_configs
            ;;
        *)
            error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"


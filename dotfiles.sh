#!/bin/bash
# Dotfiles backup and restore script

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ITEMS=(
    .bash_logout
    .bash_profile
    .bashrc
    .gitconfig
    .tmux.conf
    .zshrc
    .XCompose
    .wegorc
    .Xresources
    .xinitrc
    .config/starship.toml
    .config/alacritty
    .config/btop
    .config/fastfetch
    .config/hypr
    .config/kitty
    .config/mako
    .config/nvim
    .config/waybar
    .config/dunst
    .config/rofi
    .config/polybar
    .config/i3
    .config/bspwm
)
SENSITIVE_DOTFILES=(.ssh .gnupg)

# Backup function
backup() {
    echo "Backing up dotfiles..."

    # Warning for sensitive files
    for file in "${SENSITIVE_DOTFILES[@]}"; do
        if [ -e "$HOME/$file" ]; then
            echo "WARNING: Found sensitive file/directory: $file. This script will not back it up. Please back it up manually and securely."
        fi
    done

    # Create .dotfiles directory
    mkdir -p "$DOTFILES_DIR"
    mkdir -p "$DOTFILES_DIR/.config"

    # Copy backup items
    for item in "${BACKUP_ITEMS[@]}"; do
        is_sensitive=false
        for sensitive_item in "${SENSITIVE_DOTFILES[@]}"; do
            if [ "$item" == "$sensitive_item" ]; then
                is_sensitive=true
                break
            fi
        done

        if [ "$is_sensitive" = true ]; then
            continue
        fi

        src_path="$HOME/$item"
        dest_path="$DOTFILES_DIR/$item"

        if [ -f "$src_path" ]; then
            mkdir -p "$(dirname "$dest_path")"
            cp "$src_path" "$dest_path"
            echo "Copied file: $item"
        elif [ -d "$src_path" ]; then
            cp -r "$src_path" "$(dirname "$dest_path")"
            echo "Copied directory: $item"
        fi
    done

    echo "Backup complete."
}

# Restore function
restore() {
    echo "Restoring dotfiles..."

    # Restore backup items
    for item in "${BACKUP_ITEMS[@]}"; do
        src_path="$DOTFILES_DIR/$item"
        dest_path="$HOME/$item"

        if [ -f "$src_path" ]; then
            mkdir -p "$(dirname "$dest_path")"
            cp "$src_path" "$dest_path"
            echo "Restored file: $item"
        elif [ -d "$src_path" ]; then
            cp -r "$src_path" "$(dirname "$dest_path")"
            echo "Restored directory: $item"
        fi
    done

    echo "Restore complete."
}

# Main script logic
case "$1" in
    backup)
        backup
        ;;
    restore)
        restore
        ;;
    *)
        echo "Usage: $0 {backup|restore}"
        exit 1
esac

exit 0
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
	local specific_item="$1"

	if [ -n "$specific_item" ]; then
		echo "Restoring specific dotfile: $specific_item"

		# Find matching items
		local found=false
		for item in "${BACKUP_ITEMS[@]}"; do
			# Match if the item contains the specific name
			if [[ "$item" == *"$specific_item"* ]] || [[ "$(basename "$item")" == "$specific_item" ]]; then
				src_path="$DOTFILES_DIR/$item"
				dest_path="$HOME/$item"

				if [ -f "$src_path" ]; then
					mkdir -p "$(dirname "$dest_path")"
					cp "$src_path" "$dest_path"
					echo "Restored file: $item"
					found=true
				elif [ -d "$src_path" ]; then
					cp -r "$src_path" "$(dirname "$dest_path")"
					echo "Restored directory: $item"
					found=true
				fi
			fi
		done

		if [ "$found" = false ]; then
			echo "Error: No dotfile found matching '$specific_item'"
			echo "Available dotfiles:"
			printf '  %s\n' "${BACKUP_ITEMS[@]}"
			return 1
		fi
	else
		echo "Restoring all dotfiles..."

		# Restore all backup items
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
	fi

	echo "Restore complete."
}

# Main script logic
case "$1" in
backup)
	backup
	;;
restore)
	restore "$2"
	;;
*)
	echo "Usage: $0 {backup|restore [dotfile_name]}"
	echo "Examples:"
	echo "  $0 backup                 # Backup all dotfiles"
	echo "  $0 restore                # Restore all dotfiles"
	echo "  $0 restore nvim           # Restore only nvim config"
	echo "  $0 restore .bashrc        # Restore only .bashrc"
	exit 1
	;;
esac

exit 0

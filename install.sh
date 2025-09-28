#!/bin/bash

set -e

echo "🚀 Setting up dotfiles..."

# DOTFILES_DIR="$HOME/.dotfiles"
# CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# # Function to create symlink with backup
# link_file() {
#     local src="$1"
#     local dest="$2"

#     # Create directory if it doesn't exist
#     mkdir -p "$(dirname "$dest")"

#     # Backup existing file if it exists and isn't a symlink
#     if [[ -f "$dest" && ! -L "$dest" ]]; then
#         echo "📦 Backing up existing $dest to $dest.backup"
#         mv "$dest" "$dest.backup"
#     fi

#     # Remove existing symlink
#     if [[ -L "$dest" ]]; then
#         rm "$dest"
#     fi

#     # Create new symlink
#     echo "🔗 Linking $src -> $dest"
#     ln -sf "$src" "$dest"
# }

# # Copy dotfiles to ~/.dotfiles if not already there
# if [[ "$CURRENT_DIR" != "$DOTFILES_DIR" ]]; then
#     echo "📁 Copying dotfiles to $DOTFILES_DIR"
#     mkdir -p "$DOTFILES_DIR"
#     cp -R "$CURRENT_DIR"/* "$DOTFILES_DIR/"
#     cd "$DOTFILES_DIR"
# else
#     cd "$CURRENT_DIR"
# fi

# # Link all dotfiles
# echo "🔗 Creating symlinks..."

# # Link individual dotfiles
# for file in dot-*; do
#     if [[ -f "$file" ]]; then
#         # Remove 'dot-' prefix and add '.' prefix for home directory
#         target="$HOME/.${file#dot-}"
#         link_file "$DOTFILES_DIR/$file" "$target"
#     fi
# done

# # Link config directories
# if [[ -d "config" ]]; then
#     for config_dir in config/*/; do
#         if [[ -d "$config_dir" ]]; then
#             dir_name=$(basename "$config_dir")
#             link_file "$DOTFILES_DIR/$config_dir" "$HOME/.config/$dir_name"
#         fi
#     done
# fi

# # Install packages (if package list exists)
# if [[ -f "packages.txt" ]]; then
#     echo "📦 Installing packages..."

#     # Detect package manager and install
#     if command -v apt-get >/dev/null 2>&1; then
#         echo "Using apt-get..."
#         sudo apt-get update
#         xargs sudo apt-get install -y < packages.txt
#     elif command -v yum >/dev/null 2>&1; then
#         echo "Using yum..."
#         xargs sudo yum install -y < packages.txt
#     elif command -v brew >/dev/null 2>&1; then
#         echo "Using brew..."
#         xargs brew install < packages.txt
#     else
#         echo "⚠️  No supported package manager found. Please install packages manually:"
#         cat packages.txt
#     fi
# fi

# # Run custom setup scripts
# if [[ -f "setup/custom.sh" ]]; then
#     echo "🛠️  Running custom setup..."
#     bash setup/custom.sh
# fi

echo "✅ Dotfiles setup complete!"
echo "🔄 Please restart your shell or run 'source ~/.bashrc' (or equivalent) to apply changes."
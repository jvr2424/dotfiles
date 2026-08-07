#!/usr/bin/env bash


# determine the os


# if mac proceed

# Default to normal stow
ADOPT_MODE=false
SKIP_PACKAGES=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --adopt) ADOPT_MODE=true ;;
        --no-packages) SKIP_PACKAGES=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Set the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Load environment variables
if [[ -f "$DOTFILES_DIR/.env" ]]; then
    source "$DOTFILES_DIR/.env"
else
    echo "Warning: $DOTFILES_DIR/.env not found. Copy .env.example to .env and fill in required values."
fi

if [[ -z "$OBSIDIAN_DIR" ]]; then
    echo "Error: OBSIDIAN_DIR is not set in $DOTFILES_DIR/.env"
    exit 1
fi

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || exit

# Install packages via Homebrew on macOS
if [[ "$SKIP_PACKAGES" == false ]] && [[ "$(uname)" == "Darwin" ]]; then
    echo "Installing packages..."

    # Install Homebrew if not present
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found — installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew trust nikitabobko/tap
    brew tap nikitabobko/tap
    brew bundle --file="$DOTFILES_DIR/Brewfile"

    # Install Python versions via uv and set 3.12 as default
    uv python install 3.9 3.12
    uv python pin --global 3.12

    # Install the default stable Rust toolchain via rustup
    rustup toolchain install stable
    rustup default stable
    cargo install tree-sitter-cli
    cargo install bob-nvim

    # Install Node LTS via nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && source "$(brew --prefix)/opt/nvm/nvm.sh"
    nvm install --lts
    nvm alias default lts/*

    # Apply macOS system settings
    bash "$DOTFILES_DIR/macos.sh"
fi

# Loop through all directories in the dotfiles folder
for dir in */; do
    # Remove trailing slash
    dir=${dir%/}
    
    # Skip if not a directory
    [ -d "$dir" ] || continue
    
    # Skip common version control and system directories
    if [[ "$dir" == ".git" ]]; then
        continue
    fi
    
    # Print which directory is being stowed
    
    # Run stow command
    # -R to restow (overwrite existing symlinks)
    # --adopt --> pulls the system files into this repo
    if [ "$ADOPT_MODE" = true ]; then
        # --adopt moves existing files into the stow directory and creates symlinks
        echo "Using adopt mode for $dir"
        stow -R --adopt "$dir"
        
    else
        # Normal restow
        echo "Stowing $dir..."
        stow -R "$dir"
    fi

done

echo "Dotfiles stow complete!"

# Symlink Obsidian-specific files that can't be managed by stow
echo "Symlinking Obsidian files..."

OBSIDIAN_SNIPPETS_DIR="$OBSIDIAN_DIR/.obsidian/snippets"
mkdir -p "$OBSIDIAN_SNIPPETS_DIR"
ln -sf "$DOTFILES_DIR/indent_headers.css" "$OBSIDIAN_SNIPPETS_DIR/indent_headers.css"
ln -sf "$DOTFILES_DIR/.obsidian.vimrc" "$OBSIDIAN_DIR/.obsidian.vimrc"

echo "Obsidian symlinks complete!"



# if ubuntu ... figure it out later

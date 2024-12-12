#!/usr/bin/env bash


# determine the os


# if mac proceed

# Default to normal stow
ADOPT_MODE=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --adopt) ADOPT_MODE=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Set the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Change to the dotfiles directory
cd "$DOTFILES_DIR" || exit

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



# if ubuntu ... figure it out later

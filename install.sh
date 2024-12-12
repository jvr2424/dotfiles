#!/usr/bin/env bash


# determine the os


# if mac proceed

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
    if [[ "$dir" == ".git" || "$dir" == ".github" || "$dir" == ".gitignore" ]]; then
        continue
    fi
    
    # Print which directory is being stowed
    echo "Stowing $dir..."
    
    # Run stow command
    # -R to restow (overwrite existing symlinks)
    stow -R "$dir"
done

echo "Dotfiles stow complete!"



# if ubuntu ... figure it out later

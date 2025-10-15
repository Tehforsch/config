#!/usr/bin/env bash

# Sync .envrc and CLAUDE.md files to central location
# Usage: sync-project-files.sh [directory_name]
# If no directory name provided, uses basename of current directory

set -euo pipefail

# Get directory name
if [ $# -eq 1 ]; then
    dirname="$1"
else
    dirname=$(basename "$PWD")
fi

# Central resource directory
resource_dir="$HOME/resource/projects/$dirname"

# Files to sync
files=(".envrc" "CLAUDE.md")

# Create resource directory if it doesn't exist
if [ ! -d "$resource_dir" ]; then
    echo "Creating resource directory: $resource_dir"
    mkdir -p "$resource_dir"
fi

for file in "${files[@]}"; do
    local_file="$PWD/$file"
    target_file="$resource_dir/$file"
    
    echo "Processing $file..."
    
    if [ -f "$local_file" ] && [ ! -f "$target_file" ]; then
        # Local exists, target doesn't - move local to target
        echo "  Moving local $file to $target_file"
        mv "$local_file" "$target_file"
        
    elif [ ! -f "$target_file" ]; then
        # Neither exists - create empty target file
        echo "  Creating empty $target_file"
        touch "$target_file"
    fi
    
    # Remove local file if it exists and isn't already a symlink
    if [ -f "$local_file" ] && [ ! -L "$local_file" ]; then
        echo "  Removing local $file (will be replaced with symlink)"
        rm "$local_file"
    elif [ -L "$local_file" ]; then
        echo "  Local $file is already a symlink, skipping"
        continue
    fi
    
    # Create symlink
    echo "  Creating symlink: $local_file -> $target_file"
    ln -s "$target_file" "$local_file"
    
done

echo "Sync complete for project: $dirname"
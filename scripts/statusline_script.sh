#!/usr/bin/env bash

# Source the zsh prompt functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../zsh/prompt.sh"

# Read input from stdin
input=$(cat)

# Get current working directory from input
cwd=$(echo "$input" | jq -r '.cwd')

# Convert zsh format to ANSI escape codes for bash/statusline use
convert_git_info() {
    cd "$cwd" 2>/dev/null || return
    
    # Get the git info in zsh format from the sourced function
    local zsh_output=$(get_git_info)
    
    # Convert zsh color codes to ANSI escape codes
    # %F{6} -> cyan, %F{11} -> bright yellow, %F{4} -> blue, %F{1} -> red
    local ansi_output=$(echo "$zsh_output" | \
        sed -e 's/%F{6}/\\033[38;5;6m/g' \
            -e 's/%F{11}/\\033[38;5;11m/g' \
            -e 's/%F{4}/\\033[38;5;4m/g' \
            -e 's/%F{1}/\\033[38;5;1m/g' \
            -e 's/%f/\\033[0m/g')
    
    printf "$ansi_output"
}

# Convert the path to a more readable format (replace home with ~)
display_path=${cwd/#$HOME/\~}

# Output the status line: path in blue + git info + "> "
printf "\033[1m\033[34m%s\033[0m %s" "$display_path" "$(convert_git_info)"

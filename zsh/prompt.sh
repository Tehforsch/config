function get_git_info()
{
    # Check for jj repository first
    if jj root &> /dev/null; then
        # Check if there are uncommitted changes
        if [[ $(jj diff --stat 2>/dev/null) == '' ]]; then
            color="6"
            dirtyString=""
        else
            color="11"
            dirtyString="*"
        fi
        
        # Get the closest bookmark
        closest_bookmark=$(jj log --no-pager -r "closest_bookmark(@-)" --no-graph -T 'local_bookmarks.join(" ")' 2>/dev/null | head -1)
        if [[ -n "$closest_bookmark" ]]; then
            # Count commits ahead and behind
            ahead=$(jj log --no-pager -r "closest_bookmark(@-)..@-" --no-graph -T 'commit_id ++ "\n"' 2>/dev/null | wc -l)
            behind=$(jj log --no-pager -r "@-..closest_bookmark(@-)" --no-graph -T 'commit_id ++ "\n"' 2>/dev/null | wc -l)
            
            # Build ahead/behind indicator
            ahead_behind=""
            if [[ $ahead -gt 0 && $behind -gt 0 ]]; then
                ahead_behind=" ↑$ahead↓$behind"
            elif [[ $ahead -gt 0 ]]; then
                ahead_behind=" ↑$ahead"
            elif [[ $behind -gt 0 ]]; then
                ahead_behind=" ↓$behind"
            fi
            
            echo '%F{'${color}'}('${dirtyString}${closest_bookmark}${ahead_behind}')%f'
        fi
        return
    fi
    
    # Fall back to git if not a jj repository
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
        if [[ $(git diff --stat) == '' ]]; then
            color="6"
            dirtyString=""
        else
            color="11"
            dirtyString="*"
        fi
        # Are we at a detached HEAD?
        exit=$(git symbolic-ref -q HEAD 2> /dev/null)
        if  [[ $? == 0 ]] ; then
            # Check first if HEAD exists ... in empty repos
            # it does not
            git rev-parse -q --git-ref HEAD &> /dev/null
            if  [[ $? == 0 ]] ; then
                # HEAD exists - check if it's a branch
                # If we're at a branch, call it by the branch name
                branchinfo=$(git rev-parse --abbrev-ref HEAD)
            else
                branchinfo="new repository"
                color=4
            fi
        else
            # If HEAD is detached, describe it
            desc=$(git describe --contains --all)
            commit=$(git rev-parse --short HEAD)
            color=1
            branchinfo="$commit = $desc"
        fi
        if [[ $branchinfo == "" ]];
        then
            :
        else
            echo '%F{'${color}'}('${dirtyString}${branchinfo}'%F{'${color}'})%f'
        fi
    fi
}

function get_exit_code()
{
    if [[ $EXIT_CODE != 0 ]]; then
        echo -n '%F{red}'
        echo -n " [$EXIT_CODE]"
        echo -n '%f'
    fi
}


if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    # remote session - append hostname and change color of path
    hostname="%B%F{1}(%m)%f%b "
else
    hostname=""
fi

if [[ $SHLVL -gt 1 ]]; then
    shell_name=${name/-env/}
    nix_shell_info=" %F{green}[$shell_name]%f"
    if [[ $SHLVL -gt 2 ]]; then
        (( remaining_shell_count= $SHLVL - 2 ))
        nix_shell_info=" %F{green}[$shell_name+$remaining_shell_count]%f"
    fi
else 
    nix_shell_info=""
fi



setopt prompt_subst

precmd() { 
    EXIT_CODE=$?
    print "" 
}

PROMPT=$'%B%F{4}%~%f%b $hostname$(get_git_info)$(get_exit_code)$nix_shell_info\n> '

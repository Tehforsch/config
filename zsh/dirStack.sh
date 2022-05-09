# MIT License

# Copyright (c) 2016 Pete Sevander

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# originally from https://github.com/sevanteri/zsh-dir-scroller

setopt autopushd pushdminus pushdsilent pushdtohome

autoload -U add-zsh-hook

function empty_dir_stack {
    _dir_stack=()
}

add-zsh-hook chpwd empty_dir_stack

function goto_next_in_dir_history {
    local stack=($(dirs))
    if [[ $#stack == 1 ]]; then
        return
    fi

    _dir_stack=( $(pwd) $_dir_stack )
    popd -q
    zle reset-prompt
}

function goto_prev_in_dir_history {
    local saved="$_dir_stack[1]"
    [[ -z $saved ]] && return

    pushd -q $saved
    shift _dir_scroller_popped
    zle reset-prompt
}

_dir_stack=()

zle -N goto_next_in_dir_history
zle -N goto_prev_in_dir_history

bindkey '^k' goto_next_in_dir_history
# ITS 2022 AND I STILL CANT BIND ctrl+i IN THE TERMINAL BECAUSE ITS THE SAME THING AS TAB
# WHY ARE WE STILL USING TECHNOLOGY FROM THE FUCKING 50s
bindkey '^j' goto_prev_in_dir_history

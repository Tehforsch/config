alias l="exa -la"
alias ls="exa -l"
alias dlc="$CONFIG/scripts/copyLastDownload.sh"
alias e="$CONFIG/scripts/runEmacsClientInPwd.sh"

alias g="git"
alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gdn="git diff --color-words --no-ext-diff"
alias gdc="git diff --staged"
alias gdh="git log --follow -p --"
alias gp="git push"
alias gpu="git pull"
alias gs="git status"
alias gsu="git submodule update --recursive --remote"
alias gr="git reset"
alias ggr="$CONFIG/scripts/gitGrep.sh"
alias co="git checkout"
alias gpf="git push --force-with-lease"
alias gl="git log"
alias gdm="git diff ORIG_HEAD MERGE_HEAD"
alias gri="git rebase -i"

alias im="viewnior"
alias imt="kitty +kitten icat"

alias ka="killall"
alias shut="sudo shutdown -h 0"

alias pmb="pamac build --no-confirm"
alias pms="pamac search -a"

alias timer="$CONFIG/scripts/timer/timer.sh"
alias timerAt="$CONFIG/scripts/timer/timerAt.sh"

alias addmusic="bash ~/music/addMusic.sh"

alias pybob="python3 ~/projects/pybob/main.py"
alias testbob="cargo run --release --manifest-path ~/projects/bob/Cargo.toml"
alias getbwfor="$scripts/getPlots.sh bwfor"
alias getsupermuc="$scripts/getPlots.sh supermuc && pybob . replot --only-new"
alias plot="pybob plot"

alias work="bash ~/projects/config/scripts/setWorkFolder.sh"
alias w="source ~/projects/config/scripts/getWorkFolder.sh"

alias canibuy="bash ~/resource/finances/showBudget"

alias cb="cargo build"
alias cbr="cargo build --release"
alias cr="cargo run"
alias crr="cargo run --release"
alias ct="cargo test"
alias ctr="cargo test --release"
alias ci="cargo install --path ."
alias cc="cargo check"
alias cdo="cargo doc --no-deps --open"
alias cdoc="cargo doc --no-deps --open -p"
alias rb="source $scripts/toggleRustBacktrace.sh"

alias start="$scripts/startSim.sh"
alias copy="rsync --archive --stats --progress --human-readable"
alias kp="$scripts/killProcess.sh"
alias cat="bat"

alias cp='cp -v'

alias o="xdg-open"

alias mk="make -j 16"

alias mpi="~/projects/raxiom/scripts/runMpi.sh"
alias loc="~/projects/raxiom/scripts/runLocal.sh"
alias mpigdb="~/projects/raxiom/scripts/runGdb.sh"

alias mb="make build -j 12"

alias wget="wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\""

alias l="exa -la"
alias ls="exa -l"
alias dlc="$CONFIG/scripts/copyLastDownload.sh"
alias e="$CONFIG/scripts/runEmacsClientInPwd.sh"

alias g="git"
alias ga="git add"
alias gd="git diff"
alias gc="git commit"
alias gca="git commit --amend"
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
alias gl="git log --ext-diff"
alias gdm="git diff ORIG_HEAD MERGE_HEAD --ext-diff"
alias gri="git rebase -i"
alias sw="git switch"
alias rs="git restore"

alias agg="rga-fzf"

alias glo="forgit::log"
alias gdf="forgit::diff"
alias gaf="forgit::add"
alias cof="forgit::checkout::file"
alias cob="forgit::checkout::branch"
alias grh="forgit::reset::head"

alias im="viewnior"
alias imt="kitty +kitten icat"

alias ka="killall"
alias shut="sudo shutdown -h 0"

alias pms="yay -Ss"

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
alias ctl="cargo test --lib"
alias ctr="cargo test --release"
alias ci="cargo install --path ."
alias cc="cargo clippy"
alias cdo="cargo doc --no-deps --open"
alias cdoc="cargo doc --no-deps --open -p"
alias cbtop="cargo build 2>&1 > /dev/null | bat --paging=always -l=rust" # shows the top error messages
alias rb="if [[ $RUST_BACKTRACE == 1 ]]; then; export RUST_BACKTRACE=0; else; export RUST_BACKTRACE=1; fi"

alias bb="cargo build --features bevy/dynamic_linking"
alias br="cargo run --features bevy/dynamic_linking"
alias bt="cargo test --features bevy/dynamic_linking"

alias bbr="cargo build --release --features bevy/dynamic_linking"
alias brr="cargo run --release --features bevy/dynamic_linking"
alias btr="cargo test --release --features bevy/dynamic_linking"

alias flame="$scripts/flamegraphRunningProcess.sh"

alias start="$scripts/startSim.sh"
alias transfer="rsync --archive --stats --progress --human-readable"
alias kp="$scripts/killProcess.sh"
alias cat="bat"

alias cp='cp -v'

alias o="xdg-open"

alias pdf="zathura"

alias mk="make -j 16"

alias mpi="~/projects/raxiom/scripts/runMpi.sh"
alias loc="~/projects/raxiom/scripts/runLocal.sh"
alias mpigdb="~/projects/raxiom/scripts/runGdb.sh"

alias mb="make build -j 12"

alias wget="wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\""

alias copy="xclip -selection clipboard"
alias paste="xsel --clipboard"

alias helper="python3 ~/projects/helpers/main.py"

alias y="yazi"

alias pl="python3 ~/projects/pl/main.py"

alias pbron="pybob replot . --only-new"

alias journ="$CONFIG/scripts/journal_entry.sh"
alias journy="$CONFIG/scripts/journal_entry.sh yesterday"

alias nixsw="sudo -u toni nixos-rebuild switch --flake ~/projects/config/nixos" # The sudo -u toni ensures that I can use ssh keys from my normal user while sudoing to clone private repos
alias nixb="nixos-rebuild build --flake ~/projects/config/nixos"

alias rust_stable="nix develop ~/projects/config/nixos/shells/#rust_stable -c zsh"
alias rust_nightly="nix develop ~/projects/config/nixos/shells/#rust_nightly -c zsh"

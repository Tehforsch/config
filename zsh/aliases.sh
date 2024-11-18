alias l="exa -la"
alias ls="exa -l"
alias cat="bat"
alias e="$CONFIG/scripts/runEmacsClientInPwd.sh"
alias agg="rga-fzf"

alias g="git"
alias ga="git add"
alias gd="git diff"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gdc="git diff --staged"
alias gdh="git log --follow -p --"
alias gp="git push"
alias gpu="git pull"
alias gs="git status"
alias gr="git reset"
alias ggr="$CONFIG/scripts/gitGrep.sh"
alias co="git restore"
alias gpf="git push --force-with-lease"
alias gl="git log --ext-diff"
alias gdm="git diff ORIG_HEAD MERGE_HEAD --ext-diff"
alias gri="git rebase -i"
alias gre="git rebase"
alias gw="git switch"
alias gwd="git switch --detach"
alias gb="git branch"
alias gcp="git cherry-pick"

function checkout_pr() {
    # $1 is the PR number.
    git fetch origin pull/$1/head:pull-request-$1
    git switch pull-request-$1
}

alias glf="forgit::log"
alias gdf="forgit::diff"
alias gdcf="forgit::diff --cached"
alias gaf="forgit::add"
alias grf="forgit::reset::head"
alias cof="forgit::checkout::file"
alias gwf="forgit::checkout::branch"

alias cb="cargo build"
alias cbr="cargo build --release"
alias cr="cargo run"
alias crr="cargo run --release"
alias ct="cargo test"
alias ctl="cargo test --lib"

alias cc="cargo check"
alias ccl="cargo check --lib"

alias clip="cargo clippy"

function ctn() {
    cargo test $@ -- --nocapture
}

function ctln() {
    cargo test --lib $@ -- --nocapture
}

alias ctr="cargo test --release"
alias ci="cargo install --path ."
alias cdo="cargo doc --no-deps --open"
alias cdoc="cargo doc --no-deps --open -p"
alias cbtop="cargo build 2>&1 > /dev/null | bat --paging=always -l=rust" # shows the top error messages
alias rb='if [[ $RUST_BACKTRACE == 1 ]]; then; export RUST_BACKTRACE=0; else; export RUST_BACKTRACE=1; fi'

function init_envrc() {
    cwd=$(basename $(pwd))
    echo "use flake ~/projects/config/nixos/shells#rust_stable\nexport CARGO_BUILD_TARGET_DIR=/mnt/extHdd/.cargo-target/$cwd" > .envrc;
    direnv allow
}

alias bb="cargo build --features bevy/dynamic_linking"
alias br="cargo run --features bevy/dynamic_linking"
alias bt="cargo test --features bevy/dynamic_linking"

alias bbr="cargo build --release --features bevy/dynamic_linking"
alias brr="cargo run --release --features bevy/dynamic_linking"
alias btr="cargo test --release --features bevy/dynamic_linking"

function tou() {
    p="$1"
    mkdir -p $(dirname $p)
    touch $p
}

alias flame="$scripts/flamegraphRunningProcess.sh"

alias cp='cp -v'

alias im="nomacs"
alias pdf="zathura"

# I used to have this as "sudo -u toni", in order to ensure I can use normal user ssh keys to clone private repos. However this has stopped working
alias nixsw="sudo nixos-rebuild switch --flake ~/projects/config/nixos"
alias nixb="nixos-rebuild build --flake ~/projects/config/nixos"

alias transfer="rsync --archive --stats --progress --human-readable"
alias dlc="$CONFIG/scripts/copyLastDownload.sh"
alias kp="$scripts/killProcess.sh"
alias ka="killall"
alias shut="sudo shutdown -h 0"

alias timer="$CONFIG/scripts/timer/timer.sh"
alias timerAt="$CONFIG/scripts/timer/timerAt.sh"

alias journ="systemctl start --user journal; $CONFIG/scripts/journal_entry.sh"
alias journy="systemctl start --user journal; firefox --new-tab localhost:8000/dashboard&; $CONFIG/scripts/journal_entry.sh yesterday"

alias addmusic="bash ~/music/addMusic.sh"

alias pybob="python3 ~/projects/pybob/main.py"

alias scannerctl="cargo run --manifest-path ~/projects/openvas-scanner/rust/Cargo.toml --bin scannerctl --"

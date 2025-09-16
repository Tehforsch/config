alias l="exa -la"
alias ls="exa -l"
alias lt="exa --tree"
alias cat="bat"
alias e="$CONFIG/scripts/runEmacsClientInPwd.sh"
alias agg="rga-fzf"

alias c="check"

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
alias grim="git rebase -i main"
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

function 2fa() {
    key=$(oathtool -b --totp $(cat ~/resource/keys/2fa/$1 ))
    echo $key

    echo -n "$key" | xclip -selection clipboard
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
alias cctl="cargo check --lib --tests"

alias clip="cargo clippy"
alias cir="cargo insta review"

function ctn() {
    cargo test $@ -- --nocapture
}

function ctln() {
    cargo test --lib $@ -- --nocapture
}

alias ctr="cargo test --release"
alias ci="cargo install --locked --path ."
alias cdo="cargo doc --no-deps --open"
alias cdoc="cargo doc --no-deps --open -p"
alias cbtop="cargo build 2>&1 > /dev/null | bat --paging=always -l=rust" # shows the top error messages
alias rb='if [[ $RUST_BACKTRACE == 1 ]]; then; export RUST_BACKTRACE=0; else; export RUST_BACKTRACE=1; fi'

function init_envrc() {
    if [[ $# == 1 ]]; then
        shell_name="$1"
    else
        shell_name=rust_stable
    fi
    cwd=$(basename $(pwd))
    echo "use flake ~/projects/config/nixos/shells#$shell_name\nexport CARGO_BUILD_TARGET_DIR=/mnt/extHdd/.cargo-target/$cwd" > .envrc;
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

alias nixb="nixos-rebuild build --flake ~/projects/config/nixos"
alias nixd="nix-store --delete"
alias nixr="nix-store --roots --query"

function nixsw() {
    sudo echo
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ssh-add ~/.ssh/id_rsa
    sudo nixos-rebuild --max-jobs 8 --cores 4 switch --flake ~/projects/config/nixos
}

function nhsw() {
    sudo echo
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    ssh-add ~/.ssh/id_rsa
    nh os switch ~/projects/config/nixos
}

function ns() {
    nix shell "nixpkgs#$1"
}

function ns_unfree() {
    NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "nixpkgs#$1"
}

function nsr() {
    nix shell "nixpkgs#$1" -c "$1"
}

alias transfer="rsync --archive --stats --progress --human-readable"
alias dlc="$CONFIG/scripts/copyLastDownload.sh"
alias kp="$scripts/killProcess.sh"
alias ka="killall"
alias shut="sudo shutdown -h 0"

alias timer="$CONFIG/scripts/timer/timer.sh"
alias timerAt="$CONFIG/scripts/timer/timerAt.sh"

alias sys="systemctl"

alias journ="systemctl start --user journal; $CONFIG/scripts/journal_entry.sh"
alias journy="systemctl start --user journal; firefox --new-tab localhost:8000/dashboard&; $CONFIG/scripts/journal_entry.sh yesterday"

alias addmusic="bash ~/music/addMusic.sh"

alias pybob="python3 ~/projects/pybob/main.py"

alias scannerctl="cargo run --manifest-path ~/projects/openvas-scanner/rust/Cargo.toml --bin scannerctl --"
alias scannerctl_release="cargo run --release --manifest-path ~/projects/openvas-scanner/rust/Cargo.toml --bin scannerctl --"
alias openvasd="cargo run --release --manifest-path ~/projects/openvas-scanner/rust/Cargo.toml --bin openvasd --"

alias cal="vdirsyncer sync && ikhal"

alias mol="cargo run --manifest-path ~/projects/molt/Cargo.toml --"

alias kill="kill -KILL"

alias top="btm"

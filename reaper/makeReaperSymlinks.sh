function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    if [[ -L "$name" ]]; then
        if [[ $(readlink -f "$name") != $target ]]; then
            echo "Deleting previously existing symlink: $target"
            rm $name
            ln -s "$target" "$name"
        fi
    elif [[ ! -a "$name" ]]; then
        echo "File did not exist: $name"
    fi
    rm "$name"
    ln -s "$target" "$name"
}

make_symlink reaper/reaper-keys/actions.lua .config/REAPER/Scripts/reaper-keys/internal/definitions/actions.lua
make_symlink reaper/reaper-keys/bindings.lua .config/REAPER/Scripts/reaper-keys/internal/definitions/bindings.lua
make_symlink reaper/reaper-keys/config.lua .config/REAPER/Scripts/reaper-keys/internal/definitions/config.lua

cd $CONFIG/reaper/config
results=$(fd . -e ini) 
cd $CONFIG
for f in $results; do
    make_symlink reaper/config/$f .config/REAPER/$f
done

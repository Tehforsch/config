# Unfortunately, reaper doesnt do well with symlinks in the config
# folder. Some of the files work, but not all of them. See
# https://forums.cockos.com/showthread.php?p=2755819
# This is why some of the files are copied, while others
# are symlinked.

echo "Use 'from' as argument to move files from reaper to here."

function make_symlink {
    target="$CONFIG/$1"
    name="$HOME/$2"
    mkdir -p $(dirname "$name")
    basename="$(basename $name)" 
    rm "$name"
    ln -s "$target" "$name"
}

function make_copy {
    target="$CONFIG/$1"
    name="$HOME/$2"
    rev="$3"
    mkdir -p $(dirname "$name")
    basename="$(basename $name)" 
    if [ "$rev" = "from" ]; then
        echo "Moving from reaper to repo"
        cp "$name" "$target" 
        echo cp "$name" "$target" 
    else
        echo cp "$target" "$name" 
        cp -u --backup=numbered "$target" "$name"
    fi
}


make_symlink reaper/reaper-keys/actions.lua .config/REAPER/Scripts/reaper-keys/internal/definitions/actions.lua
make_symlink reaper/reaper-keys/bindings.lua .config/REAPER/Scripts/reaper-keys/internal/definitions/bindings.lua
make_symlink reaper/reaper-keys/config.lua .config/REAPER/Scripts/reaper-keys/internal/definitions/config.lua

cd "$CONFIG/reaper/config/symlinkable" || exit
results=$(fd . -e ini) 
cd "$CONFIG" || exit
for f in $results; do
    make_symlink "reaper/config/symlinkable/$f" ".config/REAPER/$f"
done

cd "$CONFIG/reaper/config/non_symlinkable" || exit
results=$(fd . -e ini) 
cd "$CONFIG" || exit
for f in $results; do
    make_copy "reaper/config/non_symlinkable/$f" ".config/REAPER/$f" "$1"
done

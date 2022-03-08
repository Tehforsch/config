simFolder="$HOME/projects/phd/simulations/"
workFolder="$WORK"
path=$(realpath --relative-to "$simFolder" "$1")
target="$workFolder/$path"
mkdir -p $(dirname "$target")
echo "Running in $target"
$bob start "$1" "$target"



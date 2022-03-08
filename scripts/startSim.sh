delete=""
while [[ "$#" -gt 1 ]]; do
    case $1 in
        -d|--delete) delete="-d"; shift ;;
        *) shift; break;
    esac
done

simFolder="$HOME/projects/phd/simulations/"
workFolder="$WORK"
path=$(realpath --relative-to "$simFolder" "$1")
target="$workFolder/$path"
mkdir -p $(dirname "$target")
echo "Running in $target"
$bob start "$delete" "$1" "$target"

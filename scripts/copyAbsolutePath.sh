# cap - copy absolute path
#
#   USAGE: cap [<path>]
#
# copy the absolute path to a file/directory to the system clipboard.
# If <path> is omitted, the current directory is copied instead.
cap() {
    abspath="$(realpath "${1:-.}")"
    echo "$abspath" | xclip -selection clipboard
    echo "Copied '$abspath' to clipboard"
}

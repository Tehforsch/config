filename="$1"
base=$(basename -- "$1")
extension="${base##*.}"

documentExtensions="pdf epub djvu PDF EPUB DJVU"
imageExtensions="jpg jpeg JPEG JPG png PNG"
for ext in $documentExtensions; do
    if [[ $extension == $ext ]]; then
        zathura "$filename"
        exit 0
    fi
done
for ext in $imageExtensions; do
    if [[ $extension == $ext ]]; then
        gpicview "$filename"
        exit 0
    fi
done

emacsclient -c -n "$filename"

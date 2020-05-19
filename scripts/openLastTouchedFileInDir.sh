if [[ $# == 0 ]]; then
    dir=$(pwd)
else
    dir="$1"
fi
lastFile=$(ls --sort=time "$dir" -p | grep -v / | head -n 1)
base=$(basename -- "$lastFile")
extension="${base##*.}"
filename="$dir/$base"

documentExtensions="pdf epub"
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

echo "No association found for file: $lastFile"

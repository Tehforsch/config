filename="$1"
base="${filename%.*}"
baseSvg="${base}.svg"
basePdf="${base}.pdf"
inkscape -D "$baseSvg" -o "$basePdf" --export-latex

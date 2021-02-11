# Credit to "fortea" from https://tex.stackexchange.com/questions/94523/simulate-a-scanned-paper
output="scanned.pdf"
echo "Creating $output"
convert -density 150 "$1" -linear-stretch 3.5%x10% -blur 0x0.5 -attenuate 0.25 +noise Gaussian "$output"

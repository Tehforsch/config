if [[ $# == 1 ]]; then
    latexFileName=$1
else
    echo "Need filename of main latex file!"
    exit 1
fi
withoutExtension=${latexFileName/.tex/}
pdflatex --interaction=nonstopmode -shell-escape $latexFileName
bibtex $withoutExtension
pdflatex --interaction=nonstopmode -shell-escape $latexFileName
pdflatex --interaction=nonstopmode -shell-escape $latexFileName

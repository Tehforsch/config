#!/bin/bash
if [[ $# == 1 ]]; then
    latexFileName=$1
else
    echo "Need filename of main latex file!"
    exit 1
fi
withoutExtension=${latexFileName/.tex/}
rubber -d -s $latexFileName
rm ${withoutExtension}-blx.bib
rm ${withoutExtension}.aux
rm ${withoutExtension}.bbl
rm ${withoutExtension}.blg
rm ${withoutExtension}.dvi
rm ${withoutExtension}.obj
rm ${withoutExtension}.out
rm ${withoutExtension}.tdo
rm ${withoutExtension}.run.xml

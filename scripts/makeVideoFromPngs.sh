if [[ $# -gt 0 ]]; then
    pngs="$@"
else
    pngs="*.png"
fi
cat $pngs | ffmpeg -f image2pipe -i - output.mp4

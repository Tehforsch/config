if [[ $# -gt 0 ]]; then
    pngs="$@"
else
    pngs="*.png"
fi
cat $pngs | ffmpeg -c:v libx264 -f image2pipe -i - output.mp4

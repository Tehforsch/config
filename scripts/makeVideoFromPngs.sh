if [[ $# -gt 0 ]]; then
    pngs="$@"
else
    pngs="*.png"
fi
cat $pngs | ffmpeg -framerate 20 -f image2pipe -i - output.mp4

# also useful
# ffmpeg -framerate 10 -r 10 -f image2 -s 1920x1080 -i sliceWithStarParticles_z_Temperature_0_0%2d.png -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -crf 15  -pix_fmt yuv420p output.mp4

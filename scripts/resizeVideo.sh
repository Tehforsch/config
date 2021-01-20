if [[ $# != 3 ]]; then
    echo "need source file, target file and target size as params"
    exit 0
fi
inputFile="$1"
outputFile="$2"
target_size_mb="$3"
target_size=$(( $target_size_mb * 1000 * 1000 * 8 )) # 25MB in bits
length=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 $inputFile`
length_round_up=$(( ${length%.*} + 1 ))
total_bitrate=$(( $target_size / $length_round_up ))
audio_bitrate=$(( 128 * 1000 )) # 128k bit rate
video_bitrate=$(( $total_bitrate - $audio_bitrate ))
ffmpeg -i "$inputFile" -b:v $video_bitrate -maxrate:v $video_bitrate -bufsize:v $(( $target_size / 20 )) -b:a $audio_bitrate "$outputFile"

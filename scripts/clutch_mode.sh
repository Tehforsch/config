#!/usr/bin/env bash

# Toggle Mumble volume between 100% and 40% (~60% reduction)

TARGET_VOLUME=0.40
NORMAL_VOLUME=1.00

stream_ids=$(pw-dump 2>/dev/null | jq -r '
    .[] |
    select(.info.props["media.class"]? == "Stream/Output/Audio") |
    select(
        (.info.props["application.name"]? // "" | test("Mumble";"i")) or
        (.info.props["application.process.binary"]? // "" | test("mumble";"i")) or
        (.info.props["node.name"]? // "" | test("mumble";"i"))
    ) |
    .id
')

if [ -z "$stream_ids" ]; then
    exit 0
fi

# Check volume of the first stream to decide toggle direction
first_id=$(echo "$stream_ids" | head -1)
current_vol=$(wpctl get-volume "$first_id" | awk '{print $2}')

# If volume is close to 1.00, reduce it; otherwise restore it
if awk "BEGIN { exit !($current_vol > 0.50) }"; then
    new_volume="$TARGET_VOLUME"
else
    new_volume="$NORMAL_VOLUME"
fi

for id in $stream_ids; do
    wpctl set-volume "$id" "$new_volume"
done

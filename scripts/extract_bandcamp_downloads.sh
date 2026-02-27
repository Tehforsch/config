#!/usr/bin/env bash

set -e

DRY_RUN=false

if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo "=== DRY RUN MODE ==="
    echo
fi

for zip_file in *.zip; do
    if [ ! -f "$zip_file" ]; then
        echo "No zip files found"
        exit 0
    fi

    filename="${zip_file%.zip}"

    if [[ "$filename" =~ \ -\  ]]; then
        artist="${filename%% - *}"
        album="${filename#* - }"

        target_dir="extracted/$artist/$album"

        echo "Processing: $zip_file"
        echo "  Artist: $artist"
        echo "  Album: $album"
        echo "  Target: $target_dir"

        if [ "$DRY_RUN" = true ]; then
            echo "  [DRY RUN] Would create: $target_dir"
            echo "  [DRY RUN] Would extract to: $target_dir"
        else
            mkdir -p "$target_dir"
            unzip -q "$zip_file" -d "$target_dir"
            echo "  ✓ Extracted"
        fi
        echo
    else
        echo "Skipping '$zip_file' - doesn't match expected format"
    fi
done

if [ "$DRY_RUN" = true ]; then
    echo "Dry run complete - no files were extracted"
else
    echo "All albums extracted successfully!"
fi

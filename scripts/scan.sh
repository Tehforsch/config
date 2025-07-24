#!/usr/bin/env bash
set -euo pipefail

CONSUME_DIR="/var/lib/paperless/consume"
FILENAME_PREFIX="SCAN"
DATE=$(date +%Y-%m-%d-%H-%M-%S)
FILENAME="${FILENAME_PREFIX}_${DATE}.pdf"
TEMP_DIR=$(mktemp -d)

echo "Scanning to: $FILENAME"
echo "Temporary directory: $TEMP_DIR"

pushd "$TEMP_DIR"

# This might change in the future. Not sure about the numbers. Worst case, use scanimage -L to obtain it.
dev=epjitsu:libusb:005:005

SOURCE_OPTION=""
if [[ "${1:-}" == "--two-sided" ]]; then
    scanimage -d $dev --format=pnm --mode=Color --resolution 300 --batch=scan_%03d.pnm --batch-start=1 --batch-increment=1 --source="ADF Duplex"
    shift
else 
    scanimage -d $dev --format=pnm --mode=Color --resolution 300 --batch=scan_%03d.pnm --batch-start=1 --batch-increment=1
fi


magick scan_*.pnm "$FILENAME"
chmod 644 "$FILENAME"

mv "$FILENAME" "$CONSUME_DIR/$FILENAME"

echo "Scan complete"
echo "$CONSUME_DIR/$FILENAME"

popd
rm -rf "$TEMP_DIR"

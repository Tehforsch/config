date=$(date +"%Y%m%d%H%M%S")
mkdir -p /home/toni/.playground/screenshots
mv ~/.playground/screenshots/aScreenshot.png ~/.playground/screenshots/${date}.png
scrot -s ~/.playground/screenshots/aScreenshot.png

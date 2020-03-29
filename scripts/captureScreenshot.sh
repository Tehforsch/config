#!/bin/bash
tempScreenshotFile=~/.tempScreenshot.png
scrot -s $tempScreenshotFile
# Turn white transparent
convert $tempScreenshotFile -transparent white $1
rm $tempScreenshotFile

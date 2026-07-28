#!/usr/bin/env bash
sudo umount /mnt/android

set -e

sudo mkdir -p /mnt/android
sudo chown $USER:users /mnt/android
simple-mtpfs /mnt/android
echo "Android device mounted at /mnt/android"

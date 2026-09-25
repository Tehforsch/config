#!/usr/bin/env bash
set -euo pipefail

sudo umount /mnt/android 2>/dev/null || true

sudo mkdir -p /mnt/android
sudo chown "$USER":users /mnt/android
go-mtpfs /mnt/android
echo "Android device mounted at /mnt/android"

#!/usr/bin/env bash

sudo mkdir -p /mnt/android
sudo chown $USER:users /mnt/android
jmtpfs /mnt/android
echo "Android device mounted at /mnt/android"
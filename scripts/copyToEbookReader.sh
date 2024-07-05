devId=$(lsblk -o name,label | grep KOBO | cut -d " " -f 1)
sudo mount /dev/$devId /mnt/ebookreader
sudo cp "$1" /mnt/ebookreader
sudo umount /mnt/ebookreader

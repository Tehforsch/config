while [[ 1 ]]; do
    echo "Syncing"
    cd /home/$USER/notes
    ./update.sh
    cd /home/$USER/music
    ./update.sh
    cd /home/$USER/pictures
    ./update.sh
    sleep 3600
done
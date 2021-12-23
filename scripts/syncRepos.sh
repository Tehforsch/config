while [[ 1 ]]; do
    echo "Syncing"
    cd /home/$USER/notes
    ./update.sh
    cd /home/$USER/music
    ./update.sh
    mpc update
    cd /home/$USER/pictures
    ./update.sh
    task sync
    sleep 3600
done

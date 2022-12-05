while [[ 1 ]]; do
    echo "Syncing"
    task sync
    cd /home/$USER/notes
    ./update.sh
    cd /home/$USER/music
    ./update.sh
    mpc update
    cd /home/$USER/pictures
    ./update.sh
    cd /home/$USER/finances
    ./update.sh
    sleep 600
done

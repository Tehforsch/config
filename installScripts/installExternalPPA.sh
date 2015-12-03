#Git most recent version
sudo add-apt-repository ppa:git-core/ppa

#Spotify
add-apt-repository 'deb http://repository.spotify.com/ stable non-free' 
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 94558F59  

#Ledger
add-apt-repository ppa:mbudde/ledger

# Update
apt-get update

# Install everything
apt-get --yes git install ledger spotify-client

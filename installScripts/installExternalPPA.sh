#Git most recent version
sudo add-apt-repository ppa:git-core/ppa

#Spotify
#add-apt-repository 'deb http://repository.spotify.com/ stable non-free' 
#apt-key adv --recv-keys --keyserver keyserver.ubuntu.com D2C19886  
#Neovim
# add-apt-repository ppa:neovim-ppa/unstable

#Ledger
add-apt-repository ppa:mbudde/ledger

# Update
apt-get update

# Install everything
# apt-get --yes install ledger spotify-client git neovim
apt-get --yes install spotify-client git
apt-get --yes install -f

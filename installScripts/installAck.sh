# Install
sudo apt-get install ack-grep
# Change name from ack-grep to ack
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

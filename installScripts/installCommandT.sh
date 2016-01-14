# If this doesn't work maybe ruby-dev or even ruby isn't installed. Execute installPackages first
echo "NEEDS ROOT LATER ON"
cd ~/.vim/bundle/command-t/ruby/command-t
ruby extconf.rb
make
sudo make install

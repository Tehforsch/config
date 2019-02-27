# write a script to init.d which kills spotify before shutdown. this ensures that spotify remembers the last played song.
# otherwise it starts with the same song for months which is super annoying
# honestly just fuck the spotify client, it has to be treated differently all the time because the
# developers cant get their shit together
echo "killall spotify" > /etc/init.d/killspotify
chmod 0755 /etc/init.d/killspotify
ln -s ../init.d/killspotify /etc/rc0.d/k99killspotify

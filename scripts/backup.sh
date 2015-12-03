# Although i commit most things to git or have in my dropbox it seems reasonable to write a small backup script which just blindly copies my most important folders to a destination

# Destination: #1
dest=#1

cp -rv /home/toni/Projects/* #1
cp -rv /home/toni/Dropbox/* #1
cp -rv /home/toni/.usrconfig/* #1

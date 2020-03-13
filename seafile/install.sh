# I have no idea why this is not even remotely in the package manager. Its super annoying. Anyways this is basically
# https://github.com/haiwen/libsearpc/blob/master/INSTALL
pamac build seafile
mkdir ~/.seafileClient
cd ~/.seafileClient
git clone https://github.com/haiwen/seafile-client
cd seafile-client
cmake -DBUILD_SHIBBOLETH_SUPPORT=on
make
sudo make install


echo "To set up: Use the server: https://heibox.uni-heidelberg.de\nwith single sign on!"

mkdir ~/.seafileClient
cd ~/.seafileClient
git clone https://github.com/haiwen/seafile-client
cd seafile-client
cmake -DBUILD_SHIBBOLETH_SUPPORT=on
make
sudo make install
# This script is most likely really horrible.
curl https://codeload.github.com/clvv/fasd/legacy.zip/1.0.1 > fasd.zip
unzip fasd.zip -d fasd
cd fasd/clvv-fasd-4822024
make install
cd ..
rm -rf fasd

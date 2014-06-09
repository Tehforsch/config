echo "Needs to be executed as sudo (Im lazy, i didnt check just try to remember :D)"
pushd $(pwd)
mkdir ~/.solarized/
cd ~/.solarized/
wget --no-check-certificate https://raw.github.com/seebi/dircolors-solarized/master/dircolors.ansi-dark
mv dircolors.ansi-dark .dircolors
eval `dircolors ~/.dircolors`
git clone https://github.com/sigurdga/gnome-terminal-colors-solarized.git
gnome-terminal-colors-solarized/install.sh
popd


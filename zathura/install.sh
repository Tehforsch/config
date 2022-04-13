# register as pdf viewer for default terminal commands. this can't be an alias because i3-msg doesnt expand aliases
binFolder=/home/toni/.local/bin/
mkdir -p $binFolder
echo "zathura \"\$@\"" > $binFolder/pdf
chmod +x $binFolder/pdf

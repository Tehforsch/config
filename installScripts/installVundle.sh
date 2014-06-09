rm -rf ~/.vim
ln -s ~/.usrconfig/.vim ~/.vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

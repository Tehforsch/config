" important
" moving around, searching and patterns
    " Highlight search while typing
    set incsearch
    " Show search highlight
    " set hlsearch
    " Set ignore case when searching (watch out for smartcase)
    set ignorecase
    " Search case sensitive when pattern contains uppercase characters
    set smartcase
    " Map single quote to apostrophe in normal mode (jump to exact mark)
    nmap ' `
    " Substitute multiple occurences in one line per default
    set gdefault
" tags
" syntax, highlighting and spelling
    " Enable syntax highlighting
    syntax on
    " Disable highlighting of matching parantheses (lags)
    let loaded_matchparen = 1
" displaying text
" multiple buffers
    set hidden
" multiple windows
" multiple tab pages
" terminal
    " Use different cursor colors for the different modes.
    if &term =~ "xterm\\|rxvt"
      " use an orange cursor in insert mode
      let &t_SI = "\<Esc>]12;orange\x7"
      " use a red cursor otherwise
      let &t_EI = "\<Esc>]12;red\x7"
      silent !echo -ne "\033]12;red\007"
      " reset cursor when vim exits
      autocmd VimLeave * silent !echo -ne "\033]112\007"
      " use \003]12;gray\007 for gnome-terminal
    endif
" using the mouse
" GUI
    set guicursor=a:blinkon0
" printing
" messages and info
    set ruler
    set number
" selecting text
" editing text
    " Swap the current word with the next word (which can be on a newline and punctuation is " skipped"):
    nmap <silent> gw " _yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>:noh<CR>
" tabs and indenting
    " Auto indent after indentation"
    " set smartindent
    " Tab size 4
    set tabstop=4
    " Convert tabs to spaces
    set expandtab
    " Size of indents with < and > command: 4
    set shiftwidth=4
    " Delete 4 spaces at once when deleting tabs.
    set softtabstop=4
    " Enable filetype detection
    filetype indent on
" folding
" diff mode
" mapping
    " Map <C-n> to clear all search highlights.
    nmap <silent> <C-n> :noh<CR>
" reading and writing files
" the swap file
    " Don't write backup and swap files.
    set nobackup
    set nowritebackup
    set noswapfile
" command line editing
" executing external commands
" running make and jumping to errors
" language specific
" multi-byte characters
" various
    " Enable filetype specific plugins
    filetype plugin on
    " Set tab-key behaviour (when opening files).
    set wildmode=longest,list,full
    set wildmenu
    " Fix the delay after ESC - o
    set timeout timeoutlen=1000 ttimeoutlen=100
    " Increase history size.
    set history=200

" plugin specific settings
    " Syntastic
    let g:syntastic_enable_highlighting=0
    let g:syntastic_check_on_open=0
    let g:syntastic_check_on_wq=0
    let g:syntastic_enable_balloons=0
    let g:syntastic_python_checkers=['flake8']
    let g:syntastic_tex_checkers = []
    " Airline
    set laststatus=2
    " Nerdtree
    map <C-t> :NERDTreeToggle<cr> \| :silent NERDTreeMirror<CR>
    vmap <C-t> <esc>:NERDTreeToggle<cr> \| :silent NERDTreeMirror<CR>
    imap <C-t> <esc>:NERDTreeToggle<cr> \| :silent NERDTreeMirror<CR>

" vundle
    set nocompatible              " be iMproved
    filetype off                  " required!

    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " let Vundle manage Vundle
    Bundle 'gmarik/vundle'
    " Solarized color scheme
    Bundle 'altercation/vim-colors-solarized'
    " Comment out lines with gcc, comment out movements/visual selections with gc
    Bundle 'tpope/vim-commentary'
    " Repeat composite commands with .
    Bundle 'tpope/vim-repeat'
    " Surround movements/ranges, for example ysiw( surrounds the word with a
    " bracket.
    Bundle 'tpope/vim-surround'
    " Git plugin.
    Bundle 'tpope/vim-fugitive'
    " Syntax checker 
    Bundle 'scrooloose/syntastic'
    " File manager thing
    Bundle 'scrooloose/nerdtree'
    " Status bar
    Bundle 'bling/vim-airline'
    " Git plugin 2.
    Bundle 'airblade/vim-gitgutter'
    " Todo.txt for testing
    Bundle 'freitass/todo.txt-vim'
    " Haskell syntax
    Bundle 'travitch/hasksyn'


    filetype plugin indent on

    " Disable automatic comment insertion when inserting new line while on a commented line
   autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Solarized color scheme
    set t_Co=16
    set background=dark
    colorscheme solarized

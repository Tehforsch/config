"mappings - basic
    " Use space as leader key
    let mapleader = "\<Space>"
    " Map <C-T> to command-t plugin which doesn't seem to work by default
    nmap <silent> <Leader>t :CommandT<CR>
    " Map , to : since I never use , anyways
    nmap <silent> , :
    vmap <silent> , :
    " Map <CR> to G so number<CR> jumps to the line which is convenient
    nnoremap <CR> G
    " Map single quote to apostrophe in normal mode (jump to exact mark)
    nmap ' `
    " Write file 
    nnoremap <Leader>w :w<Cr>
    " Close vim
    nnoremap <Leader>q :q<Cr>
    " Switch to last buffer
    noremap <Leader>^ <C-^>
"mappings - editing text
    " Swap the word the cursor is on with the next word (which can be on a
    " newline, and punctuation is "skipped"):
    nmap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>:noh<CR>
    " Duplicate the current line and comment out the top one (using vim-commentary)
    nmap <Leader>c yypkgccj
    vmap <Leader>c gcgvyPgvgc
    " Quicker mapping for commenting out lines
    nmap <C-e> gcc
    imap <C-e> <C-o>gcc
    vmap <C-e> gc
    " Make Y behave like y$ which is analogous to C or D
    nmap Y y$
"mappings for plugins
    " Add quick mappings for sideways.vim that allow shifting of arguments
    nmap <Leader>h :SidewaysLeft<CR>
    nmap <Leader>l :SidewaysRight<CR>
    " Add text objects for sideways.vim
    omap aa <Plug>SidewaysArgumentTextobjA
    xmap aa <Plug>SidewaysArgumentTextobjA
    omap ia <Plug>SidewaysArgumentTextobjI
    xmap ia <Plug>SidewaysArgumentTextobjI
" saved macros
    let @t = "ysiw}i\\text\<Esc>f}"

" moving around, searching and patterns
    " Highlight search while typing
    set incsearch
    " Set ignore case when searching (watch out for smartcase)
    set ignorecase
    " Search case sensitive when pattern contains uppercase characters
    set smartcase
    " Substitute multiple occurences in one line per default
    set gdefault
    " Enable the mouse for scrolling purposes
    " set mouse=a

" internal vim features
    " Disable the interpretation of numbers as octal when using C-A or C-X on numbers like 07
    set nrformats=""

" syntax, highlighting and spelling
    " Enable syntax highlighting
    syntax on
    " Disable highlighting of matching parantheses (lags)
    let loaded_matchparen = 1
    " Gnuplot comments
    autocmd BufNewFile, BufRead *.gpi set filetype gnuplot
    autocmd FileType gnuplot set commentstring=#\ %s

" multiple files
    set hidden
    set wildignore=*.o,*.pyc,*.class,*.eps,*.pdf,*.log,*.aux,*.dvi,*.out,*.bbl,*.blg
    " Don't write backup and swap files.
    set nobackup
    set nowritebackup
    set noswapfile

" messages and info
    set ruler
    set number

" tabs and indenting
    " Tab size 4
    set tabstop=4
    " Convert tabs to spaces
    set expandtab
    " Size of indents with < and > command: 4
    set shiftwidth=4
    " Delete 4 spaces at once when deleting tabs.
    set softtabstop=4

" various
    " Set tab-key behaviour (when opening files).
    set wildmode=longest,list,full
    set wildmenu
    " Fix the delay after ESC - o
    set timeout timeoutlen=1000 ttimeoutlen=100
    " Increase history size.
    set history=2000


" plugin specific settings
    " Php indentation
    let g:PHP_default_indenting = 1
    " Command-T
    let g:CommandTAlwaysShowDotFiles = 1
    " Ultisnips
    let g:UltiSnipsExpandTrigger="<tab>"                                            
    let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
    let g:UltiSnipsJumpBackwardTrigger="<s-tab>"        

    set nocompatible              " be iMproved, required
    filetype off                  " required

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()

    " let Vundle manage Vundle, required
    Plugin 'gmarik/Vundle.vim'
    " Solarized color scheme
    Plugin 'altercation/vim-colors-solarized'
    " Comment out lines with gcc, comment out movements/visual selections with gc
    Plugin 'tpope/vim-commentary'
    " Repeat composite commands with .
    Plugin 'tpope/vim-repeat'
    " Surround text objects. example: ysiw( surrounds the word with a bracket.
    Plugin 'tpope/vim-surround'
    " File finder
    Plugin 'wincent/command-t'
    " Todo.txt for testing
    Plugin 'freitass/todo.txt-vim'
    " Indentation for PHP
    Plugin '2072/PHP-Indenting-for-VIm'
    " Ultisnips 
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    " Exchange
    Plugin 'tommcdo/vim-exchange'
    " Targets - Adds some text objects to work on.
    " Adds function argument text objects
    Plugin 'AndrewRadev/sideways.vim'
    " Ack.vim
    Plugin 'mileszs/ack.vim'
    " Plugin adding ended, switch filetype settings back on
    call vundle#end()            " required
    filetype plugin indent on    " required

    " Disable automatic comment insertion when inserting new line while on a commented line
   autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Solarized color scheme
    set t_Co=16
    set background=dark
    colorscheme solarized

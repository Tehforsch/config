"mappings - basic
    " Use space as leader key
    let mapleader = "\<Space>"
    " Map <C-T> to command-t plugin which doesn't seem to work by default
    nnoremap <silent> <Leader>t :CommandT .<CR>
    " Map <CR> to G so number<CR> jumps to the line which is convenient
    nnoremap <CR> G
    " Map single quote to apostrophe in normal mode (jump to exact mark)
    nnoremap ' `
    " Map # which searches backwards for the current word under the cursor to exact mark jumping
    nnoremap # `
    " Write file 
    nnoremap <Leader>w :w<Cr>
    " Close vim
    nnoremap <Leader>q :q<Cr>
    " Switch to last buffer
    noremap <Leader>^ <C-^>
    " Replace the current line by the line thats contained in "1 and leave all registers intact
    nnoremap <Leader>p "_ddP
    vnoremap <Leader>p "_dP
    " Delete line without copying
    nnoremap <Leader>d "_dd
"mappings - editing text
    " Swap the word the cursor is on with the next word (which can be on a
    " newline, and punctuation is "skipped"):
    nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o>:noh<CR>
    " Surround the word under the cursor with {} and start typing a latex command in front of it
    " so we get \TYPEHERE{word}. This will probably create some problems?
    nmap gl ysiw}i\
    " Duplicate the current line and comment out the top one (using vim-commentary)
    nmap <Leader>c yypkgccj
    vmap <Leader>c gcgvyPgvgc
    " Make Y behave like y$ which is analogous to C or D
    nnoremap Y y$
"mappings for plugins
    " Add quick mappings for sideways.vim that allow shifting of arguments
    nmap <Leader>h :SidewaysLeft<CR>
    nmap <Leader>l :SidewaysRight<CR>
    " Add text objects for sideways.vim
    omap aa <Plug>SidewaysArgumentTextobjA
    xmap aa <Plug>SidewaysArgumentTextobjA
    omap ia <Plug>SidewaysArgumentTextobjI
    xmap ia <Plug>SidewaysArgumentTextobjI
    " Camel-Case plugin mappings
    omap <silent> ic <Plug>CamelCaseMotion_iw
    xmap <silent> ic <Plug>CamelCaseMotion_iw
    "onoremap <silent> ib <Plug>CamelCaseMotion_ib
    "xnoremap <silent> ib <Plug>CamelCaseMotion_ib
    "onoremap <silent> ie <Plug>CamelCaseMotion_ie
    "xnoremap <silent> ie <Plug>CamelCaseMotion_ie
    " CommandT file refresh
    noremap <F5> :CommandTFlush<CR>
    " Quicker mapping for commenting out lines
    nmap <C-e> gcc
    imap <C-e> <C-o>gcc
    vmap <C-e> gc
" mappings - misc
    noremap <F4> :source ~/.vimrc<CR>

" Session saving / loading - http://lucasoman.blogspot.de/2009/08/vim-tip-session-management.html
    if version >= 700
        " localoptions has to be here:
        " for some reason, new session loading code fails to set filetype of files in session
      set sessionoptions=blank,tabpages,folds,localoptions,curdir,resize,winsize,winpos
    endif

    command! -nargs=1 Project :call LoadProject('<args>')
    command! -nargs=+ SaveProject :call SaveProject('<args>')

    let s:projectloaded = 0
    let s:loadingproject = 0
    let s:projectname = ''

    function! LoadProject(name)

        let s:projectloaded = 1
        let s:projectname = a:name
        exe "source ~/.vimfiles/projects/".a:name.".vim"
        exe "rviminfo! ~/.vimfiles/projects/".a:name.".viminfo"

    endfunction

    function! SaveProject(name)

        if a:name ==# ''
            if s:projectloaded == 1
                let pname = s:projectname
            endif
        else
            let pname = a:name
        endif

        if pname !=# ''
            let s:projectloaded = 0
            let s:projectname = ''
            exe "mksession! ~/.vimfiles/projects/".pname.".vim"
            exe "wviminfo! ~/.vimfiles/projects/".pname.".vim"
        endif

    endfunction

autocmd VimLeave * call SaveProject()
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
    augroup gnuplot
        autocmd!
        autocmd BufNewFile, BufRead *.gpi set filetype gnuplot
        autocmd FileType gnuplot set commentstring=#\ %s
    augroup END

" multiple files
    set hidden
    set wildignore=*.o,*.pyc,*.class,*.eps,*.pdf,*.log,*.aux,*.dvi,*.out,*.bbl,*.blg,*.toc,*.snm,*.nav
    " Don't write backup and swap files.
    set nobackup
    set nowritebackup
    set noswapfile

" messages and info
    set ruler
    set number
" messages and info in gvim (for eclim mostly)
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar

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
    " Comment out lines with gcc, comment out movements/visual selections with gc
    Plugin 'tpope/vim-commentary'
    " Repeat composite commands with .
    Plugin 'tpope/vim-repeat'
    " Surround text objects. example: ysiw( surrounds the word with a bracket.
    Plugin 'tpope/vim-surround'
    " File finder
    Plugin 'wincent/command-t'
    " Ultisnips 
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    " Exchange with cx<operator>
    Plugin 'tommcdo/vim-exchange'
    " Adds function argument text objects
    Plugin 'AndrewRadev/sideways.vim'
    " Ack.vim
    Plugin 'bkad/CamelCaseMotion'
    " Autocompletion for python 
    Plugin 'davidhalter/jedi-vim'
    " Solarized Colorscheme
    Bundle 'altercation/vim-colors-solarized'
    " Adding ended, switch filetype settings back on
    call vundle#end()            " required
    filetype plugin indent on    " required

    " Disable automatic comment insertion when inserting new line while on a commented line
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o

" Solarized color scheme
    set t_Co=16
    syntax enable
    set background=dark
    colorscheme solarized

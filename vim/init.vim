"mappings
    " Use space as leader key
    let mapleader = "\<Space>"
    " Map <Leader>t to fzf fuzzy search plugin 
    nnoremap <silent> <leader>t :Files<cr>
    " Map <Leader>b to fzf fuzzy search plugin for buffers
    nnoremap <silent> <leader>b :call fzf#vim#buffers('', {'down': '40%'})<cr>
    " Map single quote to apostrophe in normal mode (jump to exact mark)
    nnoremap ' `
    " Map # which searches backwards for the current word under the cursor to exact mark jumping
    nnoremap # `
    " Map jumping through changelist to <C-j> and <C-k>
    map <C-k> g;
    map <C-j> g,
    " Write file 
    nnoremap <Leader>w :w<Cr>
    " Close vim
    nnoremap <Leader>q :wq<Cr>
    " Switch to last buffer
    noremap <Leader>^ <C-^>
    nnoremap <Leader>h :bp<CR>
    nnoremap <Leader>l :bn<CR>
    " Disable ex mode which is only opened because I mess up
    nnoremap Q <nop>
    " map Y to yank and re-select on visual selections
    vnoremap Y ygv
    " map C-o to the normal behavior (go to last jump location) but then center on the current position (zz)
    nnoremap <C-o> <C-o>zz
    " Go to next quickfix item
    "nnoremap <Leader>n :cn<CR>
    nnoremap <Leader>p :cp<CR>

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

"mappings - command line
    " w!! writes file as sudo if it was opened without
    cnoremap  w!! w !sudo tee % > /dev/null

"mappings for plugins
    " Quicker mapping for commenting out lines
    nmap <C-e> gcc
    imap <C-e> <C-o>gcc
    vmap <C-e> gc
    " gitgutter - disable all automatic mappings
    let g:gitgutter_map_keys = 0
    " gitgutter hunk jumping
    nmap <Leader>j <Plug>(GitGutterNextHunk)
    nmap <Leader>k <Plug>(GitGutterPrevHunk)
    " gitgutter hunk text objects
    omap ih <Plug>(GitGutterTextObjectInnerPending)
    omap ah <Plug>(GitGutterTextObjectOuterPending)
    xmap ih <Plug>(GitGutterTextObjectInnerVisual)
    xmap ah <Plug>(GitGutterTextObjectOuterVisual)
    " gitgutter hunk staging and undo
    nmap <Leader>ha <Plug>(GitGutterStageHunk)
    nmap <Leader>hu <Plug>(GitGutterUndoHunk)
    " " Map <Leader>f to fzf fuzzy search for symbols in file
    " nnoremap <silent> <leader>t :call fzf#vim#files('',
  " \ {'source': 'fd --follow --type file', 'down': '40%'})<cr>


" mappings - misc
    noremap <F4> :source ~/.vimrc<CR>
    " This is a little out of place but this is quite nice when viewing guitar tabs.
    " It opens the same file in two split windows to the right of the current window and scrolls down
    " as many lines as my main monitor can fit so that I can see as much as possible of the tab
    " at once.
    nnoremap <F10> :vert new %<CR>:vert new %<CR><C-w>l52jzt<C-w>l106jzt

" copy/paste to system clipboard
    set clipboard=unnamedplus

" Paste over visual selections without yanking them
    xnoremap p pgvy

" When editing a directory: Make selecting a file open that file in the same buffer instead of a new one
    autocmd FileType netrw setl bufhidden=wipe
" Close netrw buffer after selecting a file
    let g:netrw_fastbrowse = 0

" Don't yank when changing
    nnoremap c "_c
    nnoremap C "_C
" Don't yank when deleting single letter
    nnoremap x "_x

" moving around, searching and patterns
    " Highlight search while typing
    set incsearch
    " Set ignore case when searching (watch out for smartcase)
    set ignorecase
    " Search case sensitive when pattern contains uppercase characters
    set smartcase
    " Substitute multiple occurences in one line per default
    set gdefault
    " Clear highlighting on escape in normal mode
    nnoremap <esc> :noh<return><esc>
    nnoremap <esc>^[ <esc>^[
    " Disable vim restarting at top (or bottom) of file when searching which is only annoying
    set nowrapscan


"Buffer settings
    " Do not jump to the beginning of the line when switching buffers but stay
    " at exact cursor position (life saving)
    set nostartofline

" Terminator support
    set guicursor=
    
" tab line for buffers
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#right_sep = ''
    let g:airline#extensions#tabline#right_alt_sep = ''

" status line
    " always show status line
    set laststatus=2
    " disable separators
    let g:airline_left_sep = ''
    let g:airline_right_sep = ''
    " Show path of current file relative to working directory
    let g:airline_section_b = '%f'
    let g:airline_section_c = ''
    " For the following see airline-customization in airline help
    " for reference
    " By default shows warnings/errors (from syntastic or something)
    let g:airline_section_warning = ''
    let g:airline_section_errors = ''
    " By default shows file encoding which is too cluttered for me
    let g:airline_section_x = ''
    let g:airline_section_y = ''
    let g:airline_section_z = ''

" internal vim features
    " Disable the interpretation of numbers as octal when using C-A or C-X on numbers like 07
    set nrformats=""

" syntax, highlighting and spelling
    " Enable syntax highlighting
    syntax on
    " Disable showing of matching parantheses for some versions of vim
    set noshowmatch
    " Disable highlighting of matching parantheses (lags)
    let loaded_matchparen = 1
    " Proper comment strings:
    " set default comment string to #
    set commentstring=#\ %s

    autocmd FileType c,cpp,cs,java set commentstring=//\ %s
" fortran indent 2
    autocmd Filetype fortran setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
" javascript indent 2
    autocmd Filetype javascript setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
" use latex instead of plaintex at all times
    let g:tex_flavor = "latex"

" Close quickfix window with escape.
    autocmd FileType qf nnoremap <buffer><silent> <esc> :quit<cr>

" when having a visual selection: replace the selection by typing a variable name
" and write variable = selection in the line above
" currently this is only mapped in python, in other languages there might be different
" assignment operators.
    autocmd FileType python vnoremap <expr> gs "ygvc" . input("Variable name:") . "\<ESC>O\<C-r>. = \<C-r>0\<Esc>"

" indent preprocessor statements correctly in c++
    set cinkeys=0{,0},0),:,!^F,o,O,e

" multiple files
    set hidden
    set wildignore=*.o,*.pyc,*.class,*.eps,*.pdf,*.log,*.aux,*.dvi,*.out,*.bbl,*.blg,*.toc,*.snm,*.nav,*.mod
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
    set timeout timeoutlen=300 ttimeoutlen=10
    " Increase history size.
    set history=2000

" Mappings for cscope
    nmap <C-u>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-u>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-u>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-u>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-u>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-u>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-u>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-u>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    call plug#begin('~/.local/share/nvim/plugged')
    " Comment out lines with gcc, comment out movements/visual selections with gc
    Plug 'tpope/vim-commentary'
    " Repeat composite commands with .
    Plug 'tpope/vim-repeat'
    " Surround text objects. example: ysiw( surrounds the word with a bracket.
    Plug 'tpope/vim-surround'
    " Exchange with cx<operator>
    Plug 'tommcdo/vim-exchange'
    " Solarized Colorscheme
    Plug 'morhetz/gruvbox'
    " Status line
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Git plugin
    Plug 'airblade/vim-gitgutter'
    " Some text objects
    Plug 'wellle/targets.vim'
    " Quickly check for synonyms
    Plug 'ron89/thesaurus_query.vim'
    " Rust
    Plug 'rust-lang/rust.vim'
    " Ag
    Plug 'brookhong/ag.vim'
    " Fzf-Vim
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    " LSP
    Plug 'morhetz/gruvbox'

    call plug#end()

" Solarized color scheme
    set t_Co=16
    let g:solarized_termtrans=1
    syntax enable
    set background=dark
    colorscheme gruvbox

" Stuff we have to do after everything else. (for whatever reason)
    " Hide status (insert etc.) because its done by airline
    set noshowmode
    " Disable automatic comment insertion when inserting new line while on a commented line
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o

" Set search highlighting colors to less intrusive
    syntax on
    hi Search ctermbg=white ctermfg=black

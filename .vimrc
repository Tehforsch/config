"1 important
execute pathogen#infect()
"2 moving around, searching and patterns
    "Highlight search while typing
    set incsearch
    "Set ignore case when searching (watch out for smartcase)
    set ignorecase
    "Search case sensitive when pattern contains uppercase characters
    set smartcase
    "Map single quote to apostrophe in normal mode (jump to exact mark)
    nmap ' `
    "Substitute multiple occurences in one line per default
    set gdefault
"3 tags
"4 displaying text
"5 syntax, highlighting and spelling
    "Enable Syntax Highlighting
    syntax on
    "Disable highlighting of matching parantheses (lags)
    let loaded_matchparen = 1
"6 multiple windows
"7 multiple tab pages
"8 terminal
"9 using the mouse
"10 GUI
    set guicursor=a:blinkon0
"11 printing
"12 messages and info
    set ruler
    set number
"13 selecting text
"14 editing text
"15 tabs and indenting
    "Auto indent after indentation"
    set smartindent
    "Tab size 4
    set tabstop=4
    "Convert tabs to spaces
    set expandtab
    "Size of indents with < and > command: 4
    set shiftwidth=4
    "Delete 4 spaces at once when deleting tabs.
    set softtabstop=4
    "Enable filetype detection
    filetype indent on
"16 folding
"17 diff mode
"18 mapping
    "Map <C-n> to clear all search highlights.
    nmap <silent> <C-n> :noh<CR>
"19 reading and writing files
"20 the swap file
"21 command line editing
"22 executing external commands
"23 running make and jumping to errors
"24 language specific
"25 multi-byte characters
"26 various
    "Enable filetype specific plugins
    filetype plugin on
    "Set tab-key behaviour (when opening files).
    set wildmode=longest,list,full
    set wildmenu
    "Fix the delay after ESC - o
    set timeout timeoutlen=1000 ttimeoutlen=100
    "Increase history size.
    set history=200
"Pre-defined macros
    "Make a for loop in Java
    let @f ='^ifor<SPACE>(int<SPACE><ESC>lyiwa<SPACE>=<ESC>wa;<SPACE>i<SPACE><LT><BACKSPACE><BACKSPACE><BACKSPACE><ESC>pa<LT><SPACE><BACKSPACE><BACKSPACE><SPACE><LT><ESC>A;<SPACE><ESC>pA++)]<BACKSPACE>{<RETURN>}<ESC>O<ESC>'

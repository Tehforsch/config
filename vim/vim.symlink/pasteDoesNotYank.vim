" in visual mode map pasting to pasting without copying
" which is cool because its super nice to replace words
" in visual mode and i never want to copy the replaced words
" stolen from http://stackoverflow.com/questions/290465/vim-how-to-paste-over-without-overwriting-register 
function! RestoreRegister()
    let @" = s:restore_reg
    return ''
endfunction
function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction
vnoremap <silent> <expr> p <sid>Repl()

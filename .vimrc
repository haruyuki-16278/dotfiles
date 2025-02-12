colorscheme industry

" syntax on
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" highlight
set hlsearch
set ignorecase
nmap <Esc><Esc> :nohlsearch<Enter>

" indent
set expandtab
set tabstop=2
set shiftwidth=0

" editor
set number
set cursorline
set cursorcolumn
set visualbell
set showmatch

" terminal
set splitbelow
set termwinsize=25x0

" netrw
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_preview=1
let g:netrw_winsize=150


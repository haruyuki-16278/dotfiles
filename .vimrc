colorscheme industry

set number
set cursorline
set cursorcolumn
set virtualedit=onemore
set visualbell
set showmatch
set laststatus=2

set list
set listchars=tab:>-,trail:$

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

set tabstop=2
set smartindent
set expandtab

set mouse=a

set wildmenu
set nocompatible
set wildmode=full

set nobackup
set noswapfile
set autoread
set hidden
set showcmd

syntax on
filetype plugin indent on

let s:jetpackfile = expand('<sfile>:p:h') .. '/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
  call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
endif

packadd vim-jetpack
call jetpack#begin()

  Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
  Jetpack 'lambdalisue/fern.vim'
  Jetpack 'lambdalisue/fern-git-status.vim'
  Jetpack 'liuchengxu/vim-which-key'
  Jetpack 'skanehira/preview-markdown.vim'
  Jetpack 'airblade/vim-gitgutter'

call jetpack#end()

" which key
" By default timeout len is 1000 ms
set timeoutlen=500

" Map leader to which_key
let g:mapleader = "\<Space>"
let g:maplocalleader = ","
nnoremap <silent> <leader> :<C-u>WhichKey '<Space>'<CR>
nnoremap <silent> <leader> :<C-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<C-u>WhichKey ','<CR>
" create mao to add keys to
let g:which_key_map = {}

" Single mappings
let g:which_key_map['s'] = [ '<C-w>s', 'split below' ]
let g:which_key_map['v'] = [ '<C-w>v', 'split right' ]
let g:which_key_map['w'] = [ '<C-w>w', 'next pane' ]
let g:which_key_map['ns'] = [ ':new', 'new file in split below' ]
let g:which_key_map['nv'] = [ ':vnew', 'new file in split right' ]

let g:which_key_map.t = {
  \ 'name': '+tab',
  \ 'e' : [ '<C-w>gf', 'edit in new tab' ],
  \ 'new' : [ ':tabnew', 'open in new tab'],
  \ 'n' : [ ':tabn', 'move to next tab'],
  \ 'p' : [ ':tabp', 'move to previous tab'],
  \ 'c' : [ ':tabclose', 'close tab'],
  \ 'ls'  : [ ':tabs', 'list tab'],
  \ }

" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Hide status line
augroup vim-which-key
  autocmd!
  autocmd FileType which_key set laststatus=0 noshowmode noruler
augroup END

" Register which key map
call which_key#register('<Space>', "g:which_key_map")

" fern
let g:fern#default_hidden=1
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>
augroup my-fern-startup
  autocmd! *
	autocmd VimEnter * ++nested Fern . -reveal=% -drawer -width=40<CR> | winc p
augroup END

" git-gutter
set updatetime=250
highlight! link SignColumn LineNr
set signcolumn=yes
let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=0
highlight GitGutterAdd ctermbg=1
highlight GitGutterChangeLine ctermbg=2
highlight GitGutterDeleteLine ctermbg=4
highlight GitGutterChangeDeleteLine ctermbg=6
let g:gitgutter_sign_modified = 'M'


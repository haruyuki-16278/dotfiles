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

set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
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
  Jetpack 'vim-airline/vim-airline'
  Jetpack 'vim-airline/vim-airline-themes'
  Jetpack 'prabirshrestha/vim-lsp'
  Jetpack 'mattn/vim-lsp-settings'
  Jetpack 'prabirshrestha/asyncomplete.vim'
  Jetpack 'prabirshrestha/asyncomplete-lsp.vim'
  Jetpack 'Shougo/ddc.vim'
  Jetpack 'shun/ddc-vim-lsp'
  Jetpack 'alvan/vim-closetag'
  Jetpack 'junegunn/fzf'
  Jetpack 'junegunn/fzf.vim'
  Jetpack 'tpope/vim-fugitive'
  Jetpack 'leafgarland/typescript-vim'

call jetpack#end()

for name in jetpack#names()
  if !jetpack#tap(name)
    call jetpack#sync()
    break
  endif
endfor

" typescript settings
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

""" which key
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
let g:which_key_map['g'] = [ ':Git', 'open git status' ]

let g:which_key_map.t = {
  \ 'name': '+tab',
  \ 'e': [ '<C-w>gf', 'edit in new tab' ],
  \ 'new': [ ':tabnew', 'open in new tab'],
  \ 'n': [ ':tabn', 'move to next tab'],
  \ 'p': [ ':tabp', 'move to previous tab'],
  \ 'c': [ ':tabclose', 'close tab'],
  \ 'ls': [ ':tabs', 'list tab'],
  \ }

let g:which_key_map.f = {
  \ 'name': 'fzf',
  \ 'f': [ 'fzf#vim#files("./")', 'open file browser' ],
  \ 'b': [ 'fzf#vim#buffers()', 'open buffer browser' ],
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

""" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_highlighting_cache=1

""" fern
let g:fern#default_hidden=1
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>
"augroup my-fern-startup
"  autocmd! *
"  autocmd VimEnter * ++nested Fern . -reveal=% -drawer -width=40<CR> | winc p
"augroup END

""" git-gutter
set updatetime=250
highlight! link SignColumn LineNr
set signcolumn=yes
let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=0
highlight GitGutterAdd ctermbg=1
highlight GitGutterChange ctermbg=2
highlight GitGutterDelete ctermbg=4
let g:gitgutter_sign_modified = 'M'

""" closetag
let g:closetag_filenames = '*.html'


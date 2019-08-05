syntax on
filetype plugin indent on

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'altercation/vim-colors-solarized'     " Solarized theme
Plug 'ntpeters/vim-better-whitespace'       " Highlight trailing whitespace
Plug 'scrooloose/nerdtree'                  " File tree
Plug 'sheerun/vim-polyglot'                 " On-demand language packs
Plug 'tpope/vim-markdown'                   " Markdown runtime
Plug 'tpope/vim-sensible'                   " Sensible vim defaults
Plug 'tpope/vim-surround'                   " Add quote substition commands
Plug 'vim-airline/vim-airline'              " Lightweight status bar
Plug 'vim-airline/vim-airline-themes'       "    + themes

call plug#end()

set number
set background=light
colorscheme solarized

" Highlight trailing whitespace on save (vim-better-whitespace)
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" ------ Remaps ------
noremap <SPACE> <Nop>
let g:mapleader = ' '

" Move around easily
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

command Markserv !cd $HOME/gh;markserv &

" Edit & reload vim config
nnoremap <silent> <leader>ec :e $MYVIMRC<CR>
nnoremap <silent> <leader>sc :source $MYVIMRC<CR>

" Close NERDTree if it's the only buffer open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

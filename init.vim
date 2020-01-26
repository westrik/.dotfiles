

" TODO:
" - consider replacing deoplete with coc.nvim (https://github.com/neoclide/coc.nvim)
"   	- LSP integration similar to VSCode


" ------------------------------
" Dependencies
" ------------------------------
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')
  " Editing behavior
  Plug 'tpope/vim-sensible'                   " Sensible vim defaults
  Plug 'tpope/vim-surround'                   " Add quote substition commands

  " Appearance
  Plug 'altercation/vim-colors-solarized'     " Solarized theme
  "Plug 'vim-airline/vim-airline'              " Lightweight status bar
  "Plug 'vim-airline/vim-airline-themes'

  " Auto-completion
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  let g:deoplete#enable_at_startup = 1

  " Syntax plugins
	  " Plug 'sheerun/vim-polyglot'	" On-demand language packs
  Plug 'HerringtonDarkholme/yats.vim'
  "Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
  Plug 'maxmellon/vim-jsx-pretty'
  Plug 'tpope/vim-markdown'
  " TODO: add support for python, rust, kotlin, swift

  " Tooling
  Plug '/usr/local/opt/fzf'
  Plug 'scrooloose/nerdtree'
call plug#end()

" ------------------------------
" Configuration
" ------------------------------

syntax on
filetype plugin indent on

set number
set mouse=a
set background=dark
colorscheme solarized


" Leader commands
" -----------------

let g:mapleader = ','

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>d :TSGetDiagnostics
nnoremap <leader>f :FZF


" Automatic behavior
" -----------------

" Close NERDTree if it's the only buffer open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

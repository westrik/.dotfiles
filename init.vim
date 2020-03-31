

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

  " Auto-completion
  "Plug 'neoclide/coc.nvim', {'branch': 'release'}
"  if has('nvim')
"    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"  else
"    Plug 'Shougo/deoplete.nvim'
"    Plug 'roxma/nvim-yarp'
"    Plug 'roxma/vim-hug-neovim-rpc'
"  endif
"  let g:deoplete#enable_at_startup = 1

  " Syntax plugins
	  " Plug 'sheerun/vim-polyglot'	" On-demand language packs
"  Plug 'HerringtonDarkholme/yats.vim'
  "Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
"  Plug 'maxmellon/vim-jsx-pretty'
"  Plug 'tpope/vim-markdown'
  " TODO: add support for python, rust, kotlin, swift

  " Tooling
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'preservim/nerdtree'


  " LSP
  Plug 'neovim/nvim-lsp'
call plug#end()


set rtp+=/usr/local/opt/fzf

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

let g:mapleader = ' '

nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader>f :FZF
nnoremap <leader>n :NERDTree


" Automatic behavior
" -----------------

" Close NERDTree if it's the only buffer open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" LSP config
" -----------------
"
function! LSPSetup()
lua << EOF
require'nvim_lsp'.bashls.setup{};
require'nvim_lsp'.cssls.setup{};
require'nvim_lsp'.jsonls.setup{};
require'nvim_lsp'.pyls.setup{};
require'nvim_lsp'.rust_analyzer.setup{};
require'nvim_lsp'.terraformls.setup{};
require'nvim_lsp'.tsserver.setup{};
EOF
endfunction

function! LSPUpdate()
  LspInstall bashls
  LspInstall cssls
  LspInstall jsonls
  LspInstall pyls
  LspInstall rust_analyzer
  LspInstall terraformls
  LspInstall tsserver
endfunction

call LSPSetup()

autocmd Filetype \
      \bash,
      \sh,
      \css,
      \scss,
      \less,
      \vim,
      \javascript,
      \javascriptreact,
      \javascript.jsx,
      \typescript,
      \typescriptreact,
      \typescript.tsx,
      \terraform,
      \rust,
      \python,
      \json,
      \ setlocal omnifunc=v:lua.vim.lsp.omnifunc

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gF    <cmd>lua vim.lsp.buf.formatting()<CR>


function! LSPHover()
lua << EOF
local util = require 'vim.lsp.util'
local params = util.make_position_params()
vim.lsp.buf.hover()
EOF
endfunction

function! LSPRename()
	let s:newName = input('Enter new name: ', expand('<cword>'))
	echom "s:newName = " . s:newName
	lua vim.lsp.buf.rename(s:newName)
endfunction

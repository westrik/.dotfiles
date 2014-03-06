" ----------------------------------------------------------------------------------
" github.com/mattwestrik/dotfiles 
" ----------------------------------------------------------------------------------

call pathogen#infect()
call pathogen#helptags()

set nocompatible 

" relative line numbering in normal mode
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

filetype plugin indent on 
 
syntax on
set number
set modifiable

set spell
set hlsearch
set autoindent
set history=1000

set tabstop=4 
set softtabstop=4 
set shiftwidth=4 
set expandtab 
set smarttab

set background=dark
colorscheme solarized

let g:airline_powerline_fonts = 1
set laststatus=2 "have airline open all the time
let g:bufferline_echo = 0 "don't show auto echoing from vim
set noshowmode
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif
  let g:airline_symbols.space = "\ua0"

"python from powerline.vim import setup as powerline_setup
"python powerline_setup()
"python del powerline_setup

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

set smartcase


" REMAPPINGS & other commands
" ----------------------------------------------------------------------------------

" Swap semicolon & colon in normal mode
nnoremap ; :

" jk to esc in insert mode
inoremap jk <esc>

" Navigate through paragraphs by visual line instead of literal line
nnoremap j gj
nnoremap k gk

map <leader>y "*y
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
nnoremap <leader><leader> <c-^>
" Close all other windows, open a vertical split, and open this file's test
" alternate in it.
nnoremap <leader>s :call FocusOnFile()<cr>
function! FocusOnFile()
  tabnew %
  normal! v
  normal! l
  call OpenTestAlternate()
  normal! h
endfunction
" Reload in chrome
map <leader>l :w\|:silent !reload-chrome<cr>
" Align selected lines
vnoremap <leader>ib :!align<cr>

" map ,V to paste without having to switch indent modes
nnoremap <leader>V :r !pbpaste

" make leader be a comma
let mapleader=","

" css property sorting
nnoremap <leader>S ?{<CR>jV/^\s*\}?$<CR>k:sort<CR>:noh<CR>

" html tag folding
nnoremap <leader>ft Vatzf

" strip trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" reselect just-pasted text
nnoremap <leader>v V`]

" open .vimrc quickly in split window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>


" STATUS LINE
" ----------------------------------------------------------------------------------

:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)




" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
" ----------------------------------------------------------------------------------

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>






" CUSTOM AUTOCMDS
" ----------------------------------------------------------------------------------

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber,latex set ai sw=2 sts=2 et
  autocmd FileType python,c set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  " autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END




" PLUGINS
" ----------------------------------------------------------------------------------

" VIM-LATEX
" ------------------------------

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.

set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'





" CTRL-P
" ------------------------------
set runtimepath^=~/.vim/bundle/ctrlp.vim




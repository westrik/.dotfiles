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

set nobackup " backups are annoying
set writebackup " temp backup during write
set undodir=~/.vim/undo " persistent undo storage
set undofile " persistent undo on

set tabstop=4 
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab
set listchars=tab:↹·,extends:⇉,precedes:⇇,nbsp:␠,trail:␠,nbsp:␣
set showbreak=↳\ " shown at the start of a wrapped line

set background=dark
colorscheme solarized 

" disable beeping + visual flash
set noeb vb t_vb=

let g:airline_powerline_fonts = 1
set laststatus=2 "have airline open all the time
let g:bufferline_echo = 0 "don't show auto echoing from vim
set noshowmode
if !exists('g:airline_symbols')
      let g:airline_symbols = {}
  endif
  let g:airline_symbols.space = "\ua0"

set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85
set ruler " show the cursor position all the time
set cursorline " highlight current line
set smartcase
let c_space_errors = 1


set ttymouse=xterm2 " force mouse support for screen
set mouse=a " terminal mouse when possible

" -/= to navigate tabs
noremap - :tabprevious<CR>
noremap = :tabnext<CR>


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

" make leader comma 
let mapleader=","

" map <leader>V to paste without having to switch indent modes
nnoremap <leader>V :r !pbpaste<cr>

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
nnoremap <leader>egv <C-w><C-v><C-l>:e ~/.gvimrc<cr>

" Swaps selection with buffer
vnoremap <C-X> <Esc>`.``gvP``P

" Open new file with <leader>o
nnoremap <Leader>o :CtrlP<CR>

" <leader>v <leader>y to yank/put to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Easy compiling for mml files
autocmd FileType mml nnoremap <leader>m :MmlMake<cr>

nnoremap <leader><space> :nohlsearch<cr>


" STATUS LINE
" ----------------------------------------------------------------------------------

set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)


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


""" FocusMode
function! ToggleFocusMode()
  if (&foldcolumn != 12)
    set laststatus=0
    set numberwidth=10
    set foldcolumn=12
    set noruler
    hi FoldColumn ctermbg=none
    hi LineNr ctermfg=0 ctermbg=none
    hi NonText ctermfg=0
  else
    set laststatus=2
    set numberwidth=4
    set foldcolumn=0
    set ruler
    execute 'colorscheme ' . g:colors_name
  endif
endfunc
nnoremap <F1> :call ToggleFocusMode()<cr>




" CUSTOM AUTOCMDS
" ----------------------------------------------------------------------------------

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=80
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,scss,scala,css,cucumber,latex set ai sw=2 sts=2 et
  autocmd FileType python,c set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.md  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  " autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
  
augroup END

" Automatically refresh vimrc on save
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END



" Vim-LaTeX
" ----------------------------------
" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.

set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode $*'



" GUNDO
" ----------------------------------
noremap <leader>u :GundoToggle<CR>


" CTRL-P
" ------------------------------
set runtimepath^=~/.vim/bundle/ctrlp.vim

" MARKDOWN
let g:vim_markdown_folding_disabled=1

" Merlin 
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"



# load prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

plugins=(git)

bindkey -v
bindkey '^R' history-incremental-search-backward

# .localrc for secret stuff
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit



# ALIASES
# ---------------------------------------------------------------------

# GIT

alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"

# SYSTEM

if (( $+commands[grc] )) && (( $+commands[brew] ))
then
  source `brew --prefix`/etc/grc.bashrc
fi

if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi

up() {
  local op=print
  [[ -t 1 ]] && op=cd
  case "$1" in
    '') up 1;;
    -*|+*) $op ~$1;;
    <->) $op $(printf '../%.0s' {1..$1});;
    *) local -a seg; seg=(${(s:/:)PWD%/*})
       local n=${(j:/:)seg[1,(I)$1*]}
       if [[ -n $n ]]; then
         $op /$n
       else
         print -u2 up: could not find prefix $1 in $PWD
         return 1
       fi
  esac
}

zpass() {
  LC_ALL=C tr -dc '0-9A-Za-z_@#%*,.:?!~' < /dev/urandom | head -c${1:-20}
  echo
}

alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# MISCELLANEOUS
alias reload!='. ~/.zshrc'
alias sasquatch='sass --watch sass:compiled --style compact'
alias gitgo="git add * && git commit -a && git push origin master"
alias ssh-wagstaff='ssh root@192.241.162.151'
alias ssh-potter='ssh mwestrik@potter.socs.uoguelph.ca'

alias p='cd ~/Desktop/Projects/'
alias beg='bundle exec guard'
alias q='exit'
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'
alias combinepdf='gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=out.pdf'
alias weather='curl wttr.in'

alias vgo='source venv/bin/activate'
alias s='cd ~/OneDrive\ -\ mail.uoguelph.ca/School/W17'
alias eda='cd ~/OneDrive\ -\ mail.uoguelph.ca/eda'
alias 2rot13='echo'
alias dc='cd'
alias c='clear'
alias c='clear'
alias procrast='sudo vim /etc/hosts'
alias unprocrast='sudo vim /etc/hosts'

alias vim='/usr/local/Cellar/vim/7.4.922/bin/vim'
alias flush='dscacheutil -flushcache'
alias h="history | grep"

# PATH
export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:/usr/pkg/man:$MANPATH"

export PATH="./bin:$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:$HOME/.sfs:$ZSH/bin:$PATH"
#export PATH="/usr/local/gnat/bin:$PATH"
export PATH="$HOME:$HOME/bin:/usr/local/bin:$PATH"
export PATH="/usr/pkg/bin:/usr/pkg/sbin:$PATH"
export PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/go_appengine:$PATH"
export PATH="$HOME/virtualenvs:$PATH"

export PATH="$HOME/Projects/depot_tools:$PATH"

export PATH="/usr/local/smlnj/bin/:$PATH"


# pkgsrc 
export PATH="$PATH:$HOME/pkg/bin:$HOME/pkg/sbin"

# racket 
export PATH="$PATH:/Applications/Racket\ v6.1.1/bin"
export PATH="$PATH:/Library/TeX/texbin"

export PATH="$PATH:/$HOME/.local/bin"
export PATH="/Users/matt/anaconda/bin:$PATH"


export DYLD_FALLBACK_LIBRARY_PATH='/Users/matt/anaconda/lib'

export PYTHONPATH=/usr/local/Cellar/opencv/2.4.12_2/lib/python2.7/site-packages/


# OPAM configuration
. /Users/matt/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# stack config
export XDG_DATA_HOME="$HOME/.local/share"
export STACK_ROOT="$XDG_DATA_HOME/stack"

source /Users/matt/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

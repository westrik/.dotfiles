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
alias beg='bundle exec guard'
alias q='exit'
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'
alias combinepdf='gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=out.pdf'
alias flush='dscacheutil -flushcache'
alias h="history | grep"
alias dc='cd'
alias c='clear'

alias vim='nvim'

alias p="cd $HOME/Dropbox/Mat/projects/"

export PATH=$HOME/.local/bin:$PATH
export PATH="$HOME/anaconda3/bin:$PATH"
export PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH="/usr/local/cuda/bin:$PATH"

# OPAM configuration
. /Users/matt/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

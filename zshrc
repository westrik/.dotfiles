# GENERAL
# -----------------------------------------------------------------------

# load prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

plugins=(git)

bindkey -v
bindkey '^R' history-incremental-search-backward

# .localrc for secrets
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# don't save lines beginning in spaces in history
setopt histignorespace


# PATH SETUP
# -----------------------------------------------------------------------
export PATH=$HOME/.local/bin:$PATH


# ALIASES 
# -----------------------------------------------------------------------

# commands
alias vr='vim ~/.zshrc'
alias r!='. ~/.zshrc'
alias h="history | rg"
alias dc='cd'
alias q='exit'
alias c='clear'

# clobber utilities with preferred options
alias python="python3"
alias pip="pip3"
if $(nvim -v &>/dev/null); then
  alias vim='nvim'
fi
if $(rg &>/dev/null); then
  alias grep="rg"
fi
if $(exa &>/dev/null); then
  alias ls="exa"
  alias l="exa"
  alias ll="exa -l"
  alias lll="exa -la"
fi

# helpful tools
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'
alias combinepdf='(type combinepdf); gs -q -sPAPERSIZE=letter -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=out.pdf'
alias dnsflush='dscacheutil -flushcache'
alias dockspace="defaults write com.apple.dock persistent-apps -array-add '{\"tile-type\"=\"spacer-tile\";}'; killall Dock"
randp() {
  LC_ALL=C tr -dc '0-9A-Za-z_@#%*,.:?!~' < /dev/urandom | head -c${1:-20}
  echo
}

# folder jumping
alias n="cd $HOME/mwestrik-documents/Notes/"
alias p="cd $HOME/gh;set +m;{ghsync & } 2>/dev/null;set -m"

# git
alias gu!='(type gu!); git commit --all --amend --no-edit'
alias gl='git pull --prune'
alias glog="(type glog); git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gp!='(type gp!); git push -f origin HEAD'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias grm="(type grm); git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"

# cargo
alias cc='cargo check' # clobber llvm
alias cbr='cargo build --release'
alias cb='cargo build'
alias ct='cargo test'
alias cf='cargo fmt'
alias cpr='(type cpr); cargo test && cargo check && cargo fmt'

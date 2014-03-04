
# shortcut to this dotfiles path is $ZSH
export ZSH=$HOME/.oh-my-zsh
plugins=(git)
ZSH_THEME="gallois"
source $ZSH/oh-my-zsh.sh

bindkey -v

# your project folder that we can `c [tab]` to
export PROJECTS=~/projects

# .localrc for secret stuff
if [[ -a ~/.localrc ]]
then
  source ~/.localrc
fi

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit






# TODO: Look into using hub as a git wrapper...
# ---------------------------------------------
# hub_path=$(which hub)
# if (( $+commands[hub] ))
# then
#   alias git=$hub_path
# fi




#
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
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"


# RUBY

alias r='rbenv local 1.8.7-p358'

alias sc='script/console'
alias sg='script/generate'
alias sd='script/destroy'

alias migrate='rake db:migrate db:test:clone'

if [[ ! -o interactive ]]; then
    return
fi

compctl -K _rbenv rbenv

_rbenv() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(rbenv commands)"
  else
    completions="$(rbenv completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}


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

alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"



# MISCELLANEOUS
alias reload!='. ~/.zshrc'
alias sasquatch='sass --watch sass:compiled --style compact'
alias gitgo="git add * && git commit -a && git push origin master"
alias ssh-charmander='ssh ec2-user@54.213.96.38 -i ~/.ssh/mattw.pem' #good thing i used ssh keys huh otherwise you'd be stealin
alias ssh-clefairy='ssh root@162.243.43.222'

alias 2500='cd ~/Academic/CIS\ 2500/'
alias p='cd ~/Projects/'
alias 2c='cd ~/Academic/CIS\ 2500/coursework/'


# PATH
export GOPATH=$HOME/go
export NODE_PATH=`pwd`/Shared/:`pwd`/Node/:`pwd`/Node/shell/:`pwd`/Node/view/

export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:/usr/pkg/man:$MANPATH"

export PATH="./bin:$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:$HOME/.sfs:$ZSH/bin:$PATH"
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/pkg/bin:/usr/pkg/sbin:$PATH"
export PATH="$HOME/Library/Haskell/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH=$GOPATH/bin:$PATH


[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # This loads NVM

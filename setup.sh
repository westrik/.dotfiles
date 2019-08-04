#!/bin/bash

DIR=$HOME/.dotfiles

if ! command -v brew >/dev/null 2>&1; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! command -v cargo >/dev/null 2>&1; then
  curl https://sh.rustup.rs -sSf | sh
fi

brew install neovim tmux python@2 python3

pip3 install --user --upgrade pip setuptools wheel neovim
pip install --user --upgrade neovim

scripts_folder=$HOME/.local/bin
mkdir -p $scripts_folder

# Install script that syncs all GitHub repos to a local folder (set GITHUB_API_TOKEN in ~/.localrc)
rm -f $scripts_folder/ghsync
curl https://gist.githubusercontent.com/westrik/2048a98582de72dae0fcee69166a94ee/raw/ > $scripts_folder/ghsync
chmod +x $scripts_folder/ghsync

ln -s $DIR/tmux.conf $HOME/.tmux.conf
ln -s $DIR/zshrc $HOME/.zshrc
rm -rf $HOME/.zprezto
ln -s $DIR/zprezto $HOME/.zprezto
ln -s $DIR/zpreztorc $HOME/.zpreztorc
ln -s $DIR/gitconfig $HOME/.gitconfig
ln -s $DIR/gitignore_global $HOME/.gitignore_global
ln -s $DIR/init.vim $HOME/.config/nvim/init.vim

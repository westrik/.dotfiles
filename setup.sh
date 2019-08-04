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


ln -s $DIR/tmux.conf ~/.tmux.conf
ln -s $DIR/zshrc ~/.zshrc
ln -s $DIR/zprezto ~/.zprezto
ln -s $DIR/zpreztorc ~/.zpreztorc
ln -s $DIR/gitconfig ~/.gitconfig
ln -s $DIR/gitignore_global ~/.gitignore_global
ln -s $DIR/init.vim ~/.config/nvim/init.vim

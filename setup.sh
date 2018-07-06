
#!/bin/bash

if ! command -v brew >/dev/null 2>&1; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install neovim tmux python@2 python3

pip3 install --user --upgrade pip setuptools wheel neovim
pip install --user --upgrade neovim

dir=~/.dotfiles

ln -s $dir/tmux.conf ~/.tmux.conf
ln -s $dir/zshrc ~/.zshrc
ln -s $dir/zprezto ~/.zprezto
ln -s $dir/zpreztorc ~/.zpreztorc
ln -s $dir/gitconfig ~/.gitconfig
ln -s $dir/gitignore_global ~/.gitignore_global
ln -s $dir/init.vim ~/.config/nvim/init.vim

#!/bin/bash

DIR=$HOME/.dotfiles

link_dir() {
	if [[ -d $HOME/$2 ]]; then
		echo "~/$2 exists"
	else
		ln -s $DIR/$1 $HOME/$2
	fi
}

link_file() {
	if [[ -a $HOME/$2 ]]; then
		echo "~/$2 exists"
	else
		ln -s $DIR/$1 $HOME/$2
	fi
}

#-------

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

link_file tmux.conf .tmux.conf
link_file zshrc .zshrc
link_file gitconfig .gitconfig
link_file gitignore_global .gitignore_global
mkdir -p $HOME/.config/nvim/
link_file init.vim .config/nvim/init.vim
link_file zpreztorc .zpreztorc
link_dir zprezto .zprezto

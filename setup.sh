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

# Homebrew (macOS)
if ! command -v brew >/dev/null 2>&1; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Rust toolchain
if ! command -v cargo >/dev/null 2>&1; then
	curl https://sh.rustup.rs -sSf | sh
fi

# Dev tools and helpers
brew install neovim tmux python@2 python3 terminal-notifier
# Hashicorp stack
brew install terraform packer consul

pip3 install --user --upgrade pip setuptools wheel neovim
pip install --user --upgrade neovim

scripts_bin=$HOME/.local/bin
mkdir -p $scripts_bin

# Install script that syncs all GitHub repos to a local folder (remember to set GITHUB_API_TOKEN in ~/.localrc)
rm -f $scripts_bin/ghsync
ln -s "$DIR/jobs/github_sync.sh" $scripts_bin/ghsync
chmod +x $scripts_bin/ghsync

# Install Backblaze B2 encrypt/upload and download/decrypt scripts.
rm -f $scripts_bin/b2encrypt
ln -s "$DIR/vendor/b2encrypt.sh" $scripts_bin/b2encrypt
chmod +x $scripts_bin/b2encrypt
rm -f $scripts_bin/b2decrypt
ln -s "$DIR/vendor/b2decrypt.sh" $scripts_bin/b2decrypt
chmod +x $scripts_bin/b2decrypt

link_file tmux.conf .tmux.conf
link_file zshrc .zshrc
link_file gitconfig .gitconfig
link_file gitignore_global .gitignore_global
mkdir -p $HOME/.config/nvim/
link_file init.vim .config/nvim/init.vim
link_file zpreztorc .zpreztorc
link_dir zprezto .zprezto

bash "$DIR/jobs/set_up_recurring_jobs.sh"

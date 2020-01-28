#!/usr/bin/env bash

set -euo pipefail

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# GUI tools
brew install cask
brew cask install firefox
brew cask install telegram
brew cask install spectacle
brew cask install alfred
brew cask install --force istat-menus
brew cask install iterm2
brew cask install clion
brew cask install skim
brew cask install 1password-cli
brew cask install --force spotify
brew cask install vlc
brew cask install transmit
brew cask install omnigraffle
brew cask install sketch

# Dev tools and helpers
brew install \
	neovim \
	tmux \
	python3 \
	terminal-notifier \
	jq \
	ripgrep

# Hashicorp stack
brew install terraform packer consul

brew install yarn

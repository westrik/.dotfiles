#!/usr/bin/env bash

set -euo pipefail

# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# GUI tools
brew install cask
brew cask install firefox
brew cask install spectacle
brew cask install spotify
brew cask install alfred
brew cask install istat-menus
brew cask install transmit
brew cask install omnigraffle
brew cask install vlc
brew cask install skim

# Dev tools and helpers
brew install neovim tmux python3 terminal-notifier

# Hashicorp stack
brew install terraform packer consul

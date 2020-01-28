#!/usr/bin/env bash

set -euo pipefail

# generate SSH key and copy public key to clipboard
read -p "generate an SSH key? (y/n): " should_gen_key
if [ $should_gen_key = "y" ]; then
	read -p "what's your email: " email

	echo "generating an ed25519 key..."
	ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "$email"

	eval "$(ssh-agent -s)"

	echo "your new public key: "
	cat ~/.ssh/id_ed25519.pub
fi

# TODO: ask for a GitHub API token and save it to ~/.localrc

# macOS defaults configuration

read -p "change hostname? (y/n): " should_change_hostname
if [ $should_change_hostname = "y" ]; then
	read -p "new hostname: " hostname

	scutil --set ComputerName "$hostname"
	scutil --set HostName "$hostname"
	scutil --set LocalHostName "$hostname"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
fi

echo "change Cocoa window resize time to 0.001s"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "expand save / print panels by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "don't prompt when running applications from the Internet"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "enable full keyboard access for all UI controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "require password immediately after sleep / screensaver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "show external drives on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

echo "save files locally by default (not to iCloud)"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "show all extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "show the status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

echo "show the path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

echo "display full paths in Finder title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "allow selection in Quick Look windows"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "don't warn when changing extensions"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "don't create .DS_Store on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true

echo "show ~/Library"
chflags nohidden ~/Library

read -p "clear default tiles from Dock? (y/n): " should_clear_dock
if [ $should_clear_dock = "y" ]; then
	echo "clearing Dock"
	defaults write com.apple.dock persistent-apps -array
fi

echo "make Dock auto-hide immediately"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

echo "use 36px tiles in Dock"
defaults write com.apple.dock tilesize -int 36

echo "put Dock on the right"
defaults write com.apple.dock orientation right

echo "minimize windows with 'Scale effect'"
defaults write com.apple.dock mineffect scale

echo "don't show recent apps in Dock"
defaults write com.apple.dock show-recents 0

echo "restarting Dock"
killall Dock

echo "restarting Finder"
killall Finder

echo "restarting SystemUIServer"
killall SystemUIServer

echo "installing homebrew"
if ! command -v brew >/dev/null 2>&1; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew install cask

echo "installing Mac apps"
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

echo "installing CLI tools"
brew install neovim
brew install tmux
brew install ripgrep
brew install jq
brew install terminal-notifier
brew install python3
brew install terraform
brew install packer
brew install consul
brew install yarn

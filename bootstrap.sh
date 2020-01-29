#!/usr/bin/env bash

set -euo pipefail

SECRETS_FILE="$HOME/.localrc"
DOTFILES_FOLDER="$HOME/.dotfiles"
EMAIL_ADDRESS="m@ttwestrik.com"
GITHUB_USERNAME="westrik"

sudo -v
# keep-alive: update existing `sudo` time stamp until script is done
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ ! -f "$SECRETS_FILE" ]; then
	read -p "enter a GitHub personal access token: " github_token
	echo "export GITHUB_API_TOKEN=\"$github_token\"" > "$SECRETS_FILE"
fi
source "$SECRETS_FILE"

read -p "generate an SSH key? (y/n): " should_gen_key
if [ $should_gen_key = "y" ]; then
	echo "generating an ed25519 key..."
	ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "$EMAIL_ADDRESS"

	eval "$(ssh-agent -s)"

	pub_key=$(cat ~/.ssh/id_ed25519.pub)

	# note: personal access token needs at least `write:public_key`
	echo "uploading public key to GitHub..."
	read -p "what should the key be called?: " key_name
	curl -u "$GITHUB_USERNAME:$GITHUB_API_TOKEN" --data "{\"title\":\"$key_name\",\"key\":\"$pub_key\"}" https://api.github.com/user/keys
fi

# macOS defaults configuration
read -p "change hostname? (y/n): " should_change_hostname
if [ $should_change_hostname = "y" ]; then
	read -p "new hostname: " hostname

	sudo scutil --set ComputerName "$hostname"
	sudo scutil --set HostName "$hostname"
	sudo scutil --set LocalHostName "$hostname"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
fi

read -p "install homebrew deps? (y/n) " should_install
if [ $should_install = "y" ]; then
	echo "installing Homebrew"
	if ! command -v brew >/dev/null 2>&1; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
	brew install cask

	echo "installing Mac apps"
	brew cask install firefox
	brew cask install telegram
	brew cask install spectacle
	brew cask install alfred
	brew cask install iterm2
	brew cask install clion
	brew cask install skim
	brew cask install 1password-cli
	brew cask install vlc
	brew cask install transmit
	brew cask install omnigraffle
	brew cask install sketch
	brew cask install --force istat-menus
	brew cask install --force spotify

	echo "installing CLI tools"
	brew install neovim
	brew install tmux
	brew install ripgrep
	brew install jq
	brew install terminal-notifier
	brew install python3
	brew install yarn
	brew install nginx
	brew install postgres
	brew install terraform
	brew install packer
	brew install consul
fi

read -p "reset Dock to custom defaults? (y/n): " should_clear_dock
if [ $should_clear_dock = "y" ]; then
	defaults write com.apple.dock persistent-apps -array

	for app in Firefox Telegram CLion iTerm Spotify Sketch OmniGraffle; do
		defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$app.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
	done
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

echo "always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "disable press-and-hold (enable key repeat)"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "make key repeat really fast"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

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

echo "restarting Dock"
killall Dock

echo "restarting Finder"
killall Finder

echo "restarting SystemUIServer"
killall SystemUIServer

if [ ! -d "$DOTFILES_FOLDER" ]; then
	echo "installing dotfiles"
	cd $HOME
	git clone --recurse-submodules -j8 git@github.com:westrik/.dotfiles.git
	bash .dotfiles/setup.sh
fi
echo "syncing all GitHub repos"
ghsync

# set up services
echo "configure /etc/hosts"
if ! grep -q 'westrik' /etc/hosts; then
	echo "127.0.0.1 westrik.world" | sudo tee -a /etc/hosts >/dev/null
	echo "127.0.0.1 api.westrik.world" | sudo tee -a /etc/hosts >/dev/null
fi


echo "copy nginx.conf to /usr/local/etc/nginx/"
sudo cp "$DOTFILES_FOLDER/configs/nginx.conf" "/usr/local/etc/nginx/nginx.conf"

echo "starting nginx"
sudo mkdir -p /Library/Logs/nginx/
sudo brew services restart nginx

echo "starting postgres"
brew services restart postgresql

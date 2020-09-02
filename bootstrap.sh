#!/usr/bin/env bash

set -euo pipefail

SECRETS_FILE="$HOME/.localrc"
DOTFILES_FOLDER="$HOME/.dotfiles"

sudo -v
# keep-alive: update existing `sudo` time stamp until script is done
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo ""
read -p "change hostname? (y/n): " should_change_hostname
if [ $should_change_hostname = "y" ]; then
    read -p "new hostname: " hostname

    sudo scutil --set ComputerName "$hostname"
    sudo scutil --set HostName "$hostname"
    sudo scutil --set LocalHostName "$hostname"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
fi

echo ""
read -p "install homebrew deps? (y/n) " should_install
if [ $should_install = "y" ]; then
    if ! command -v brew >/dev/null 2>&1; then
        echo ""
        echo "installing Homebrew"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    echo ""
    echo "installing homebrew cask"
    brew install cask

    echo ""
    echo "installing Mac apps"
    brew cask install \
        alfred \
        chromium \
        clion \
        firefox \
        insomnia \
        iterm2 \
        netnewswire \
        omnigraffle \
        sketch \
        skim \
        spectacle \
        telegram \
        transmit \
        mpv
        # not installed right now: keepassxc
    brew cask install --force \
        istat-menus \
        spotify

    echo ""
    echo "installing CLI tools"
    brew install \
        bandwhich \
        dust \
        exa \
        fzf \
        grex \
        hyperfine \
        jq \
        neovim \
        procs \
        ripgrep \
        terminal-notifier \
        tmux

    echo ""
    echo "configuring homebrew taps"
    brew tap aws/tap

    echo ""
    echo "installing devenv tools"
    brew install \
        ansible \
        aws-sam-cli \
        awscli \
        binaryen \
        cmake \
        fd \
        flatbuffers \
        git \
        gnuplot \
        graphviz \
        openssl@1.1 \
        packer \
        pyenv \
        python3 \
        terraform \
        tokei \
        webp \
        yarn
        # not installed for now: llvm, swiftlint

    echo ""
    echo "installing devenv services"
    brew install \
        consul \
        dnsmasq \
        minio/stable/minio \
        nginx

    echo ""
    echo "installing databases"
    brew install \
        mysql \
        postgres \
        sqlite

    echo ""
    echo "installing security-related software"
    brew install \
        gnupg \
        hopenpgp-tools \
        pinentry-mac \
        ykman \
        yubikey-personalization

    echo ""
    echo "installing other software"
    brew install \
        borgbackup \
        youtube-dl
fi

echo ""
read -p "configure YubiKey for GPG? (y/n) " should_setup_yubikey
if [ $should_setup_yubikey = "y" ]; then
    read -p "press enter when YubiKey is plugged in"

    echo ""
    read -p "enter GPG key ID: " KEYID

    echo "fetching public key for $KEYID..."
    gpg --keyserver hkp://keys.gnupg.net:80 --recv $KEYID

    echo ""
    echo "------------------------------------------------------"
    echo "editing imported key..."
    echo "- run 'trust' & select '5' to ultimately trust the key"
    echo "- run 'quit' to exit"
    echo "------------------------------------------------------"
    echo ""
    gpg --edit-key $KEYID

    echo ""
    echo "installing temporary gpg and gpg-agent configs"
    curl -so $HOME/.gnupg/gpg.conf https://raw.githubusercontent.com/westrik/.dotfiles/master/gpg.conf
    curl -so $HOME/.gnupg/gpg-agent.conf https://raw.githubusercontent.com/westrik/.dotfiles/master/gpg-agent.conf
fi

echo ""
read -p "reset Dock to custom defaults? (y/n): " should_clear_dock
if [ $should_clear_dock = "y" ]; then
    echo ""
    echo "clearing Dock"
    defaults write com.apple.dock persistent-apps -array

    echo ""
    for app in Safari Firefox Telegram iTerm CLion Insomnia Spotify Sketch OmniGraffle NetNewsWire; do
        echo "adding $app to Dock"
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$app.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    done
fi

echo ""
echo "configuring macOS defaults:"
echo ""

echo "- make Dock auto-hide immediately"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

echo "- use 36px tiles in Dock"
defaults write com.apple.dock tilesize -int 36

echo "- put Dock on the right"
defaults write com.apple.dock orientation right

echo "- minimize windows with 'Scale effect'"
defaults write com.apple.dock mineffect scale

echo "- don't show recent apps in Dock"
defaults write com.apple.dock show-recents 0

echo "- always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "- disable press-and-hold (enable key repeat)"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

echo "- make key repeat really fast"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

echo "- change Cocoa window resize time to 0.001s"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "- expand save / print panels by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "- don't prompt when running applications from the Internet"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "- enable full keyboard access for all UI controls"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "- require password immediately after sleep / screensaver"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "- show external drives on the desktop"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

echo "- save files locally by default (not to iCloud)"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "- show all extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "- show the status bar in Finder"
defaults write com.apple.finder ShowStatusBar -bool true

echo "- show the path bar in Finder"
defaults write com.apple.finder ShowPathbar -bool true

echo "- display full paths in Finder title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "- allow selection in Quick Look windows"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "- don't warn when changing extensions"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "- don't create .DS_Store on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "- make Trash empty securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true

echo "- show ~/Library in Finder"
chflags nohidden ~/Library

echo ""
echo "restarting Dock"
killall Dock

echo ""
echo "restarting Finder"
killall Finder

echo ""
echo "restarting SystemUIServer"
killall SystemUIServer


echo ""
echo "setting up gpg and gpg-agent in current shell"
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye > /dev/null
gpgconf --launch gpg-agent

if [ ! -d "$DOTFILES_FOLDER" ]; then
    echo ""
    echo "installing dotfiles"
    cd $HOME
    git clone --recurse-submodules -j8 git@github.com:westrik/.dotfiles.git

    # if gpg.conf or gpg-agent.conf exist and are not symlinks, delete them
    if [ ! -L "$HOME/.gnupg/gpg.conf" ]; then
        echo "deleting temporary gpg.conf"
        rm -f $HOME/.gnupg/gpg.conf
    fi
    if [ ! -L "$HOME/.gnupg/gpg-agent.conf" ]; then
        echo "deleting temporary gpg-agent.conf"
        rm -f $HOME/.gnupg/gpg-agent.conf
    fi

    bash .dotfiles/setup.sh
fi

echo ""
echo "syncing all GitHub repos"
if [ ! -f "$SECRETS_FILE" ]; then
    read -p "enter a GitHub personal access token: " github_token
    echo "export GITHUB_API_TOKEN=\"$github_token\"" > "$SECRETS_FILE"
fi
source "$SECRETS_FILE"
$HOME/.local/bin/ghsync

echo ""
echo "copying nginx.conf to /usr/local/etc/nginx/"
sudo cp "$DOTFILES_FOLDER/configs/nginx.conf" "/usr/local/etc/nginx/nginx.conf"

echo ""
echo "Remember to copy over nginx config files for services, then restart nginx"

# echo ""
# echo "(re)starting nginx"
# sudo mkdir -p /Library/Logs/nginx/
# sudo brew services restart nginx

echo ""
echo "(re)starting postgres"
brew services restart postgresql

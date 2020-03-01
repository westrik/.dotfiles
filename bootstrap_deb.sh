#!/usr/bin/env bash

set -euo pipefail

SECRETS_FILE="$HOME/.localrc"
DOTFILES_FOLDER="$HOME/.dotfiles"

sudo -v
# keep-alive: update existing `sudo` time stamp until script is done
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# brew cask install firefox
# brew cask install telegram
# brew cask install spectacle
# brew cask install alfred
# brew cask install iterm2
# brew cask install clion
# brew cask install skim
# brew cask install keepassxc
# brew cask install vlc
# brew cask install transmit
# brew cask install omnigraffle
# brew cask install sketch
# brew cask install --force istat-menus
# brew cask install --force spotify

# echo "installing CLI tools"
# brew install neovim
# brew install tmux
# brew install ripgrep
# brew install fzf
# brew install jq
# brew install terminal-notifier

# echo ""
# echo "installing devenv tooling"
# brew install python3
# brew install yarn
# brew install nginx
# brew install postgres
# brew install terraform
# brew install packer
# brew install consul
# brew install gnuplot

# echo ""
# echo "installing security-related software"
# brew install gnupg
# brew install yubikey-personalization
# brew install hopenpgp-tools
# brew install ykman
# fi

echo ""
read -p "configure YubiKey for GPG? (y/n) " should_setup_yubikey
if [ $should_setup_yubikey = "y" ]; then
	read -p "press enter when YubiKey is plugged in"

	echo ""
	read -p "enter GPG key ID: " KEYID

	echo "fetching public key for $KEYID..."
	gpg --recv $KEYID

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

# set up services
echo ""
echo "adding local sites to /etc/hosts"
if ! grep -q 'westrik' /etc/hosts; then
	echo "127.0.0.1 westrik.world" | sudo tee -a /etc/hosts >/dev/null
	echo "127.0.0.1 api.westrik.world" | sudo tee -a /etc/hosts >/dev/null
fi


#echo ""
#echo "copying nginx.conf to /usr/local/etc/nginx/"
#sudo cp "$DOTFILES_FOLDER/configs/nginx.conf" "/usr/local/etc/nginx/nginx.conf"

#echo ""
#echo "(re)starting nginx"
#sudo mkdir -p /Library/Logs/nginx/
#sudo brew services restart nginx

#echo ""
#echo "(re)starting postgres"
#brew services restart postgresql

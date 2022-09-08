#!/bin/bash

# Credit for a lot of this goes to https://www.lotharschulz.info/2021/05/11/macos-setup-automation-with-homebrew/

{
# unofficial bash strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

# Install XCode
if ! which xcode-select >/dev/null; then
    xcode-select --install
else
    echo "Xcode-Select already installed. Moving on..."
fi

# Install Homebrew
if ! which brew >/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    source ~/.zprofile
else
    echo "Homebrew already installed. Updating..."
    brew update
fi

rm -rf "$(brew --repo homebrew/core)"
brew tap homebrew/core

PACKAGES=(
    gettext
    zsh
)
echo "Installing packages..."
brew install "${PACKAGES[@]}"

CASKS=(
    firefox
    google-chrome
    iterm2
    slack
    visual-studio-code
    zoom
)

echo "Installing cask apps (Firefox, Google Chrome, iTerm2, Slack, Visual Studio Code, Zoom)..."

if brew ls --versions "${CASKS[@]}"; then 
    brew upgrade "${CASKS[@]}"; 
else
    sudo -u "$(whoami)" brew install --cask "${CASKS[@]}"
fi

cd ~/
git clone https://github.com/nvm-sh/nvm.git .nvm
. ./nvm.sh

cat <<EOF >> ~/.zshrc
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF

source /.zshrc

nvm install 14 # CURRENT NODE VERSION 14 SUPPORTED BY SHSP

# Rancher Desktop
## Download
curl -O ~/Downloads/RancherDesktop.dmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.4.1/Rancher.Desktop-1.4.1.aarch64.dmg
## Mount the .dmg image
sudo hdiutil attach ~/Downloads/RancherDesktop.dmg
## Install the application
cp -R /Volumes/RancherDesktop/RancherDesktop.app /Applications
diskutil unmount /Volumes/RancherDesktop
open /Applications/RancherDesktop.app
}
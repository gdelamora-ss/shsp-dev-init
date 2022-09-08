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
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
    source ~/.zshrc
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

APPS=(
    'Firefox.app'
    'Google Chrome.app'
    'iTerm.app'
    'Visual Studio Code.app'
    'Zoom.app'
)

CASKS=(
    firefox
    google-chrome
    iterm2
    visual-studio-code
    zoom
)

echo "Installing cask apps (Firefox, Google Chrome, iTerm2, Visual Studio Code, Zoom)..."

if brew ls --versions "${CASKS[@]}" || mdfind -name "${APPS[@]}"; then 
    brew upgrade "${CASKS[@]}"; 
else
    sudo -u "$(whoami)" brew install --cask "${CASKS[@]}"
fi

if ! which nvm >/dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    source ~/.zshrc
fi

nvm install 14 # CURRENT NODE VERSION 14 SUPPORTED BY SHSP

if ! mdfind -name 'Slack.app'; then
    brew install --cask 'slack' # for some reason won't install like the others above
fi

# Rancher Desktop
if ! mdfind -name 'Rancher Desktop.app'; then
    ## Download
    curl -O ~/Downloads/RancherDesktop.dmg https://github.com/rancher-sandbox/rancher-desktop/releases/download/v1.4.1/Rancher.Desktop-1.4.1.aarch64.dmg
    ## Mount the .dmg image
    sudo hdiutil attach ~/Downloads/RancherDesktop.dmg
    ## Install the application
    cp -R /Volumes/RancherDesktop/RancherDesktop.app /Applications
    diskutil unmount /Volumes/RancherDesktop
    open /Applications/RancherDesktop.app
else
    echo "Rancher Desktop already installed. Continuing..."
fi
}
#!/bin/bash

# Note: may need to run:$ chmod u+x ~/.my_configs/mac_setup.sh if execution is blocked

# -------- Script aliases and functions --------

# color aliases
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
LIGHT_PURPLE='\033[0;35m'

# prints the passed string in green font
function inf() {
  echo -e "${GREEN}$1${NC}"
}

# prints [ERR] and the passed string in red font
function err() {
  echo -e "${RED}[ERR] $1${NC}"
  exit
}

# prompts the user with the passed string and waits for input (continue or terminate)
function prompt() {
  echo -ne "${GREEN}$1[Press enter to continue, ^C to terminate]${NC} "
  read -r
}

# -------- Basic shell setup, symlinks, etc. --------


# add symlinks for common configs
ln -sf ~/.my_configs/vim/.vimrc ~/.vimrc
ln -sf ~/.my_configs/bash/.bash_profile ~/.bash_profile

# Configure github with user info
git config --global user.name "Alessandro Iyra"
git config --global user.email al.iyra.co@gmail.com

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ] 
then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ln -sf ~/.my_configs/zsh/.zshrc ~/.zshrc
    ln -sf ~/.my_configs/zsh/.zshenv ~/.zshenv
    # Add symlink for my custom oh-my-zsh theme in .my_configs
    ln -sf ~/.my_configs/zsh/oh-my-zsh/themes/solarize-git.zsh-theme ~/.oh-my-zsh/themes/solarize-git.zsh-theme
fi

# Install homebrew
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    brew update
fi
# Homebrew installs
brew install zsh-completion


# Set Vim as default git text-editor
git config --global core.editor "vim"
# automatically prune stale local branches
git config --global fetch.prune true

if [ ! -d "$HOME/workspace/repos" ]
then
    mkdir ~/workspace/; cd ~/workspace/; mkdir repos; cd -
fi

# Add fuzzy-search cmd-line tool
if [ ! -d "$HOME/.fzf/" ]
then
    cd ~/workspace/repos/
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

# Add solarized color-theme
if [ ! -d "$HOME/workspace/repos/solarized" ]
then
    cd ~/workspace/repos/
    git clone git@github.com:altercation/solarized.git
fi

# -------- Litra Glow auto-toggle setup --------
# Installs the `litra` CLI and registers a LaunchAgent that automatically
# turns the Logitech Litra Glow on/off when the webcam is activated in Firefox.
# The watcher script is expected to already exist at ~/.my_configs/scripts/litra-watch.sh

inf "Setting up Litra Glow auto-toggle..."

# Install litra CLI (used by litra-watch.sh to toggle the light)
brew install litra

PLIST_PATH="$HOME/Library/LaunchAgents/com.user.litra-watch.plist"
SCRIPT_PATH="$HOME/.my_configs/scripts/litra-watch.sh"

# Ensure the watcher script is executable
chmod +x "$SCRIPT_PATH"

# Unload any existing version of the agent before (re)installing
if launchctl list | grep -q "com.user.litra-watch"; then
    launchctl unload "$PLIST_PATH" 2>/dev/null
fi

# Write the LaunchAgent plist, hardcoding the known Homebrew path for litra
# (brew --prefix is not available in the LaunchAgent's restricted environment)
cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.user.litra-watch</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${SCRIPT_PATH}</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/litra-watch.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/litra-watch-error.log</string>
</dict>
</plist>
EOF

launchctl load "$PLIST_PATH"

if launchctl list | grep -q "com.user.litra-watch"; then
    inf "Litra Glow auto-toggle installed and running."
else
    err "Litra Glow LaunchAgent failed to start. Check /tmp/litra-watch-error.log"
fi

# TODO: Install Sublime via command line
#   Add sublime command "subl" to the $PATH variable (TODO: choose right application path and $PATH variable dirctory to make link)
#   sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

# TODO: Add solarized theme install

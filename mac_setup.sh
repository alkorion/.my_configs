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

# Configure git user info only if unset, so re-runs don't clobber a work identity
git config --global user.name >/dev/null || git config --global user.name "Alessandro Iyra"
git config --global user.email >/dev/null || git config --global user.email al.iyra.co@gmail.com

# Install Oh My Zsh (RUNZSH=no: don't drop into a new shell mid-script; KEEP_ZSHRC: don't replace ~/.zshrc)
if [ ! -d "$HOME/.oh-my-zsh" ]
then
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
ln -sf ~/.my_configs/zsh/.zshrc ~/.zshrc
ln -sf ~/.my_configs/zsh/.zshenv ~/.zshenv
if [ -d "$HOME/.oh-my-zsh/themes" ]
then
    ln -sf ~/.my_configs/zsh/oh-my-zsh/themes/solarize-git.zsh-theme ~/.oh-my-zsh/themes/solarize-git.zsh-theme
fi

# Install homebrew
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon installs to /opt/homebrew, which isn't on PATH until a new shell
    [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
else
    brew update
fi
# Homebrew installs
brew install zsh-completion

# Install WezTerm (cross-platform terminal with OSC 8 clickable URLs)
if ! brew list --cask wezterm &>/dev/null; then
    brew install --cask wezterm
fi
mkdir -p ~/.config/wezterm
ln -sf ~/.my_configs/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua


# Set Vim as default git text-editor
git config --global core.editor "vim"
# automatically prune stale local branches
git config --global fetch.prune true

mkdir -p ~/workspace/repos

# Add fuzzy-search cmd-line tool (install step re-runs if a previous run cloned but didn't finish)
[ -d "$HOME/.fzf" ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
[ -f "$HOME/.fzf.zsh" ] || ~/.fzf/install

# Add solarized color-theme
[ -d "$HOME/workspace/repos/solarized" ] || git clone git@github.com:altercation/solarized.git ~/workspace/repos/solarized

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

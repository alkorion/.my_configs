#!/bin/bash

# Note: may need to run:$ chmod u+x ~/.my_configs/ubuntu_setup.sh if execution is blocked

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
function inf() {
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
ln -sf ~/.my_configs/bash/.bashrc ~/.bashrc
ln -sf ~/.my_configs/tmux/.tmux.conf ~/.tmux.conf


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

# Install WezTerm (cross-platform terminal with OSC 8 clickable URLs).
# The apt.fury.io/wez repo only carries the LATEST build, which requires
# glibc >= 2.35 / libssl3 (Ubuntu 22.04+). On older releases (e.g. 20.04
# focal, glibc 2.31) those deps are unsatisfiable, so guard on the Ubuntu
# version and skip with a clear message rather than leaving apt in a
# "held broken packages" state.
if ! command -v wezterm &>/dev/null; then
    ubuntu_ver="$(. /etc/os-release 2>/dev/null; echo "${VERSION_ID:-0}")"
    if [ "$(printf '%s\n%s\n' "22.04" "$ubuntu_ver" | sort -V | head -n1)" = "22.04" ]; then
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo apt-get update
        sudo apt-get install -y wezterm
    else
        echo "[skip] WezTerm apt package needs Ubuntu >= 22.04 (glibc >= 2.35 / libssl3);"
        echo "       this is Ubuntu ${ubuntu_ver}. Install the official Ubuntu20.04 .deb"
        echo "       manually from https://github.com/wez/wezterm/releases if you want it."
    fi
fi
mkdir -p ~/.config/wezterm
ln -sf ~/.my_configs/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua

# TODO: Install Sublime via command line
#   Add sublime command "subl" to the $PATH variable (TODO: choose right application path and $PATH variable dirctory to make link)
#   sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

# TODO: Add solarized theme install

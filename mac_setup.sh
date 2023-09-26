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
ln -sf ~/.my_configs/bash/.bash_profile ~/.bash_profile


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
	git clone git://github.com/altercation/solarized.git
fi

# TODO: Install Sublime via command line
#   Add sublime command "subl" to the $PATH variable (TODO: choose right application path and $PATH variable dirctory to make link)
#   sudo ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl

# TODO: Add solarized theme install

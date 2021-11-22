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

# -------- Basic shell setup and symlinks --------


# add symlinks for common configs
ln -sf ~/.my_configs/vim/.vimrc ~/.vimrc
ln -sf ~/.my_configs/bash/.bash_profile ~/.bash_profile


# Install Oh My Zsh & power-line fonts
if [ ! -d "$HOME/.oh-my-zsh" ] 
then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ln -sf ~/.my_configs/zsh/.zshrc ~/.zshrc
    ln -sf ~/.my_configs/zsh/.zshenv ~/.zshenv

fi


# TODO: install homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


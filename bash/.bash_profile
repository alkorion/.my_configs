# Alessandro Lira's BASH Profile
# ------------------------------

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH


# Al here, hoping to change some colors!
#export CLICOLOR=1
#export LSCOLORS=ExFxBxDxCxegedabagacad


# Al here: the following three blocks were added by Udacity’s git script and modified by me
# Enable tab completion
source ~/.my_configs/git/git-completion.bash
# custom colors!
green="\[\033[01;32m\]"
blue="\[\033[01;34m\]"
purple="\[\033[01;35m\]"
red="\[\033[01;31m\]"
reset="\[\033[00m\]"

# Change command prompt to dynamically match git status
source ~/.my_configs/git/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\h' add the hostname of the system
# '\w' adds the name of the current directory
# '\$(__git_ps1)' adds git-related stuff

# Use different settings depending on host OS (Mac='Darwin', Linux=' Linux')
if [[ $(uname -s) == "Linux" ]]
then # Ubuntu
    export PS1="$green\u$reset@$purple\h$reset:$blue\w$red\$(__git_ps1)$reset\$ "

    # set auto color mode for ls command
    alias ls='ls --color=auto'

    # Cruise specific setting (move these check automatically someday?)

    # Have .bash_profile source .bashrc for new tmux sessions
    . ~/.bashrc

    # Point bash_profile towards cruise_configs
    source ~/.cruise_configs/.cruise_rc
else # MacOS
    blue="\[\033[0;34m\]"
    export PS1="$green\u$reset: $blue\w$red\$(__git_ps1)$reset\$ "
    # source login aliases
    source ~/.my_configs/aliases/.al_aliases

    # Al here, just manually adding in new color functionality for 'ls'
    alias ls='ls -G'

    # Point bash_profile towards cruise_configs
    source ~/.cruise_configs/.cruise_rc
fi

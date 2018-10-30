# Alessandro Lira's BASH Profile
# ------------------------------

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# MacPorts Installer addition on 2016-01-25_at_17:25:43: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# Al here, just manually adding in new color functionality for 'ls'
alias ls='ls -GF'

# source login aliases depending on host OS (Mac='Darwin', Linux=' inux')
if [[ $(uname -s) == 'Linux' ]]
then
    :
else
    source ~/.my_configs/aliases/.al_aliases
fi

# Al again, this time hoping to change some colors
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
export PS1="$green\u$reset@$purple\h$reset:$blue\w$red\$(__git_ps1)$reset\$ "

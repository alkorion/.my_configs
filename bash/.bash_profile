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

# source login aliases depending on host OS (Mac='Darwin', Linux='Linux')
if [[ $(uname -s) == Linux ]]
then
    :
else
    source ~/my_configs/aliases/.al_aliases
fi

# Al again, this time hoping to change some colors
#export CLICOLOR=1
#export LSCOLORS=ExFxBxDxCxegedabagacad


# Al here: the following three blocks were added by Udacity’s git script
# Enable tab completion
source ~/my_configs/git/git-completion.bash
# brighter colors!
green="\[\033[0;32m\]"
blue="\[\033[0;34m\]"
purple="\[\033[0;35m\]"
reset="\[\033[0m\]"
# Change command prompt to dynamically match git status
source ~/my_configs/git/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
export PS1="$purple\u$green\$(__git_ps1)$blue \W $ $reset"



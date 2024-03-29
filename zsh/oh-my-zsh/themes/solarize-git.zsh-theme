# solarize-git.zsh-theme
#
# Author: Alessandro Iyra

# Define vars for colors used in prompts
green=$FG[002]
blue=$FG[004]
red=$FG[001]
reset=$reset_color

# Customize prompt info and colors while utilizing git_prompt information
setopt PROMPT_SUBST ;PS1='$green%n@%M: $blue%~$red $(__git_ps1 "(%s)")$reset\$ '

# see git-prompt.sh doc_string for usage instructions and setup

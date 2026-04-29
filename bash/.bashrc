# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Idempotent PATH manipulation helpers: only add the entry if it isn't already present.
_path_prepend() { case ":$PATH:" in *":$1:"*) ;; *) export PATH="$1:$PATH" ;; esac; }
_path_append()  { case ":$PATH:" in *":$1:"*) ;; *) export PATH="$PATH:$1" ;; esac; }

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## Customize terminal prompts with colors and git status

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

# export (apply) the new prompt settings
export PS1="$green\u$reset@$purple\h$reset:$blue\w$red\$(__git_ps1)$reset\$ "

# set auto color mode for ls command
alias ls='ls --color=auto'

## == Personal Aliases ==

# git
alias glogo='git log --pretty=oneline --graph'
alias gc='git checkout'
alias gc-previous='git checkout -'
alias gc-master='git checkout master'
alias gm-master='git merge master'
alias gpo='git pull origin $(git branch --show-current)'
alias gb='git branch'
alias gco='git checkout '

# fetch + checkout / cherry-pick
gfco() {
    git fetch origin $1
    git checkout $1
}
gfcp() {
    git fetch origin $1
    git cherry-pick $1
}

# Docker
dbash() {
    docker exec -it $1 /bin/bash
}

# re-source whichever rc file matches the current shell (works on Mac zsh and Ubuntu bash)
alias sbc='[ -n "$ZSH_VERSION" ] && [ -f ~/.zshrc ] && source ~/.zshrc; [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ] && source ~/.bashrc'

# reset terminal cursor shape (fixes stuck block cursor after some TUIs exit)
alias fix_caret="printf '\e[0 q'"

# ssh wrapper: silence harmless LocalForward bind-collision noise (e.g., when
# Cursor already holds the forwarded port). Real connection errors still pass through.
ssh() {
    command ssh "$@" 2> >(
        grep --line-buffered -vE 'channel_setup_fwd_listener_tcpip: cannot listen to port|: Address already in use$|Could not request local forwarding\.?$' >&2
    )
}

## == External Aliases ==
# Source the zoox-specific bashrc if present. Fails silently if absent.
[ -f ~/.zoox_configs/.zoox_bashrc ] && source ~/.zoox_configs/.zoox_bashrc

# ------------------------------------------------------
## Alerts
# vscode requires turning bell sound setting to on for this to work (remote machine triggers sound on local machine when \a is echoed)
# Accessibility › Signals: Terminal Bell
alias my.alert.vscode_chime='echo -ne "\a"'
alias my.alert.vscode_two_chime='my.alert.vscode_chime; sleep .5 ; my.alert.vscode_chime'
alias my.alert.vscode_four_chime='my.alert.vscode_two_chime; sleep .5 ; my.alert.vscode_two_chime'
alias beep='my.alert.vscode_four_chime'
# ------------------------------------------------------
#region setup DEBUG trap functions
# Declare an array of functions to be called on DEBUG trap
# functions can be added like this:
# DEBUG_TRAP_FUNCTIONS+=(preexec_warn)
declare -a DEBUG_TRAP_FUNCTIONS=()
run_debug_trap_functions() {
    for func in "${DEBUG_TRAP_FUNCTIONS[@]}"; do
        "$func"
    done
}
trap 'run_debug_trap_functions' DEBUG
#endregion setup DEBUG trap functions
# ------------------------------------------------------
#region Setup command runtime tracking
export LONG_COMMAND_THRESHOLD_SEC=30
setup_my_command_timer() {
    echo "Setting up command timer"
    # sets start time and that there is a command be tracked
    my_set_start_timer() {
        if [[ -z "$CMD_STARTED" ]]; then
            MY_CMD_START_TIME=$(date +%s)
            CMD_STARTED=1
        fi
    }
    # configures a start time before any line of commands is run
    # trap 'my_set_start_timer' DEBUG
    DEBUG_TRAP_FUNCTIONS+=(my_set_start_timer)
    # duration tracking, will be called via prompt command addition
    my_command_timer() {
        MY_CMD_END_TIME=$(date +%s)
        MY_CMD_DURATION=$((MY_CMD_END_TIME - MY_CMD_START_TIME))
        if [ "$MY_CMD_DURATION" -gt "${LONG_COMMAND_THRESHOLD_SEC:-60}" ]; then
            echo "Long command run time: ($MY_CMD_DURATION seconds)"
            beep
        # else
        #     echo "Short command run time: ($MY_CMD_DURATION seconds)"
        fi
        unset CMD_STARTED
    }
    # dont want to clear existing prompt command if exists
    if [[ -n "$PROMPT_COMMAND" ]]; then
        PROMPT_COMMAND="$PROMPT_COMMAND; my_command_timer"
    else
        PROMPT_COMMAND="my_command_timer"
    fi
}
setup_my_command_timer
#endregion Setup command runtime tracking
# ------------------------------------------------------

# Add ~/.local/bin to PATH (originally added by pipx). Prepended for parity with .zshrc.
_path_prepend "$HOME/.local/bin"

## TMUX configs

# start tmux for every terminal window (source: https://unix.stackexchange.com/questions/43601/how-can-i-set-my-default-shell-to-start-up-tmux)
# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux
# fi
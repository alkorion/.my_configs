# Personal aliases + functions shared between bash and zsh.
# Sourced by ~/.my_configs/bash/.bashrc and ~/.my_configs/zsh/.zshrc.
#
# Rule of thumb for what goes here:
#   - Cross-platform safe (works on both Linux GNU and macOS BSD).
#   - Not bash-only (avoid `shopt`, `complete -F`, etc.).
#   - Not zsh-only (avoid `compdef`, zsh array syntax, etc.).
#
# Shell- or OS-specific bits stay in the respective rc file:
#   - bash-only / Linux-only: ~/.my_configs/bash/.bashrc
#   - zsh-only  / macOS-only: ~/.my_configs/zsh/.zshrc

# == ls ==

# `ls -alF` etc. work on both BSD and GNU.
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Colorize ls. GNU uses `--color=auto`; BSD uses `-G`. Pick whichever the
# local ls accepts so this is portable across Linux and macOS.
if ls --color=auto >/dev/null 2>&1; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi

# == git ==

alias glogo='git log --pretty=oneline --graph'
alias gc='git checkout'
alias gco='git checkout '
alias gc-previous='git checkout -'
alias gc-master='git checkout master'
alias gm-master='git merge master'
alias gpo='git pull origin $(git branch --show-current)'
alias gb='git branch'

# fetch + checkout
gfco() {
    git fetch origin "$1"
    git checkout "$1"
}

# fetch + cherry-pick
gfcp() {
    git fetch origin "$1"
    git cherry-pick "$1"
}

# == docker ==

dbash() {
    docker exec -it "$1" /bin/bash
}

# == claude ==

alias cl-r='claude --resume'

# == terminal hygiene ==

# Re-source whichever rc file matches the current shell.
# Works on Mac zsh and Ubuntu bash.
alias sbc='[ -n "$ZSH_VERSION" ] && [ -f ~/.zshrc ] && source ~/.zshrc; [ -n "$BASH_VERSION" ] && [ -f ~/.bashrc ] && source ~/.bashrc'

# Reset cursor shape after some TUIs leave it as a steady block.
alias fix_caret="printf '\e[0 q'"

# ssh wrapper: silence harmless LocalForward bind-collision noise (e.g., when
# Cursor already holds the forwarded port). Real connection errors still
# pass through.
ssh() {
    command ssh "$@" 2> >(
        grep --line-buffered -vE 'channel_setup_fwd_listener_tcpip: cannot listen to port|: Address already in use$|Could not request local forwarding\.?$' >&2
    )
}

# == VS Code remote terminal-bell alerts ==
# vscode requires the "Accessibility › Signals: Terminal Bell" setting
# to be on for these to play sound. Remote machine triggers sound on the
# local machine when \a is echoed.
alias my.alert.vscode_chime='echo -ne "\a"'
alias my.alert.vscode_two_chime='my.alert.vscode_chime; sleep .5 ; my.alert.vscode_chime'
alias my.alert.vscode_four_chime='my.alert.vscode_two_chime; sleep .5 ; my.alert.vscode_two_chime'
alias beep='my.alert.vscode_four_chime'

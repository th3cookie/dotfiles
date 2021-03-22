# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=8000
HISTFILESIZE=2000

# Ignore things in history
HISTIGNORE='top:ls:bg:fg:history'

# Recording each line of history as its issued
PROMPT_COMMAND="history -a"

# Timestamp of each command in history
# Format example: 8000  2019-05-31 00:39:40 ps aux
HISTTIMEFORMAT='%F %T '

# Check the window size after each command and, if necessary,
# Update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned
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

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Alias definitions.
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Extras file will differ per instance/git branch. This .bashrc is to be consistent on master.
# I use gitattributes to ensure this file can be pushed to origin but cannot be merged to master:
# https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes#_merge_strategies
[[ -f ~/.bashrc.extras ]] && . ~/.bashrc.extras

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set PATH so it includes user's private bins if either exists
[[ -d "$HOME/bin" ]] && PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"

# If environment file exists, source it
[[ -f "/etc/environment" ]] && . /etc/environment

# Color man pages
export LESS_TERMCAP_md=$'\e[01;32m' # Bold start
export LESS_TERMCAP_me=$'\e[0m' # Bold end
export LESS_TERMCAP_so=$'\e[01;44;33m' # Standout-mode start
export LESS_TERMCAP_se=$'\e[0m' # Standout-mode end
export LESS_TERMCAP_us=$'\e[01;32m' # Underline start
export LESS_TERMCAP_ue=$'\e[0m' # Underline end

# These two lines are necessary for pipenv to run under pyenv apparently
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set command line editing mode to vi (optional - i am just used to emacs default)
# set -o vi

# Pretty cool for separating out pieces of a shell rc
[[ -e "${HOME}/.bashrc.d/" ]] && rcfiles=$(ls ${HOME}/.bashrc.d/* 2>/dev/null)
for file in $rcfiles; do
    source $file
done
unset rcfiles

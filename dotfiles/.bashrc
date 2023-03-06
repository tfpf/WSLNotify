# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
shopt -s globstar

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-colour, unless we know we "want" colour)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a coloured prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}[\[\033[1;32m\]\u\[\033[0m\]@\[\033[1;32m\]\h\[\033[0m\] \[\033[1;34m\]\w\[\033[0m\]]\$ '
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

# enable colour support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
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

# Automatic completion for pip can be enabled using the output of
# `pip completion --bash`, which should look something like this.
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 2>/dev/null ) )
}
complete -o default -F _pip_completion /usr/bin/python3 -m pip

# Append to a `PATH`-like environment variable without duplication. Arguments
# must not contain spaces.
envappend ()
{
    if [[ $# -lt 2 ]]
    then
        printf "Usage:\n"
        printf "  ${FUNCNAME[0]} <variable name> <value>\n"
        return 1
    fi

    local name=$1
    local value=$2
    if [[ -d $value && :${!name}: != *:$value:* ]]
    then
        eval "export $name=\${$name:+\$$name:}$value"
    fi
}

# Gurobi Optimizer.
envappend GUROBI_HOME /opt/gurobi952/linux64
envappend LD_LIBRARY_PATH $GUROBI_HOME/lib
envappend PATH $GUROBI_HOME/bin

# TeX Live.
envappend INFOPATH /usr/local/texlive/2022/texmf-dist/doc/info
envappend MANPATH /usr/local/texlive/2022/texmf-dist/doc/man
envappend PATH /usr/local/texlive/2022/bin/x86_64-linux

# If `MANPATH` is non-empty, it must contain `/usr/share/man`. Otherwise, `man`
# is unable to find any manual pages. I have observed this on Mint and Manjaro.
envappend MANPATH /usr/share/man

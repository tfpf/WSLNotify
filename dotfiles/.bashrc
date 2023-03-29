# If not running interactively, don't do anything.
case $- in
    *i*) ;;
    *) return;;
esac

# Check for running and stopped jobs before exiting.
shopt -s checkjobs

# Check the window size after each command and, if necessary, update `LINES`
# and `COLUMNS`, because Bash won't get `SIGWINCH` if another process is in the
# foreground.
shopt -s checkwinsize

# Expand aliases, since Bash is running interactively.
shopt -s expand_aliases

# Match `**` in a pathname expansion context with all files and zero or more
# directories and subdirectories.
shopt -s globstar

# Append to the history file; don't overwrite it.
shopt -s histappend

# Make `less` more friendly for non-text input files.
if command -v lesspipe &>/dev/null
then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# Colours for `ls`.
if command -v dircolors &>/dev/null
then
    if [ -r $HOME/.dircolors ]
    then
        eval "$(dircolors -b $HOME/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
fi

# Alias definitions.
if [ -f $HOME/.bash_aliases ]
then
    . $HOME/.bash_aliases
fi

# Enable programmable completion for common commands. You don't need to enable
# this if it's already enabled in `/etc/bash.bashrc` and `/etc/profile` sources
# `/etc/bash.bashrc`.
if ! shopt -oq posix
then
    if [ -f /usr/share/bash-completion/bash_completion ]
    then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]
    then
        . /etc/bash_completion
    fi
fi

# Enable programmable completion for pip. This is actually the output of
# `pip completion --bash`.
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 2>/dev/null ) )
}
complete -o default -F _pip_completion /usr/bin/python3 -m pip

# Append to a `PATH`-like environment variable without duplication.
envarmunge ()
{
    local name=$1
    local value=$2
    if [[ -n $name && -d $value && :${!name}: != *:$value:* ]]
    then
        eval "export $name=\${$name:+\$$name:}\"$value\""
    fi
}

# Cargo and Rust.
envarmunge PATH $HOME/.cargo/bin

# Gurobi Optimizer.
envarmunge GUROBI_HOME /opt/gurobi952/linux64
envarmunge LD_LIBRARY_PATH $GUROBI_HOME/lib
envarmunge PATH $GUROBI_HOME/bin

# TeX Live.
envarmunge INFOPATH /usr/local/texlive/2022/texmf-dist/doc/info
envarmunge MANPATH /usr/local/texlive/2022/texmf-dist/doc/man
envarmunge PATH /usr/local/texlive/2022/bin/x86_64-linux

envarmunge LD_LIBRARY_PATH /lib

# If non-empty, this must contain `/usr/share/man`. Otherwise, `man` is unable
# to find any manual pages. I have observed this on Mint and Manjaro.
envarmunge MANPATH /usr/share/man

envarmunge PATH $HOME/.local/bin
envarmunge PATH $HOME/bin

# If not running interactively, don't do anything.
case $- in
    *i*) ;;
    *) return;;
esac

set -o ignoreeof

shopt -s checkjobs
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar
shopt -s histappend

# Make `less` more friendly for non-text input files.
if command -v lesspipe &>/dev/null
then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# Enable colours for `ls` and make the superuser's terminal prompts more
# conspicuous (if possible). Note that the environment variable may not always
# reflect the correct user name. Also, `PS3` doesn't seem to like the encoded
# version of the ASCII escape character.
export PS1='\n┌[\u@\h \w]\n└─\$ '
export PS2='──▸ '
export PS3='#? '
export PS4='▸ '
if command -v dircolors &>/dev/null
then
    if [ -f $HOME/.dircolors ]
    then
        eval "$(dircolors -b $HOME/.dircolors)"
    elif [ -f $HOME/.dir_colors ]
    then
        eval "$(dircolors -b $HOME/.dir_colors)"
    else
        eval "$(dircolors -b)"
    fi
    if [ "$USER" = root -o "$(id -nu)" = root ]
    then
        export PS1='\n\[\e[1;91m\]┌[\u \h '"($(uname))"'\[\e[0m\] \[\e[1;96m\]\w\[\e[1;91m\]]\n└─# \[\e[0m\]'
        export PS2='\[\e[1;91m\]'$PS2'\[\e[0m\]'
        export PS3='[1;91m'$PS3'[0m'
        export PS4='\[\e[1;91m\]'$PS4'\[\e[0m\]'
    else
        export PS1='\n┌[\[\e[1;92m\]\u\[\e[0m\] \[\e[1;3;93m\]\h '"($(uname))"'\[\e[0m\] \[\e[1;96m\]\w\[\e[0m\]]\n└─\$ '
    fi
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
    COMPREPLY=($(COMP_WORDS="${COMP_WORDS[*]}" COMP_CWORD=$COMP_CWORD PIP_AUTO_COMPLETE=1 $1 2>/dev/null))
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

# Cargo and Rust: local installation.
envarmunge CARGO_HOME $HOME/.cargo
envarmunge PATH $HOME/.cargo/bin

# Gurobi Optimizer.
envarmunge GUROBI_HOME /opt/gurobi952/linux64
envarmunge LD_LIBRARY_PATH /opt/gurobi952/linux64/lib
envarmunge PATH /opt/gurobi952/linux64/bin

# Ipe: allow LaTeX rendering.
envarmunge IPELATEXDIR $HOME/.ipe/latexrun
envarmunge IPELATEXPATH $HOME/.ipe/latexrun

# TeX Live.
envarmunge INFOPATH /usr/local/texlive/*/texmf-dist/doc/info
envarmunge MANPATH /usr/local/texlive/*/texmf-dist/doc/man
envarmunge PATH /usr/local/texlive/*/bin/x86_64-linux

envarmunge C_INCLUDE_PATH /usr/include
envarmunge C_INCLUDE_PATH /usr/local/include

envarmunge CPLUS_INCLUDE_PATH /usr/include/c++/*

envarmunge LD_LIBRARY_PATH /usr/lib
envarmunge LD_LIBRARY_PATH /usr/local/lib

# If non-empty, this must contain `/usr/share/man`. Otherwise, `man` is unable
# to find any manual pages. I have observed this on Mint and Manjaro.
envarmunge MANPATH /usr/share/man

envarmunge PATH $HOME/.local/bin
envarmunge PATH $HOME/bin

# Must be at the end, because it may depend on things set above.
if [ -f $HOME/.bash_aliases ]
then
    . $HOME/.bash_aliases
fi

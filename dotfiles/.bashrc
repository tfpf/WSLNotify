# If not running interactively, don't do anything.
case $- in
    (*i*) ;;
    (*) return;;
esac

set -o ignoreeof

shopt -s checkjobs
shopt -s checkwinsize
shopt -s expand_aliases
shopt -s globstar
shopt -s histappend

# Prepend to an environment variable containing colon-separated paths without
# duplication.
envarmunge()
{
    local name=$1
    local value=$2
    if [[ -n $name && -d $value && :${!name}: != *:$value:* ]]
    then
        eval "export $name=\"$value\"\${$name:+:\$$name}"
    fi
}
_envarmunge()
{
    if [ $COMP_CWORD -eq 1 ]
    then
        local wordlist=$(env | command grep -F = | awk -F = '{print $1}')
        COMPREPLY=($(compgen -W "$wordlist" $2))
    else
        compopt -o default
    fi
}
complete -F _envarmunge envarmunge

envarmunge C_INCLUDE_PATH /usr/local/include
envarmunge CPLUS_INCLUDE_PATH /usr/local/include
envarmunge LD_LIBRARY_PATH /usr/local/lib
envarmunge MANPATH /usr/share/man
envarmunge MANPATH /usr/local/man
envarmunge MANPATH /usr/local/share/man
envarmunge MANPATH $HOME/.local/share/man
envarmunge PATH $HOME/.local/bin
envarmunge PATH $HOME/bin
envarmunge PKG_CONFIG_PATH /usr/local/lib/pkgconfig
envarmunge PKG_CONFIG_PATH /usr/local/share/pkgconfig

# Rust (local installation).
envarmunge CARGO_HOME $HOME/.cargo
envarmunge PATH $HOME/.cargo/bin

# Gurobi Optimizer.
envarmunge GUROBI_HOME /opt/gurobi*/linux64
envarmunge C_INCLUDE_PATH /opt/gurobi*/linux64/include
envarmunge CPLUS_INCLUDE_PATH /opt/gurobi*/linux64/include
envarmunge LD_LIBRARY_PATH /opt/gurobi*/linux64/lib
envarmunge PATH /opt/gurobi*/linux64/bin

# Ipe. Allow LaTeX rendering.
envarmunge IPELATEXDIR $HOME/.ipe/latexrun
envarmunge IPELATEXPATH $HOME/.ipe/latexrun

# TeX Live.
envarmunge INFOPATH /usr/local/texlive/*/texmf-dist/doc/info
envarmunge MANPATH /usr/local/texlive/*/texmf-dist/doc/man
envarmunge PATH /usr/local/texlive/*/bin/x86_64-linux

# Make `less` more friendly for non-text input files.
if command -v lesspipe &>/dev/null
then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# Enable colours for `ls` and make the superuser's terminal prompt more
# conspicuous (if possible). Note that the environment variable may not always
# reflect the correct user name.
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
        export PS1='\n\[\e[1;91m\]┌[\u \h • '"$(uname)"'\[\e[0m\] \[\e[1;96m\]\w\[\e[1;91m\]]\n└─#\[\e[0m\] '
    else
        export PS1='\n┌[\[\e[1;95m\]${VIRTUAL_ENV##*/}\[\e[0m\]${VIRTUAL_ENV:+ }\[\e[1;92m\]\u\[\e[0m\] \[\e[1;3;93m\]\h • '"$(uname)"'\[\e[0m\] \[\e[1;96m\]\w\[\e[0m\]]\n└─\$ '
    fi
fi

if [ -f $HOME/.bash_aliases ]
then
    . $HOME/.bash_aliases
fi

# Enable programmable completion for common commands.
if [ -z "${BASH_COMPLETION_VERSINFO+.}" ]
then
    if [ -f /usr/share/bash-completion/bash_completion ]
    then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]
    then
        . /etc/bash_completion
    fi
fi

# More programmable completion.
. <(pip completion --bash)
if command -v rustup &>/dev/null
then
    . <(rustup completions bash rustup)
    . <(rustup completions bash cargo)
fi

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

export BAT_PAGER='less -iRF'
export EDITOR=vim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01:range1=32:range2=34:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32'
export GDK_SCALE=1
export GIT_EDITOR=vim
# Inkscape does not work with GLIBC on some Linux distributions.
export _INKSCAPE_GC=disable
export MANPAGER='less -i'
# Open the first matching manual page instead of prompting.
export MAN_POSIXLY_CORRECT=1
# Disable accessibility bus error messages when using some GTK programs.
export NO_AT_BRIDGE=1
export PAGER='less -i'
export QT_LOGGING_RULES='qt5ct.debug=false'
# Time format in directory listing.
export TIME_STYLE=long-iso
# Do not change the terminal prompt when in a Python virtual environment.
export VIRTUAL_ENV_DISABLE_PROMPT=1
export XDG_RUNTIME_DIR=/run/user/1000

export HISTCONTROL=ignoreboth
export HISTFILE=$HOME/.bash_history
export HISTFILESIZE=2000
export HISTSIZE=1000
export HISTTIMEFORMAT='[%F %T] '

# Maximum line length of LaTeX output.
export max_print_line=1048576
export error_line=254
export half_error_line=238

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

# Allow viewing non-text files using less.
if command -v lesspipe &>/dev/null
then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# Don't install libraries in 64-bit directories while building CPython.
unset CONFIG_SITE
# Don't ask for the Git PAT in a GUI window. Use the TUI.
unset GIT_ASKPASS
# Don't ask for the SSH password in a GUI window. Use the TUI.
unset SSH_ASKPASS

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

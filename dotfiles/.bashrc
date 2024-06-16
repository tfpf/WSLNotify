# If not running interactively, don't do anything.
case $- in
    (*i*) ;;
    (*) return;;
esac

set -o ignoreeof
shopt -s checkjobs checkwinsize direxpand expand_aliases globstar histappend

# Prepend directories to an environment variable containing colon-separated
# paths without duplication.
envarmunge()
{
    [ -z "$1" -o ! -d "$2" ] && return
    local name="$1"
    local value=$(realpath "$2")
    [[ :${!name}: != *:$value:* ]] && eval "export $name=\"$value\"\${$name:+:\$$name}"
}

envarmunge C_INCLUDE_PATH /usr/local/include
envarmunge CPLUS_INCLUDE_PATH /usr/local/include
envarmunge LD_LIBRARY_PATH /usr/local/lib
envarmunge LD_LIBRARY_PATH /usr/local/lib64
envarmunge MANPATH /usr/share/man
envarmunge MANPATH /usr/local/man
envarmunge MANPATH /usr/local/share/man
envarmunge MANPATH $HOME/.local/share/man
envarmunge PATH $HOME/.local/bin
envarmunge PATH $HOME/bin
envarmunge PATH /usr/sbin
envarmunge PKG_CONFIG_PATH /usr/local/lib/pkgconfig
envarmunge PKG_CONFIG_PATH /usr/local/share/pkgconfig

# Rust (local installation).
envarmunge CARGO_HOME $HOME/.cargo
envarmunge PATH $HOME/.cargo/bin

# Gurobi Optimizer.
envarmunge C_INCLUDE_PATH /opt/gurobi*/linux64/include
envarmunge CPLUS_INCLUDE_PATH /opt/gurobi*/linux64/include
envarmunge GUROBI_HOME /opt/gurobi*/linux64
envarmunge LD_LIBRARY_PATH /opt/gurobi*/linux64/lib
envarmunge PATH /opt/gurobi*/linux64/bin

# Ipe. Allow LaTeX rendering.
envarmunge IPELATEXDIR $HOME/.ipe/latexrun
envarmunge IPELATEXPATH $HOME/.ipe/latexrun

# TeX Live.
envarmunge INFOPATH /usr/local/texlive/*/texmf-dist/doc/info
envarmunge MANPATH /usr/local/texlive/*/texmf-dist/doc/man
envarmunge PATH /usr/local/texlive/*/bin/x86_64-linux

export BASH_COMPLETION_USER_DIR=$HOME/.local/share/bash-completion
export BAT_PAGER='less -iRF'
export EDITOR=vim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01:range1=32:range2=34:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32'
export GIT_EDITOR=vim
# Inkscape does not work with GLIBC on some Linux distributions.
export _INKSCAPE_GC=disable
export MANPAGER='less -i'
# Open the first matching manual page instead of prompting.
export MAN_POSIXLY_CORRECT=1
# Disable accessibility bus error messages when using some GTK programs.
export NO_AT_BRIDGE=1
export PAGER='less -i'
# Time format in directory listing.
export TIME_STYLE=long-iso
# Do not change the terminal prompt when in a Python virtual environment.
export VIRTUAL_ENV_DISABLE_PROMPT=1

export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

export HISTCONTROL=ignoreboth
export HISTFILE=$HOME/.bash_history
export HISTFILESIZE=2000
export HISTSIZE=1000
export HISTTIMEFORMAT='[%F %T] '

# Maximum line length of LaTeX output.
export max_print_line=19999
export error_line=254
export half_error_line=238

# Allow viewing non-text files using less.
command -v lesspipe &>/dev/null && eval "$(SHELL=/bin/sh lesspipe)"

# Don't install libraries in 64-bit directories while building CPython.
unset CONFIG_SITE
# Don't scale GTK apps. (Scaling should be handled by the window manager.)
unset GDK_SCALE
# Don't ask for the Git PAT in a GUI window. Use the TUI.
unset GIT_ASKPASS
# Don't ask for the SSH password in a GUI window. Use the TUI.
unset SSH_ASKPASS

[ -f $HOME/.bash_aliases ] && . $HOME/.bash_aliases

# Source the first existing file of the arguments.
_source_one()
{
    local script
    for script in "$@"
    do
        . "$script" &>/dev/null && break
    done
}

# Enable programmable completion for common commands.
if [ -z "${BASH_COMPLETION_VERSINFO+.}" ]
then
    _source_one /usr/share/bash-completion/bash_completion /etc/bash_completion
fi

# Showing the Git branch in the primary prompt depends upon a script which must
# be sourced separately on some Linux distributions.
if ! command -v __git_ps1 &>/dev/null
then
    _source_one /usr/share/git/completion/git-prompt.sh /usr/share/git-core/contrib/completion/git-prompt.sh
fi

PS1='[\u@\h \w]\$ '
PS2='──▶ '
PS3='#? '
PS4='▶ '
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
fi

unset -f _source_one

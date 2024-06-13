###############################################################################
# User-defined functions.
###############################################################################
_after_command()
{
    local exit_code=$?
    [ -z "${__begin+.}" ] && return
    local last_command=$(history -n -1 2>/dev/null)
    if PS1=$(COLUMNS=$COLUMNS custom-zsh-prompt "$last_command" $exit_code $__begin "$(__git_ps1 '   %s')")
    then
        ([ $__window -ne $(getactivewindow) ] && notify-send -i dialog-information "CLI Ready" "$last_command" &)
    fi
    unset __begin __window
}

_before_command()
{
    [ -n "${__begin+.}" ] && return
    __window=${WINDOWID:-$(getactivewindow)}
    __begin=$(custom-zsh-prompt)
}

c()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    if [ "$2" == ++ ]
    then
        local c=g++
        local l=c++
    else
        local c=gcc
        local l=c
    fi
    clang-format <($c -E "$1" | command grep -Fv '#') | bat -l $l --file-name "$1"
}

cfs()
{
    local files=(/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
    [ ! -f $files[1] ] && printf "CPU frequency files not found.\n" >&2 && return 1
    if [ $# -lt 1 ]
    then
        column $files
    else
        sudo tee $files <<< $1
    fi
}

e()
{
    [ -n "$VIRTUAL_ENV" ] && deactivate
    exec zsh
}

envarmunge()
{
    [ -z "$1" -o ! -d "$2" ] && return
    local name="$1"
    local value=$(realpath "$2")
    [[ :${(P)name}: != *:$value:* ]] && eval "export $name=\"$value\"\${$name:+:\$$name}"
}

getactivewindow()
{
    if [ -z "$DISPLAY" ]
    then
        printf "0\n"
    else
        xdotool getactivewindow
    fi
}

h()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    hexdump -e '"%07.7_Ax\n"' -e '"%07.7_ax " 32/1 " %02x" "\n"' "$1" | ${=BAT_PAGER}
}

import()
{
    printf "This is Zsh. Did you mean to type this in Python?\n" >&2 && return 1
}

o()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    (
        objdump -Cd "$1"
        readelf -p .rodata -x .rodata -x .data "$1" 2>/dev/null
    ) | ${=BAT_PAGER}
}

rr()
{
    case $1 in
        ("" | *[^0-9]*) local length=20;;
        (*) local length=$1;;
    esac
    for pattern in '0-9' 'A-Za-z' 'A-Za-z0-9' 'A-Za-z0-9!@#$*()'
    do
        tr -cd $pattern </dev/urandom | head -c $length
        printf "\n"
    done
}

if ! command -v __git_ps1 &>/dev/null
then
    . /usr/share/git-core/contrib/completion/git-prompt.sh &>/dev/null  \
    || . /usr/share/git/completion/git-prompt.sh &>/dev/null  \
    || . /usr/share/git/git-prompt.sh &>/dev/null
fi

###############################################################################
# Shell options.
###############################################################################
setopt completealiases histignoredups histignorespace ignoreeof interactive monitor promptpercent promptsubst zle
unsetopt alwayslastprompt autocd beep extendedglob nomatch notify

bindkey -e
bindkey "^?" backward-delete-char
bindkey "^[^?" backward-kill-word
bindkey "^[[H" beginning-of-line
bindkey "^[[1;3D" backward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[3~" delete-char
bindkey "^[[B" down-history
bindkey "^[[F" end-of-line
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[3;5~" kill-word
bindkey "^[[A" up-history

###############################################################################
# Environment variables.
###############################################################################
export BAT_PAGER='less -iRF'
export EDITOR=vim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01:range1=32:range2=34:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32'
export GIT_EDITOR=vim
HISTFILE=~/.zsh_history
HISTSIZE=2000
export _INKSCAPE_GC=disable
export MANPAGER='less -i'
export MAN_POSIXLY_CORRECT=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export NO_AT_BRIDGE=1
export PAGER='less -i'
PS1='[%n@%m %~]%# '
PS2='──▶ '
PS3='#? '
PS4='▶ '
SAVEHIST=1000
export TIME_STYLE=long-iso
VIRTUAL_ENV_DISABLE_PROMPT=1
ZLE_REMOVE_SUFFIX_CHARS=
ZLE_SPACE_SUFFIX_CHARS=

export max_print_line=19999
export error_line=254
export half_error_line=238

envarmunge C_INCLUDE_PATH /usr/local/include
envarmunge CPLUS_INCLUDE_PATH /usr/local/include
envarmunge FPATH ~/.local/share/zsh-completions/completions
envarmunge LD_LIBRARY_PATH /usr/local/lib
envarmunge LD_LIBRARY_PATH /usr/local/lib64
envarmunge MANPATH /usr/share/man
envarmunge MANPATH /usr/local/man
envarmunge MANPATH /usr/local/share/man
envarmunge MANPATH ~/.local/share/man
envarmunge PATH ~/.local/bin
envarmunge PATH ~/bin
envarmunge PATH /usr/sbin
envarmunge PKG_CONFIG_PATH /usr/local/lib/pkgconfig
envarmunge PKG_CONFIG_PATH /usr/local/share/pkgconfig

envarmunge CARGO_HOME ~/.cargo
envarmunge PATH ~/.cargo/bin

envarmunge C_INCLUDE_PATH /opt/gurobi*/linux64/include
envarmunge CPLUS_INCLUDE_PATH /opt/gurobi*/linux64/include
envarmunge GUROBI_HOME /opt/gurobi*/linux64
envarmunge LD_LIBRARY_PATH /opt/gurobi*/linux64/lib
envarmunge PATH /opt/gurobi*/linux64/bin

envarmunge IPELATEXDIR ~/.ipe/latexrun
envarmunge IPELATEXPATH ~/.ipe/latexrun

envarmunge INFOPATH /usr/local/texlive/*/texmf-dist/doc/info
envarmunge MANPATH /usr/local/texlive/*/texmf-dist/doc/man
envarmunge PATH /usr/local/texlive/*/bin/x86_64-linux

. <(dircolors -b ~/.dircolors)

command -v lesspipe &>/dev/null && . <(SHELL=/bin/sh lesspipe)

unset CONFIG_SITE
unset GDK_SCALE
unset GIT_ASKPASS
unset SSH_ASKPASS

###############################################################################
# Built-in functions.
###############################################################################
autoload -Uz add-zsh-hook compinit select-word-style

# Load these and immediately execute them (Zsh does not do so automatically)
# because they help set the primary prompt.
add-zsh-hook precmd _after_command
add-zsh-hook preexec _before_command
_before_command && _after_command

compinit
zstyle ':completion:*' file-sort name
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' menu false
zstyle ':completion:*' special-dirs true
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==1;90=}:$LS_COLORS")'

select-word-style bash

###############################################################################
# User-defined aliases.
###############################################################################
unalias -a

alias d='diff -ad -W $COLUMNS -y --suppress-common-lines'
alias g='gvim'
alias less='command less -i'
alias perfstat='perf stat -e task-clock,cycles,instructions,branches,branch-misses,cache-references,cache-misses '
alias pgrep='command pgrep -il'
alias ps='command ps a -c'
alias time=$'/usr/bin/time -f "\n\e[3mReal %e s · User %U s · Kernel %S s · MRSS %M KiB · %P CPU · %c ICS · %w VCS\e[m" '
alias valgrind='command valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose '
alias x='xdg-open'

alias f='watch -n 1 "command grep -F MHz /proc/cpuinfo | nl -n rz -w 2 | sort -k 5 -gr | sed s/^0/\ /g"'
alias htop='command htop -d 10 -t -u $USER'
alias m='watch -d -n 1 free -ht'
alias s='watch -d -n 1 sensors'
alias top='command top -d 1 -H -u $USER'

alias l='command ls -lNX --color=auto --group-directories-first'
alias la='command ls -AhlNX --color=auto --group-directories-first'
alias ls='command ls -C --color=auto'
alias lt='command ls -AhlNrt --color=auto'

alias egrep='command grep -En --binary-files=without-match --color=auto'
alias fgrep='command grep -Fn --binary-files=without-match --color=auto'
alias grep='command grep -n --binary-files=without-match --color=auto'

if command -v batcat &>/dev/null
then
    alias bat='batcat'
    alias cat='batcat'
elif command -v bat &>/dev/null
then
    alias cat='bat'
fi

alias p='python3 -B'
alias t='python3 -m timeit'
alias pip='python3 -m pip'

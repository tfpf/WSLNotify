###############################################################################
# User-defined functions.
###############################################################################
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

venv_info()
{
    if [ -z "$VIRTUAL_ENV_PROMPT" ]
    then
        unset venv_info_msg_0_
    else
        venv_info_msg_0_="  %F{12}$VIRTUAL_ENV_PROMPT%f"
    fi
}

###############################################################################
# Shell options.
###############################################################################
setopt bashautolist histignoredups histignorespace ignoreeof interactive monitor promptpercent promptsubst zle
unsetopt alwayslastprompt autocd beep extendedglob nomatch notify

bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[1;3D" backward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[B" down-history
bindkey "^[[F" end-of-line
bindkey "^[[1;3C" forward-word
bindkey "^[[1;5C" forward-word
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
export NO_AT_BRIDGE=1
export PAGER='less -i'
PROMPT_SUBST=1
PS2='──▶ '
PS3='#? '
PS4='▶ '
SAVEHIST=1000
export TIME_STYLE=long-iso
VIRTUAL_ENV_DISABLE_PROMPT=1

export max_print_line=19999
export error_line=254
export half_error_line=238

case $(uname) in
    (Darwin) os='';;
    (Linux) os='';;
    (*NT*) os='';;
    (*) os='';;
esac
PS1=$'\n┌[%{\e[1;92m%}%n%{\e[m%} %{\e[1;3;93m%}'"$os"$' %m%{\e[m%} %{\e[1;96m%}%~%{\e[m%}]$vcs_info_msg_0_$venv_info_msg_0_\n└─%# '
unset os

envarmunge C_INCLUDE_PATH /usr/local/include
envarmunge CPLUS_INCLUDE_PATH /usr/local/include
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
autoload -Uz add-zsh-hook compinit vcs_info

add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{2}+%f'
zstyle ':vcs_info:*' unstagedstr '%F{1}*%f'
zstyle ':vcs_info:git:*' actionformats '   %F{2}%b%f|%a %u%c'
zstyle ':vcs_info:git:*' formats '   %F{2}%b%f %u%c'

add-zsh-hook precmd venv_info

compinit
zstyle ':completion:*' file-sort name
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' menu false
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==1;90=}:${(s.:.)LS_COLORS}")'

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

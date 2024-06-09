###############################################################################
# Environment variables.
###############################################################################
HISTFILE=~/.zsh_history
HISTSIZE=2000
PROMPT_SUBST=1
SAVEHIST=1000
export TIME_STYLE=long-iso
VIRTUAL_ENV_DISABLE_PROMPT=1

case $(uname) in
    (Darwin) os='';;
    (Linux) os='';;
    (*NT*) os='';;
    (*) os='';;
esac
PS1=$'\n┌[%{\e[1;92m%}%n%{\e[m%} %{\e[1;3;93m%}'"$os"$' %m%{\e[m%} %{\e[1;96m%}%~%{\e[m%}]$vcs_info_msg_0_$venv_info_msg_0_\n└─%# '
unset os

. <(dircolors -b ~/.dircolors)

###############################################################################
# Shell options.
###############################################################################
setopt bashautolist promptpercent promptsubst
unsetopt autocd beep extendedglob nomatch notify

bindkey -e

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
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==90=0}:${(s.:.)LS_COLORS}")'

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

###############################################################################
# User-defined functions.
###############################################################################
e()
{
    [ -n "$VIRTUAL_ENV" ] && deactivate
    exec zsh
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

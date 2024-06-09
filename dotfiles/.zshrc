HISTFILE=~/.zsh_history
HISTSIZE=2000
PROMPT_SUBST=1
SAVEHIST=1000

setopt promptpercent promptsubst
unsetopt autocd beep extendedglob nomatch notify

bindkey -e

autoload -Uz add-zsh-hook compinit vcs_info

add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{2}+%f'
zstyle ':vcs_info:*' unstagedstr '%F{1}*%f'
zstyle ':vcs_info:git:*' actionformats '%F{2}%b%f|%a %u%c'
zstyle ':vcs_info:git:*' formats '%F{2}%b%f %u%c'

compinit

case $(uname) in
    (Darwin) os='';;
    (Linux) os='';;
    (*NT*) os='';;
    (*) os='';;
esac
PS1=$'\n┌[%F{10}%B%n%b%f %{\e[1;3;93m%}'$os$' %m%{\e[m%} %F{14}%B%~%b%f]   ${vcs_info_msg_0_}\n└─%# '
unset os

e()
{
    [ -n "$VIRTUAL_ENV" ] && deactivate
    exec zsh
}

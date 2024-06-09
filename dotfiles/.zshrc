HISTFILE=~/.zsh_history
HISTSIZE=2000
PROMPT_SUBST=1
SAVEHIST=1000

setopt promptpercent promptsubst
unsetopt autocd beep extendedglob nomatch notify

bindkey -e

autoload -Uz compinit
compinit

case $(uname) in
    (Darwin) PS1=$'\n┌[%F{10}%B%n%b%f %F{11}%B%{\e[3m%} %m%b%f %F{14}%B%~%b%f]\n└─%# ';;
    (Linux) PS1=$'\n┌[%F{10}%B%n%b%f %F{11}%B%{\e[3m%} %m%b%f %F{14}%B%~%b%f]\n└─%# ';;
    (*NT*) PS1=$'\n┌[%F{10}%B%n%b%f %F{11}%B%{\e[3m%} %m%b%f %F{14}%B%~%b%f]\n└─%# ';;
    (*) PS1=$'\n┌[%F{10}%B%n%b%f %F{11}%B%{\e[3m%}%m%b%f %F{14}%B%~%b%f]\n└─%# ';;
esac

e()
{
    [ -n $VIRTUAL_ENV ] && deactivate
    exec zsh
}

# Windows Terminal: set up a virtual display so that GUI apps can be opened
export DISPLAY=localhost:0.0
alias e='/mnt/c/Program\ Files/VcXsrv/xlaunch.exe'

# Windows Terminal: prevent exit failure if the previous command failed
alias exit='printf "\n" && exit'

# gVim
alias g='/mnt/c/Program\ Files\ \(x86\)/Vim/vim82/gvim.exe'

# some sort of a system monitor
alias F='watch -n 0.1 "cat /proc/cpuinfo | grep MHz"'
alias M='watch -n 0.1 free -ht'

# file listing
alias l='ls -lNX --color=auto --group-directories-first --time-style=long-iso'
alias la='ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'
alias ls='ls -C --color=auto'
alias lt='ls -hlNtr --color=auto --group-directories-first --time-style=long-iso'

# do not perform text search on binary files
alias grep='grep --binary-files=without-match --color=auto'

alias pgrep='pgrep -il'
alias ps='ps -e | sort -gr'

alias p='/usr/local/bin/python3.8 -B'
alias pip='/usr/local/bin/python3.8 -m pip'

alias time='/usr/bin/time'

alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose'

# view frequency of the CPU in real time
# CPU information is found in the file `/proc/cpuinfo`
alias Freq='watch -n 0.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'

# display all files in current directory
# show the size of the files using binary prefixes
# use long listing format
#
alias la='ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'
alias l='ls -lNX --color=auto --group-directories-first --time-style=long-iso'
alias ps='ps -e | sort -gr'
alias pgrep='pgrep -il'
alias Mem='watch -n 0.1 free -h'
alias resolve='xrandr -d :0 --output eDP --mode 1366x768'
alias shred='shred -uvz --iterations=0'
alias uptime='uptime -p && uptime -s'

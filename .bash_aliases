# view frequency of the CPU in real time
# CPU information is found in the file '/proc/cpuinfo'
alias Freq='watch -n 0.1 "cat /proc/cpuinfo | grep \"^[c]pu MHz\""'

# display non-hidden files in current directory
# arrange files in long list format and sort by extension
# don't use quotes in names containing special characters
alias l='ls -lNX --color=auto --group-directories-first --time-style=long-iso'

# same as above, but also show all hidden files
# and the show the size using binary prefixes
alias la='ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'

# view information about computer memory in real time
alias Mem='watch -n 0.1 free -ht'

# display PID of process matching the argument string
# also display the name of the process
alias pgrep='pgrep -il'

# list all running processes
# combine with 'grep' for coloured output
# otherwise, use 'pgrep'
alias ps='ps -e | sort -gr'

# change the screen resolution of the active display to 1366x768
alias resolve='xrandr --output $(xrandr | grep " connected" | cut -f 1 -d " ") --mode 1366x768'

# delete a file after overwriting it with zeros
alias shred='shred -uvz --iterations=0'

# display the uptime
alias uptime='uptime -p && uptime -s'

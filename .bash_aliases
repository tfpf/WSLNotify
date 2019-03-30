# aliases

# view frequency of the CPU in real time
# CPU information is found in the file '/proc/cpuinfo'
alias Freq='watch -n 0.1 "cat /proc/cpuinfo | grep \"^cpu MHz\""'

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

# overwrite a file with zeros then delete it
# '--iterations=0' means it is not overwritten with random data
alias shred='shred -uvz --iterations=0'

################################################################################

# functions

# change the screen resolution of the active display
# if the resolution is not specified, change it to your preferred resolution
# finally, display all available resolutions
resolve()
{
	active_display=$(xrandr | grep " connected" | cut -f 1 -d " ")
	if [ $# -lt 1 ];
	then
		xrandr --output $active_display --mode 1366x768
	else
		xrandr --output $active_display --mode $1
	fi
	xrandr
}

# display the total time the system has been running since being powered on
# also display when the system was last powered on
# using a function because 'uptime -sp' didn't work
rtime()
{
	uptime -p
	uptime -s
}

# compile a C program
# if compilation fails, do nothing more
# executable file name shall be same as C file name
# only their extensions will be different
# on compiling, forward the arguments to the executable
cne()
{
	if [ $# -lt 1 ]
	then
		echo "usage:"
		echo -e "\tcne main_C_program.c argument1.txt argument2.dat argument3"
		return
	fi
	cne_arguments=("$@") # array of the items ($1, $2, $3, $4, ...)
	c_program_arguments=${cne_arguments[@]:1} # array of the items ($2, $3, $4, ...)
	c_program_file=$1
	executable_file=${c_program_file%.*}.out
	gcc -o $executable_file $c_program_file
	if [ $? -eq 0 ];
	then
		./$executable_file $c_program_arguments
	fi
}

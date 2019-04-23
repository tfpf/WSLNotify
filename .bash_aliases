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
# sort them by descending order of PID
# combine with 'grep' for coloured output
# alternatively, use 'pgrep'
alias ps='ps -e | sort -gr'

# overwrite a file with zeros, and then delete it
# 'z' option tells the program to overwrite with zeros
# long option indicates that the file should not be overwritten with random data
# otherwise, by default, random data is overwritten before zeros are written
alias shred='shred -uvz --iterations=0'

################################################################################

# display all available screen resolutions
# set screen resolution of active display
# if the resolution is not specified, change it to 1366x768 (set it to whatever you want)
resolve ()
{
	xrandr
	local active_display=$(xrandr | grep " connected" | cut -d " " -f 1)
	if [ $# -lt 1 ];
	then
		xrandr --output $active_display --mode 1366x768
		return $?
	fi
	xrandr --output $active_display --mode $1
}

################################################################################

# display the total time the system has been running since being powered on
# also display when the system was last powered on
# using an alias won't work, because 'uptime -ps' ignores the 'p' option
rtime ()
{
	uptime -p
	uptime -s
}

################################################################################

# compile a C program (if compilation fails, do nothing more)
# executable file name shall be same as C file name
# only their extensions will be different
# on compiling, forward the arguments to the executable
cne ()
{
	if [ $# -lt 1 ]
	then
		echo "usage:"
		echo -e "\tcne main_C_program.c argument1.txt argument2.dat argument3 etc."
		return 1
	fi
	cne_arguments=("$@") # array of the items ($1, $2, $3, $4, ...)
	c_program_arguments=${cne_arguments[@]:1} # array of the items ($2, $3, $4, ...)
	c_program_file=$1
	executable_file=${c_program_file%.*}.out
	gcc -o $executable_file -Wall -Wextra $c_program_file
	if [ $? -eq 0 ];
	then
		./$executable_file $c_program_arguments
	fi
}

# programmable completion (using Tab) for the 'cne' function
# the first argument must be a C program file
# further arguments may be other files of any type
_cne ()
{
	if [ $COMP_CWORD -eq 1 ];
	then
		COMPREPLY=( $(compgen -f -X '!*.c') )
		return
	fi
	COMPREPLY=()
}
complete -o bashdefault -o default -F _cne cne

################################################################################

# clone a GitHub repository
# then change the working directory to that of the repository
gcl ()
{
	# check arguments
	if [ $# -lt 1 ];
	then
		echo "usage:"
		echo -e "\tgcl <GitHub repository link>"
		return 1
	fi

	# obtain 'directory', the name of the directory in which the local files get stored
	repository=$(basename $1)
	directory=${repository%.*}

	# clone repository in desired location and enter the directory
	cd ~/Documents/projects/
	git clone $1
	cd $directory
}

# update local copy of GitHub repository from its master branch
pull ()
{
	git pull origin master
}

# update master branch of remote copy of GitHub repository
push ()
{
	if [ $# -lt 1 ];
	then
		echo "usage:"
		echo -e "\tpush \"<commit message>\""
		return 1
	fi
	git add .
	git commit -m "$1"
	git push origin master
}

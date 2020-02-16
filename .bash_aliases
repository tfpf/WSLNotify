# few things for Windows Terminal
cd /mnt/c/Users/vpaij/Documents/projects
alias e='export DISPLAY=localhost:0.0; /mnt/c/Program\ Files/VcXsrv/xlaunch.exe'
alias f='/mnt/c/Program\ Files/Mozilla\ Firefox/firefox.exe'
alias g='/mnt/c/Program\ Files\ \(x86\)/Vim/vim81/gvim.exe'
alias o='/mnt/c/Users/vpaij/AppData/Local/Programs/Opera/launcher.exe'
alias p='/mnt/c/texlive/2019/bin/win32/pdflatex.exe'

# other aliases
alias Freq='watch -n 0.1 "cat /proc/cpuinfo | grep \"^cpu MHz\""'
alias thypon='python3'
alias l='ls -lNX --color=auto --group-directories-first --time-style=long-iso'
alias la='ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'
alias lt='ls -hlNtr --color=auto --group-directories-first --time-style=long-iso'
alias Mem='watch -n 0.1 free -ht'
alias pgrep='pgrep -il'
alias ps='ps -e | sort -gr'
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
	if [ $COMP_CWORD -eq 1 ]
	then
		COMPREPLY=( $(compgen -f -X '!*.c') )
		return
	fi
	COMPREPLY=()
}
complete -o bashdefault -o default -F _cne cne

################################################################################

# clone a GitHub repository to a specific location
# then change the working directory to that location
gcl ()
{
	# check arguments
	if [ $# -lt 1 ]
	then
		echo "usage:"
		echo -e "\tgcl <GitHub repository link>"
		return 1
	fi

	# obtain 'directory', where the local files get stored
	repository=$(basename $1) # of the form 'something.git'
	directory=${repository%.*} # remove the '.git' part
	full_path="/home/users/Documents/projects/$directory" # where you want to store repositories

	# clone repository in desired location and enter the directory
	git clone $1 $full_path
	cd $full_path
}

# update local copy of GitHub repository from its master branch
pull ()
{
	git pull origin master
}

# update master branch of remote copy of GitHub repository
push ()
{
	if [[ $# -lt 2 ]]
	then
		echo "usage:"
		echo -e "\tpush <file name> \"<commit message>\""
		return 1
	fi
	git add "$1"
	git commit -m "$2"
	git push origin master
}

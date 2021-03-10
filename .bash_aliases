# ~/.bash_aliases

# Windows Terminal: set up a virtual display using VcXsrv to run Qt and other
# GUI apps.
export DISPLAY=localhost:0.0
export LIBGL_ALWAYS_INDIRECT=1
export XDG_RUNTIME_DIR=/tmp/runtime-tfpf
alias e='/mnt/c/Program\ Files/VcXsrv/xlaunch.exe'

# Windows Terminal: prevent exit failure if the previous command failed.
alias exit='printf "\n" && exit'

alias g='/mnt/c/Program\ Files\ \(x86\)/Vim/vim82/gvim.exe'

# Some sort of a system monitor.
alias F='watch -n 0.1 "cat /proc/cpuinfo | grep MHz"'
alias M='watch -n 0.1 free -ht'

alias l='ls -lNX --color=auto --group-directories-first --time-style=long-iso'
alias la='ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'
alias ls='ls -C --color=auto'
alias lt='ls -hlNtr --color=auto --group-directories-first --time-style=long-iso'

alias grep='grep --binary-files=without-match --color=auto'

alias pgrep='pgrep -il'

alias ps='ps -e | sort -gr'

alias p='/usr/local/bin/python3.8 -B'
alias t='/usr/local/bin/python3.8 -m timeit'
alias pip='/usr/local/bin/python3.8 -m pip'

alias time='/usr/bin/time -f "----------\n%e s, %M kB (max)\n%I FS inputs, %O FS outputs, %W swaps\n%F major PFs, %R minor PFs" '

alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose'

# Commit and push changes to the master branch of a GitHub repository.
push ()
{
    if [[ $# -lt 2 ]]
    then
        printf "usage:\n"
        printf "\tpush \"commit message\" file1 file2 file3 ...\n"
        printf "$#\n"
        return 1
    fi

    args=( "$@" )
    files=("${args[@]:1}")

    git add ${files[*]}
    git commit -m "$1"
    git push origin master
}

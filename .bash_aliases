# ~/.bash_aliases
# Aliases and virtual display setup.

# WSL: set up a virtual display using VcXsrv to run Qt and other GUI apps.
export DISPLAY=localhost:0.0
export GDK_SCALE=1
export LIBGL_ALWAYS_INDIRECT=1
export XDG_RUNTIME_DIR=/tmp/runtime-tfpf
alias vcx='/mnt/c/Program\ Files/VcXsrv/xlaunch.exe'

# WSL: prevent exit failure if the previous command failed.
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
        printf "\t${FUNCNAME[0]} \"commit message\" file1 [file2] [file3] [...]\n"
        return 1
    fi

    args=( "$@" )
    files=("${args[@]:1}")

    git add ${files[*]}
    git commit -m "$1"
    git push origin master
}

# Windows Explorer can open WSL folders, but the command must be invoked from
# within the WSL folder to be opened. This is a convenience function to do
# that.
e ()
{
    if [[ $# -lt 1 || ! -d "$1" ]]
    then
        printf "usage:\n"
        printf "\t${FUNCNAME[0]} dirpath\n"
        return 1
    fi

    cd "$1"
    explorer.exe .
    cd -
}

# PDF optimiser. This requires that `ghostscript' be installed.
pdfopt ()
{
    if [[ $# -lt 2 ]]
    then
        printf "usage:\n"
        printf "\t${FUNCNAME[0]} input_file.pdf output_file.pdf [resolution]\n"
        return
    fi

    if [[ $# -ge 3 ]]
    then
        opt_level=$3
    else
        opt_level=72
    fi

    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress     \
       -dNOPAUSE -dQUIET -dBATCH                                              \
       -sOutputFile=$2                                                        \
       -dDownsampleColorImages=true -dColorImageResolution=$opt_level         \
       -dDownsampleGrayImages=true  -dGrayImageResolution=$opt_level          \
       -dDownsampleMonoImages=true  -dMonoImageResolution=$opt_level          \
       $1
}

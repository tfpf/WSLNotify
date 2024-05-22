unalias -a

alias bye='true && exit'
alias d='diff -ad -W $COLUMNS -y --suppress-common-lines'
alias g='gvim'
alias less='command less -i'
alias perfstat='perf stat -e task-clock,cycles,instructions,branches,branch-misses,cache-references,cache-misses '
alias pgrep='command pgrep -il'
alias ps='command ps a -c'
alias time=$'/usr/bin/time -f "\n\e[3mReal %e s · User %U s · Kernel %S s · MRSS %M KiB · %P CPU · %c ICS · %w VCS\e[m" '
alias valgrind='command valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose '
alias x='xdg-open'

alias f='watch -n 1 "command grep -F MHz /proc/cpuinfo | nl -n rz -w 2 | sort -k 5 -gr | sed s/^0/\ /g"'
alias htop='command htop -d 10 -t -u $USER'
alias m='watch -d -n 1 free -ht'
alias s='watch -d -n 1 sensors'
alias top='command top -d 1 -H -u $USER'

alias l='command ls -lNX --color=auto --group-directories-first'
alias la='command ls -AhlNX --color=auto --group-directories-first'
alias ls='command ls -C --color=auto'
alias lt='command ls -AhlNrt --color=auto'

alias egrep='command grep -En --binary-files=without-match --color=auto'
alias fgrep='command grep -Fn --binary-files=without-match --color=auto'
alias grep='command grep -n --binary-files=without-match --color=auto'

if command -v batcat &>/dev/null
then
    alias bat='batcat'
    alias cat='batcat'
elif command -v bat &>/dev/null
then
    alias cat='bat'
fi

alias p='python3 -B'
alias t='python3 -m timeit'
alias pip='python3 -m pip'

alias L="$HOME/.bash_hacks.py L"
alias P="$HOME/.bash_hacks.py P"
alias T="$HOME/.bash_hacks.py T"

# Control CPU frequency scaling.
cfs()
{
    local files=(/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
    [ ! -f ${files[0]} ] && printf "CPU frequency files not found.\n" >&2 && return 1
    if [ $# -lt 1 ]
    then
        column ${files[@]}
    else
        sudo tee ${files[@]} <<< $1
    fi
}

# Restart the shell. Exit from any Python virtual environments before doing so.
e()
{
    [ -n "$VIRTUAL_ENV" ] && deactivate
    exec bash
}

# View object files.
o()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    (
        objdump -Cd "$1"
        readelf -p .rodata -x .rodata -x .data "$1" 2>/dev/null
    ) | $BAT_PAGER
}

# View raw data.
h()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    hexdump -e '"%07.7_Ax\n"' -e '"%07.7_ax " 32/1 " %02x" "\n"' "$1" | $BAT_PAGER
}

# Preprocess C or C++ source code.
c()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    if [ "$2" == ++ ]
    then
        local c=g++
        local l=c++
    else
        local c=gcc
        local l=c
    fi
    # $c -E "$1" | command grep -Fv '#' | bat -l c++ --file-name "$1"
    clang-format <($c -E "$1" | command grep -Fv '#') | bat -l $l --file-name "$1"
}

# Obtain the ID of the active window.
getactivewindow()
{
    if [ -z "$DISPLAY" ]
    then
        printf "0\n"
    else
        xdotool getactivewindow
    fi
}

# This block is executed only if Bash is running on WSL (Windows Subsystem for
# Linux).
if command grep -Fiq microsoft /proc/version
then
    . $HOME/.bash_aliases_wsl
fi

# Pre-command for command timing. It will be called just before any command is
# executed.
_before_command()
{
    [ -n "${__begin+.}" ] && return
    __window=${WINDOWID:-$(getactivewindow)}
    __begin=$(custom-bash-prompt)
}

# Post-command for command timing. It will be called just before the prompt is
# displayed (i.e. just after any command is executed).
_after_command()
{
    local exit_code=$?
    [ -z "${__begin+.}" ] && return
    local last_command=$(history 1)

    # The below program will exit successfully if a notification is to be
    # shown.
    if PS1=$(custom-bash-prompt "$last_command" $exit_code $__begin "$(__git_ps1 '   %s')")  \
    && [ $__window -ne $(getactivewindow) ]
    then
        notify-send -i dialog-information "CLI Ready" "$last_command"
    fi
    unset __begin __window
}

trap _before_command DEBUG
PROMPT_COMMAND=_after_command

# PDF optimiser. This requires that Ghostscript be installed.
pdfopt()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} input_file.pdf output_file.pdf [resolution]\n" >&2 && return 1
    [ $# -ge 3 ] && local opt_level=$3 || local opt_level=72
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress     \
       -dNOPAUSE -dQUIET -dBATCH                                              \
       -sOutputFile="$2"                                                      \
       -dDownsampleColorImages=true -dColorImageResolution=$opt_level         \
       -dDownsampleGrayImages=true  -dGrayImageResolution=$opt_level          \
       -dDownsampleMonoImages=true  -dMonoImageResolution=$opt_level          \
       "$1"
}

# Random string generator.
rr()
{
    case $1 in
        ("" | *[^0-9]*) local length=20;;
        (*) local length=$1;;
    esac
    for pattern in '0-9' 'A-Za-z' 'A-Za-z0-9' 'A-Za-z0-9!@#$*()'
    do
        tr -cd $pattern </dev/urandom | head -c $length
        printf "\n"
    done
}

# This program (part of the ImageMagick suite) is just schmuck bait. I've
# entered this at the Bash REPL instead of the Python REPL several times, and
# got scared because the computer seemed to freeze. No more.
import()
{
    printf "This is Bash. Did you mean to type this in Python?\n" >&2 && return 1
}

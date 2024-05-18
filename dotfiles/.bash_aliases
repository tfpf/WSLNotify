unalias -a

alias bye='true && exit'
alias d='diff -ad -W $COLUMNS -y --suppress-common-lines'
alias less='command less -i'
alias perfstat='perf stat -e task-clock,cycles,instructions,branches,branch-misses,cache-references,cache-misses '
alias pgrep='command pgrep -il'
alias ps='command ps a -c'
alias time=$'/usr/bin/time -f "\n\e[3mReal %e s · User %U s · Kernel %S s · MRSS %M KiB · %P CPU · %c ICS · %w VCS\e[m" '
alias valgrind='command valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose '

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

    # Setup for a virtual display using VcXsrv to run GUI apps. You may want to
    # install `x11-xserver-utils`, `dconf-editor` and `dbus-x11`, and create
    # the file `$HOME/.config/dconf/user` to avoid getting warnings.
    if command grep -Fq WSL2 /proc/version
    then
        export DISPLAY=$(command grep -F -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
    else
        export DISPLAY=localhost:0.0
    fi
    export LIBGL_ALWAYS_INDIRECT=1

    # Run a PowerShell script without changing the global execution policy.
    alias psh='powershell.exe -ExecutionPolicy Bypass'

    # Compile programs written in C#.
    alias csc='/mnt/c/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe'

    # Put `WSLNotify.exe` and `WSLGetActiveWindow.exe` in a folder which is in
    # `PATH` (e.g. `C:\Windows`) to make these aliases work. Alternatively,
    # specify the full path to the EXE files below.
    unset -f getactivewindow
    alias getactivewindow='WSLGetActiveWindow.exe'
    alias notify-send='WSLNotify.exe'

    # Create the virtual display. VcXsrv should be installed.
    vcx()
    {
        local vcxsrvpath='/mnt/c/Program Files/VcXsrv/vcxsrv.exe'
        local vcxsrvname=$(basename "$vcxsrvpath")

        # If VcXsrv is started in the background, it writes messages to
        # standard error, and an entry corresponding to it remains in the Linux
        # process list though it is actually a Windows process. Hence, start it
        # in a subshell, suppress its output, and terminate the Linux process.
        # (This does not affect the Windows process.) This pattern may be used
        # in a few more functions below.
        (
            "$vcxsrvpath" -ac -clipboard -multiwindow -wgl &
            sleep 1
            pkill "$vcxsrvname"
        ) &>/dev/null
    }

    # GVIM for Windows.
    g()
    {
        [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1

        # See https://tuxproject.de/projects/vim/ for 64-bit Windows binaries.
        local gvimpath='/mnt/c/Program Files (x86)/Vim/vim90/gvim.exe'
        local gvimname=$(basename "$gvimpath")
        local filedir=$(dirname "$1")
        local filename=$(basename "$1")
        (
            cd "$filedir"
            "$gvimpath" "$filename" &
            sleep 1
            pkill "$gvimname"
        ) &>/dev/null
    }

    # Open a file or link.
    x()
    {
        # Windows Explorer can open WSL directories, but the command must be
        # invoked after navigating to the target directory to avoid problems
        # like a tilde getting interpreted as the Windows home folder instead
        # of the Linux home directory. To avoid changing `OLDPWD`, do this in a
        # subshell.
        if [ -d "$1" ]
        then
            (
                cd "$1"
                explorer.exe .
            )
        else
            xdg-open "$1"
        fi
    }
else
    alias g='gvim'
    alias x='xdg-open'
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
# displayed (i.e. just after any command is executed). The current Git branch
# is also set here; it is used in the primary prompt.
_after_command()
{
    local exit_code=$?
    local last_command=$(history 1 | sed -e 's/^[^]]*\] //' -e 's/\s\+$//')
    custom-bash-prompt "$last_command" $exit_code $__begin $COLUMNS
    local __end=$(custom-bash-prompt)


    [ -z "${__begin+.}" ] && return
    local delay=$((__end-__begin))
    unset __begin
    [ $delay -le 5000 ] && unset __window && return

    local milliseconds=$((delay%1000))
    local seconds=$((delay/1000%60))
    local minutes=$((delay/60000%60))
    local hours=$((delay/3600000))
    local breakup
    [ $hours -gt 0 ] && breakup="$hours h "
    [ $hours -gt 0 -o $minutes -gt 0 ] && breakup="${breakup}$minutes m "
    breakup="${breakup}$seconds s $milliseconds ms"

    if [ $exit_code -eq 0 ]
    then
        local exit_symbol=$'\e[1;32m✓\e[m'
        local icon=dialog-information
    else
        local exit_symbol=$'\e[1;31m✗\e[m'
        local icon=dialog-error
    fi
    local last_command=$(history 1 | sed -e 's/^[^]]*\] //' -e 's/\s\+$//')

    # Bash doesn't calculate the length of a string containing ANSI colour
    # codes correctly, so a correction is required.
    local report="$last_command $exit_symbol $breakup"
    local width=${#report}
    width=$((COLUMNS-width%COLUMNS+width+12))
    printf "\r%*s\n" $width "$report"
    if [ $delay -ge 10000 -a $__window -ne $(getactivewindow) ]
    then
        notify-send -i $icon "CLI Ready" "$last_command • $breakup"
    fi
    unset __window
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

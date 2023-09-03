# This block is executed only if Bash is running on WSL (Windows Subsystem for
# Linux).
if \grep -iq microsoft /proc/version
then

    # Setup for a virtual display using VcXsrv to run GUI apps. You may want to
    # install `x11-xserver-utils`, `dconf-editor` and `dbus-x11`, and create
    # the file `$HOME/.config/dconf/user` to avoid getting warnings.
    if \grep -q WSL2 /proc/version
    then
        export DISPLAY=$(\grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
    else
        export DISPLAY=localhost:0.0
    fi
    export GDK_SCALE=1
    export LIBGL_ALWAYS_INDIRECT=1
    export XDG_RUNTIME_DIR=/tmp/runtime-tfpf

    # Inkscape doesn't work on WSL Ubuntu using GLIBC.
    export _INKSCAPE_GC=disable

    # Run a PowerShell script without changing the global execution policy.
    alias psh='powershell.exe -ExecutionPolicy Bypass'

    # Compile programs written in C#.
    alias csc='/mnt/c/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe'

    # Put `WSLNotify.exe` and `WSLGetActiveWindow.exe` in a folder which is in
    # `PATH` (e.g. `C:\Windows`) to make these aliases work. Alternatively,
    # specify the full path to the EXE files below.
    alias notify-send='WSLNotify.exe'
    alias getactivewindow='WSLGetActiveWindow.exe'

    alias wp='/mnt/c/Users/vpaij/AppData/Local/Programs/Python/Python310/python.exe'

    # Create the virtual display. VcXsrv should be installed.
    vcx ()
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
    g ()
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
    x ()
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

    # Obtain the ID of the active window.
    getactivewindow ()
    {
        if [ -z "$DISPLAY" ]
        then
            printf "0\n"
        else
            xdotool getactivewindow
        fi
    }
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01:range1=32:range2=34:fixit-insert=32:fixit-delete=31:diff-filename=01:diff-hunk=32:diff-delete=31:diff-insert=32:type-diff=01;32'

export HISTCONTROL=ignoreboth
export HISTFILE=$HOME/.bash_history
export HISTFILESIZE=2000
export HISTSIZE=1000
export HISTTIMEFORMAT="[%F %T] "

export QT_LOGGING_RULES="qt5ct.debug=false"

# Don't let Python virtual environments mess up the terminal prompt.
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Maximum line length of LaTeX output.
export max_print_line=1048576
export error_line=254
export half_error_line=238

export EDITOR=vim
export GIT_EDITOR=vim
export BAT_PAGER='less -iRF'
export MANPAGER='less -i'
export PAGER='less -i'

# Do not prompt for the page number when multiple manual pages match the query.
export MAN_POSIXLY_CORRECT=1

# Tell Git to prompt for the PAT on the terminal rather than through a GUI
# program.
unset GIT_ASKPASS
unset SSH_ASKPASS

# Some terminals exit only if the previous command was successful. This can be
# used to exit unconditionally.
alias bye='true && exit'

alias F='watch -n 1 "\grep MHz /proc/cpuinfo | nl -n rz -w 2 | sort -k 5 -gr | sed s/^0/\ /g"'
alias M='watch -n 1 free -ht'
alias s='watch -n 1 sensors'
alias top='\top -d 1 -H -u $USER'
alias htop='\htop -d 10 -t -u $USER'

alias l='\ls -lNX --color=auto --group-directories-first --time-style=long-iso'
alias la='\ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'
alias ls='\ls -C --color=auto'
alias lt='\ls -hlNrt --color=auto --group-directories-first --time-style=long-iso'

alias egrep='\grep -En --binary-files=without-match --color=auto'
alias fgrep='\grep -Fn --binary-files=without-match --color=auto'
alias grep='\grep -n --binary-files=without-match --color=auto'
alias pgrep='\pgrep -il'
alias ps='\ps a -c'

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

# Performance analysis. Use GNU's `time` command rather than Bash's `time`
# shell keyword.
alias S='perf stat -e task-clock,cycles,instructions,branches,branch-misses,cache-references,cache-misses '
alias time='/usr/bin/time -f "$(timefmt)" '

alias d='diff -a -d -W $COLUMNS -y --suppress-common-lines'
alias less='\less -i'
alias valgrind='\valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose '

# Format string for the `time` command.
timefmt ()
{
    printf "%*s\n" $COLUMNS " " | sed "s/ /─/g"
    printf "Real: %%e s.  User: %%U s.  Kernel: %%S s.  "
    printf "MRSS: %%M KiB.  CPU: %%P.  "
    printf "ICS: %%c.  VCS: %%w.\n"
}

# Control CPU frequency scaling.
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]
then
    cfs ()
    {
        local files=(/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor)
        if [ $# -lt 1 ]
        then
            column ${files[*]}
        else
            sudo tee ${files[*]} <<< $1
        fi
    }
    complete -W "$(</sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)" cfs
fi

# Restart the shell. Exit from any Python virtual environments before doing so.
e ()
{
    while [ -n "$VIRTUAL_ENV" ]
    do
        deactivate
    done
    exec bash
}

# View object files.
unalias o &>/dev/null
o ()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    (
        objdump -Cd "$1"
        readelf -p .rodata -x .rodata -x .data "$1" 2>/dev/null
    ) | $BAT_PAGER
}

# View raw data.
h ()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    hexdump -e '"%07.7_Ax\n"' -e '"%07.7_ax " 32/1 " %02x" "\n"' "$1" | $BAT_PAGER
}

# Preprocess C or C++ source code.
c ()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    [ "$2" = ++ ] && local c=g++ || local c=gcc
    $c -E "$1" | \grep -v '#' | bat -l c++ --file-name "$1"
}

# Pre-command for command timing. It will be called just before any command is
# executed.
before_command ()
{
    [ -n "${__begin+.}" ] && return
    __window=${WINDOWID:-$(getactivewindow)}
    __begin=$(date +%s%3N)
}

# Post-command for command timing. It will be called just before the prompt is
# displayed (i.e. just after any command is executed).
after_command ()
{
    local exit_status=$?
    local __end=$(date +%s%3N)
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

    if [ $exit_status -eq 0 ]
    then
        local exit_symbol="[1;32m✓[0m"
        local icon=dialog-information
    else
        local exit_symbol="[1;31m✗[0m"
        local icon=dialog-error
    fi
    local last_command=$(history 1 | sed 's/^[^]]*\] //')

    # Non-ASCII symbols may have to be treated as multi-byte characters,
    # depending on the shell.
    printf "\r%*s\n" $((COLUMNS+14)) "$exit_symbol $last_command ⏳ $breakup"
    if [ $delay -ge 10000 -a $__window -ne $(getactivewindow) ]
    then
        notify-send -i $icon "CLI Ready" "$last_command ⏳ $breakup"
    fi
    unset __window
}

trap before_command DEBUG
PROMPT_COMMAND=after_command

# PDF optimiser. This requires that Ghostscript be installed.
pdfopt ()
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
rr ()
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

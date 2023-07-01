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

# Maximum line length of LaTeX output.
export max_print_line=1048576
export error_line=254
export half_error_line=238

export EDITOR=vim
export GIT_EDITOR=vim
export BAT_PAGER='less -iRF'

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
alias e='exec bash'
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

# View object files.
o ()
{
    [ ! -f "$1" ] && printf "Usage:\n  ${FUNCNAME[0]} <file>\n" >&2 && return 1
    (
        objdump -Cd "$1"
        readelf -p .rodata -x .rodata -x .data "$1" 2>/dev/null
    ) | $BAT_PAGER
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
        "" | *[^0-9]*) local length=20;;
        *) local length=$1;;
    esac
    for pattern in '0-9' 'A-Za-z' 'A-Za-z0-9' 'A-Za-z0-9!@#$*()'
    do
        tr -cd $pattern </dev/urandom | head -c $length
        printf "\n"
    done
}

# This is a representation of the icon used for Python Executor and LaTeX
# Renderer. I obtained it by saving a PNG image and then reading it using
# Python.
__data='\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00 \x00\x00\x00 \x08\x06\x00\x00\x00szz\xf4\x00\x00\x00bIDATx\x9c\xed\xd6\xb1\r\xc00\x08D\xd1X e\x12\xc6`=O\x90\x99X+\xd9\x00\xaa\x93\xa5\xe8\xd3R\xdc\x93\x8b3\xeb~\xf6%\x9e\xb7[\xba:\xdd\xcc\xda=\x00\x00\x00\x00\xfc\x1f\xe0\xdeGxD\xb4]\xad\x1e\x9f\x9e\x08\x00\x00\x00r@U-e@f\x9e\xbd\t\xc7&T\x03\x8e\xff\x05\x00\x00\x00\x0005\xe1\x07 \xde\t#axmy\x00\x00\x00\x00IEND\xaeB`\x82'

# A little hack to run Python programs without writing to a file. Open a
# Tkinter window and read the file. Execute the program when the Escape key is
# pressed. This should work on all single-threaded Python programs which do not
# create any Tkinter widgets. The random names should prevent name collisions.
P ()
{
    if [ $# -lt 1 ]
    then
        printf "Usage:\n" >&2
        printf "  ${FUNCNAME[0]} <file>\n" >&2
        return 1
    fi

    p -c "
import matplotlib.pyplot as _gKEFgMRsGkTgLsQsBojH
import platform as _kcvGDoKwwVmzVFPNNBzH
import idlelib.colorizer as _IFAYgQKFNUDWRMDyOcfZ
import idlelib.percolator as _kiZxwOhpBzEnmVHOeiaz
import tkinter as _ArFfEXZloCCjFNnmSwdw

def _sQIvYlfwvgZJnQNmxRyF(event):
    command = event.widget.get('1.0', _ArFfEXZloCCjFNnmSwdw.END)
    try:
        exec(command, globals(), globals())
    except Exception as e:
        print(e)

def _xtBzBMfnpdQGhwINyACP():
    root = _ArFfEXZloCCjFNnmSwdw.Tk()
    root.iconphoto(True, _ArFfEXZloCCjFNnmSwdw.PhotoImage(data=b'$__data'))
    root.title('Python Executor')
    if _kcvGDoKwwVmzVFPNNBzH.system() in {'Darwin', 'Windows'}:
        root.state('zoomed')
    else:
        root.attributes('-zoomed', True)

    text = _ArFfEXZloCCjFNnmSwdw.Text(root, bg='#333333', fg='#FFFFFF', insertbackground='#F0EC8C', selectbackground='#079486', selectforeground='#FFFFFF', inactiveselectbackground='#079486', font=('Cascadia Code', 13))
    text.insert('1.0', open('$1').read())
    text.focus_set()
    text.mark_set('insert', '1.0')
    text.bind('<Escape>', _sQIvYlfwvgZJnQNmxRyF)
    text.pack(expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    cdg = _IFAYgQKFNUDWRMDyOcfZ.ColorDelegator()
    cdg.tagdefs['COMMENT']    = {'foreground': '#889999', 'background': '#333333'}
    cdg.tagdefs['KEYWORD']    = {'foreground': '#F0E68C', 'background': '#333333'}
    cdg.tagdefs['BUILTIN']    = {'foreground': '#98FB98', 'background': '#333333'}
    cdg.tagdefs['STRING']     = {'foreground': '#FFA0A0', 'background': '#333333'}
    cdg.tagdefs['DEFINITION'] = {'foreground': '#98FB98', 'background': '#333333'}
    cdg.tagdefs['ERROR']      = {'foreground': '#000000', 'background': '#333333'}
    cdg.tagdefs['HIT']        = {'foreground': '#000000', 'background': '#333333'}
    _kiZxwOhpBzEnmVHOeiaz.Percolator(text).insertfilter(cdg)

    root.mainloop()

_gKEFgMRsGkTgLsQsBojH.close(_gKEFgMRsGkTgLsQsBojH.figure())
_xtBzBMfnpdQGhwINyACP()
"
}

# Just like the last one, this is a hack to render LaTeX expressions without
# creating a new file. Uses the parser that comes with Matplotlib.
L ()
{
    if [ $# -eq 0 ]
    then
        local bgcolour='#333333'
        local fgcolour='#FFFFFF'
    else
        local bgcolour='#FFFFFF'
        local fgcolour='#000000'
    fi

    MPLBACKEND=TkAgg p -c "
import matplotlib as _EhdhMmAprSRzwpUPoHvW
import matplotlib.backends.backend_tkagg as _hNzVCYEPlZTSmIqqKOhB
import matplotlib.figure as _WFHjDXaGDEVBLyVLsdmR
import platform as _kcvGDoKwwVmzVFPNNBzH
import tkinter as _ArFfEXZloCCjFNnmSwdw
import time as _HgyxeWRPXNtbhqWyVhlC

if '$bgcolour' == '#FFFFFF':
    _EhdhMmAprSRzwpUPoHvW.rcParams['savefig.transparent'] = True

def _trawgorDBwAQawMZniUb(text, hashes):
    lines = text.get('1.0', _ArFfEXZloCCjFNnmSwdw.END)
    hashes[0] = hashes[1]
    hashes[1] = hash(lines)
    if hashes[0] == hashes[1]:
        return

    for tag in text.tag_names():
        text.tag_remove(tag, '1.0', _ArFfEXZloCCjFNnmSwdw.END)
    lines = lines.split('\\n')
    for i, line in enumerate(lines, 1):
        if i == 1:
            text.tag_add('ctag', '1.0', '2.0')
            continue

        lo, hi = 0, -1
        while True:
            lo = line.find('$', hi + 1)
            if lo == -1:
                break
            hi = line.find('$', lo + 1)
            if hi == -1:
                hi = len(line) - 1
            text.tag_add('ltag', f'{i}.{lo}', f'{i}.{hi + 1}')
            lo = hi

def _sQIvYlfwvgZJnQNmxRyF(fig, text, entry, wrap_variable):
    try:
        size = int(entry.get())
        wrap = wrap_variable.get()
    except Exception as e:
        _tovFFPjGPBAdfDHOlVTr(fig, e)
    else:
        fig.texts = []
        fig.text(0.02, size / 700, text.get('2.0', _ArFfEXZloCCjFNnmSwdw.END).strip(), size=size, color='$fgcolour', wrap=wrap)
        fig.canvas.draw()

def _tovFFPjGPBAdfDHOlVTr(fig, e):
    fig.texts = []
    fig.text(0.02, 0.02, str(e), size=16, color='$fgcolour', fontname=_EhdhMmAprSRzwpUPoHvW.rcParams['mathtext.tt'])
    fig.canvas.draw()

def _xtBzBMfnpdQGhwINyACP():
    root = _ArFfEXZloCCjFNnmSwdw.Tk()
    root.iconphoto(True, _ArFfEXZloCCjFNnmSwdw.PhotoImage(data=b'$__data'))
    root.title('LaTeX Renderer')
    if _kcvGDoKwwVmzVFPNNBzH.system() in {'Darwin', 'Windows'}:
        root.state('zoomed')
    else:
        root.attributes('-zoomed', True)

    dpi = root.winfo_fpixels('1i')
    width = 0.7 * root.winfo_screenwidth() / dpi
    height = root.winfo_screenheight() / dpi
    fig = _WFHjDXaGDEVBLyVLsdmR.Figure(figsize=(width, height))
    fig.patch.set_facecolor('$bgcolour')
    root.report_callback_exception = lambda *args: _tovFFPjGPBAdfDHOlVTr(fig, args[1])
    canvas = _hNzVCYEPlZTSmIqqKOhB.FigureCanvasTkAgg(fig, master=root)
    canvas.draw()
    canvas.get_tk_widget().pack(side=_ArFfEXZloCCjFNnmSwdw.LEFT, anchor=_ArFfEXZloCCjFNnmSwdw.W, expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)
    canvas.get_default_filename = lambda *args: 'lr_' + _HgyxeWRPXNtbhqWyVhlC.strftime('%Y-%m-%d_%H-%M-%S') + '.pdf'

    nav_tb_frame = _ArFfEXZloCCjFNnmSwdw.Frame(master=root)
    nav_tb_frame.pack(side=_ArFfEXZloCCjFNnmSwdw.BOTTOM, anchor=_ArFfEXZloCCjFNnmSwdw.SE, expand=False, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)
    nav_tb = _hNzVCYEPlZTSmIqqKOhB.NavigationToolbar2Tk(canvas, nav_tb_frame)

    hashes = [None, None]
    text = _ArFfEXZloCCjFNnmSwdw.Text(root, bg='#333333', fg='#FFFFFF', insertbackground='#FFFFFF', selectbackground='#079486', selectforeground='#FFFFFF', inactiveselectbackground='#079486', font=('Cascadia Code', 13))
    greek_symbols = r'\$\\Alpha\\Beta\\Gamma\\Digamma\\Delta\\Epsilon\\Zeta\\Eta\\Theta\\Iota\\Kappa\\Lambda\\Mu\\Nu\\Xi\\Omicron\\Pi\\Rho\\Sigma\\Stigma\\Tau\\Upsilon\\Phi\\Chi\\Psi\\Omega\$ \$\\mathrm{\\alpha\\beta\\gamma\\digamma\\delta\\epsilon\\zeta\\eta\\theta\\vartheta\\iota\\kappa\\varkappa\\lambda\\mu\\nu\\xi\\omicron\\pi\\varpi\\rho\\varrho\\sigma\\varsigma\\stigma\\tau\\upsilon\\phi\\varphi\\chi\\psi\\omega}\$'
    text.insert('1.0', f'{greek_symbols}\\n')
    root.after(1000, text.focus_set)
    text.tag_config('ltag', background='#333333', foreground='#FFFF00')
    text.tag_config('ctag', background='#333333', foreground='#007FFF')
    text.tag_raise('sel')
    text.bind('<KeyRelease>', lambda event: _trawgorDBwAQawMZniUb(text, hashes))
    _trawgorDBwAQawMZniUb(text, hashes)
    text.bind('<Escape>', lambda event: _sQIvYlfwvgZJnQNmxRyF(fig, text, entry, wrap_variable))
    text.pack(side=_ArFfEXZloCCjFNnmSwdw.TOP, anchor=_ArFfEXZloCCjFNnmSwdw.NE, expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    entry = _ArFfEXZloCCjFNnmSwdw.Entry(root, bg='#333333', fg='#FFFFFF', insertbackground='#FFFFFF', font=('Cascadia Code', 13))
    entry.insert(0, '50')
    entry.bind('<Escape>', lambda event: _sQIvYlfwvgZJnQNmxRyF(fig, text, entry, wrap_variable))
    entry.pack(side=_ArFfEXZloCCjFNnmSwdw.BOTTOM, anchor=_ArFfEXZloCCjFNnmSwdw.SE, expand=False, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    wrap_variable = _ArFfEXZloCCjFNnmSwdw.BooleanVar()
    checkbutton = _ArFfEXZloCCjFNnmSwdw.Checkbutton(root, font=('Cascadia Code', 13), text=' Wrap Text', activebackground='#333333', activeforeground='#CCCCCC', bg='#333333', fg='#CCCCCC', selectcolor='#555555', variable=wrap_variable, command=lambda: _sQIvYlfwvgZJnQNmxRyF(fig, text, entry, wrap_variable))
    checkbutton.pack(side=_ArFfEXZloCCjFNnmSwdw.BOTTOM, anchor=_ArFfEXZloCCjFNnmSwdw.SE, expand=False, fill=_ArFfEXZloCCjFNnmSwdw.X)

    root.mainloop()

_xtBzBMfnpdQGhwINyACP()
"
}

# Given a target colour, make transparent all colours differing from it by
# `threshold1` or less, but don't touch colours differing from it by
# `threshold2` or more. The alpha (opacity) for colours in between will
# gradually change from 0 to 1.
T ()
{
    if [ $# -lt 6 ]
    then
        printf "Usage:\n" >&2
        printf "  ${FUNCNAME[0]} <file> <R> <G> <B> <threshold1> <threshold2>\n" >&2
        return 1
    fi

    p -c "
import matplotlib.pyplot as _gKEFgMRsGkTgLsQsBojH
import numpy as _YNbCrBdBmvMfWxWTPFeq
import PIL.Image as _qWonDbVEFZquydrdRtVd

def _xtBzBMfnpdQGhwINyACP():
    src = _YNbCrBdBmvMfWxWTPFeq.asarray(_qWonDbVEFZquydrdRtVd.open('$1').convert('RGBA')) / 255
    target = [$2, $3, $4]
    threshold = [$5, $6]

    diff = _YNbCrBdBmvMfWxWTPFeq.zeros(src[:, :, 3].shape)
    for i in range(3):
        diff += _YNbCrBdBmvMfWxWTPFeq.abs(src[:, :, i] - target[i])
    # diff /= _YNbCrBdBmvMfWxWTPFeq.amax(diff)
    diff /= 3
    diff = (diff - threshold[0]) / (threshold[1] - threshold[0])
    _YNbCrBdBmvMfWxWTPFeq.clip(diff, 0, 1, out=diff)
    dst = src.copy()
    dst[:, :, 3] = diff

    fig, ax = _gKEFgMRsGkTgLsQsBojH.subplots(1, 2)
    # ax[0].axis('off')
    ax[0].imshow(src)
    # ax[1].axis('off')
    ax[1].imshow(dst)

    _gKEFgMRsGkTgLsQsBojH.show()

    print('Type the name of the file to save the image to, and press Enter.')
    print('Pressing Enter without typing anything will cancel the operation.')
    fname = input('> ').strip()
    if not fname:
        print('Cancelled.')
        return

    _qWonDbVEFZquydrdRtVd.fromarray(_YNbCrBdBmvMfWxWTPFeq.uint8(dst * 255)).save(fname)

_gKEFgMRsGkTgLsQsBojH.close(_gKEFgMRsGkTgLsQsBojH.figure())
_xtBzBMfnpdQGhwINyACP()
"
}

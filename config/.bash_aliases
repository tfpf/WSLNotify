# ~/.bash_aliases

# WSL: Windows Subsystem for Linux.
running_on_WSL=$(grep -il microsoft /proc/version)

if [[ -n $running_on_WSL ]]
then

    # Setup for a virtual display using VcXsrv to run GUI apps. You may want to
    # install `x11-xserver-utils', `dconf-editor' and `dbus-x11', and create
    # the file `~/.config/dconf/user'. The first `DISPLAY' is for WSL, and the
    # second, for WSL2.
    export DISPLAY=localhost:0.0
    # export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
    export GDK_SCALE=1
    export LIBGL_ALWAYS_INDIRECT=1
    export XDG_RUNTIME_DIR=/tmp/runtime-tfpf

    # Run a PowerShell script without changing the global execution policy.
    alias psh='powershell.exe -ExecutionPolicy Bypass'

    # Compile programs written in C#.
    alias csc='/mnt/c/Windows/Microsoft.NET/Framework64/v4.0.30319/csc.exe'

    # For notifications, since `notify-send' does not work.
    alias notify-send='/mnt/c/Users/vpaij/Documents/projects/WSLNotify/WSLNotify/WSLNotify.exe'
    alias getactivewindow='/mnt/c/Users/vpaij/Documents/projects/WSLNotify/WSLNotify/WSLGetActiveWindow.exe'

    alias wp='/mnt/c/Users/vpaij/AppData/Local/Programs/Python/Python310/python.exe'

    # Create the virtual display.
    vcx ()
    {
        local vcxsrvpath='/mnt/c/Program Files/VcXsrv/vcxsrv.exe'
        local vcxsrvname=$(basename "$vcxsrvpath")
        ("$vcxsrvpath" -ac -clipboard -multiwindow -wgl & sleep 1 && pkill "$vcxsrvname") &> /dev/null
    }

    # Windows Explorer can open WSL folders, but the command must be invoked
    # after navigating to the target folder. Doing so directly will change the
    # environment variable `OLDPWD', which is undesirable. Hence, this is done
    # in a subshell.
    e ()
    {
        if [[ $# -lt 1 || ! -d "$1" ]]
        then
            printf "Usage:\n"
            printf "\t${FUNCNAME[0]} <directory>\n"
            return 1
        fi

        (cd "$1" && explorer.exe .)
    }

    # GVIM for Windows can open WSL files, but (like Windows Explorer), the
    # command must be invoked after navigating to the containing folder.
    g ()
    {
        if [[ $# -lt 1 || ! -f "$1" ]]
        then
            printf "Usage:\n"
            printf "\t${FUNCNAME[0]} <file>\n"
            return 1
        fi

        # https://tuxproject.de/projects/vim/ (64-bit Windows binaries)
        local gvimpath='/mnt/c/Users/vpaij/Downloads/gVim/gvim.exe'
        local gvimname=$(basename "$gvimpath")
        local filedir=$(dirname "$1")
        local filename=$(basename "$1")

        # Running the commands in a subshell causes two new processes (`bash'
        # and `gvim.exe', as the `ps' command tells me) to remain running for
        # as long as GVIM is kept open. Killing `gvim.exe' automatically
        # results in the termination of `bash' without affecting GVIM (probably
        # because it is a Windows application, which WSL does not have the
        # ability to close). That's what is done here.
        (cd "$filedir" && "$gvimpath" "$filename" & sleep 1 && pkill "$gvimname") &> /dev/null
    }
else
    alias g='gvim'
    alias getactivewindow='xdotool getactivewindow'
fi

export HISTTIMEFORMAT="[%F %T] "

export QT_LOGGING_RULES="qt5ct.debug=false"

# Some terminals exit only if the previous command was successful. This can be
# used to exit unconditionally.
alias bye='clear && exit'

# Some Linux distributions use swap space even when there is sufficient RAM
# available. This will reuce the swap affinity.
alias rs='cat /proc/sys/vm/swappiness && sudo sysctl vm.swappiness=10'

# Some sort of a system monitor.
alias F='watch -n 1 "grep MHz /proc/cpuinfo | nl -w 2"'
alias M='watch -n 0.1 free -ht'
alias s='watch -n 1 sensors'
alias top='top -d 1'

alias l='ls -lNX --color=auto --group-directories-first --time-style=long-iso'
alias la='ls -AhlNX --color=auto --group-directories-first --time-style=long-iso'
alias ls='ls -C --color=auto'
alias lt='ls -hlNrt --color=auto --group-directories-first --time-style=long-iso'

alias grep='grep --binary-files=without-match --color=auto'

alias pgrep='pgrep -il'

alias ps='ps a -c'

alias p='/usr/bin/python3 -B'
alias t='/usr/bin/python3 -m timeit'
alias pip='/usr/bin/python3 -m pip'

alias time='/usr/bin/time -f "\
$(printf "%*s" $COLUMNS " " | tr " " "-")
Real: %e s. User: %U s. Kernel: %S s.
Maximum RSS: %M kB." '

alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose '

# Pre-command for command timing. It will be called just before any command is
# executed.
before_command ()
{
    if [[ -z $CLI_ready ]]
    then
        return
    fi

    terminal_window_ID=$(getactivewindow)
    CLI_ready=""
    start_time=$(date +%s%3N)
}

# Post-command for command timing. It will be called just before the prompt is
# displayed (i.e. just after any command is executed).
after_command ()
{
    local exit_status=$?
    if [[ -n $CLI_ready ]]
    then
        return
    fi

    local finish_time=$(date +%s%3N)
    local delay=$((finish_time-start_time))
    unset start_time
    CLI_ready=1

    if [[ $delay -le 10000 || $terminal_window_ID -eq $(getactivewindow) ]]
    then
        return
    fi

    local milliseconds=$((delay%1000))
    local seconds=$((delay/1000%60))
    local minutes=$((delay/60000%60))
    local hours=$((delay/3600000))
    local command=$(history 1 | sed 's/^[^]]*\] //')

    local breakup=""
    [[ $hours -gt 0 ]] && breakup="$hours h "
    [[ $hours -gt 0 || $minutes -gt 0 ]] && breakup="${breakup}$minutes m "
    breakup="${breakup}$seconds s $milliseconds ms"

    if [[ $exit_status -eq 0 ]]
    then
        local exit_symbol="✓"
        local icon=dialog-information
    else
        local exit_symbol="✗"
        local icon=dialog-error
    fi
    notify-send -i $icon "CLI Ready" "$command · $breakup"

    # The tick, cross and middle dot symbols may have to be treated as
    # multi-byte characters, depending on the shell.
    printf "%*s\n" $((COLUMNS+3)) "$exit_symbol $command · $breakup"
}

CLI_ready=1
trap before_command DEBUG
PROMPT_COMMAND=after_command

# Commit and push changes to the master branch of a GitHub repository.
push ()
{
    if [[ $# -lt 2 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} \"commit message\" file1 [file2] [file3] [...]\n"
        return 1
    fi

    local args=( "$@" )
    local files=("${args[@]:1}")

    git add ${files[*]}
    git commit -m "$1"
    git push origin master
}

# PDF optimiser. This requires that `ghostscript' be installed.
pdfopt ()
{
    if [[ $# -lt 2 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} input_file.pdf output_file.pdf [resolution]\n"
        return 1
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

# Random string generator.
rr ()
{
    if [[ "$1" =~ ^[0-9]+$ ]]
    then
        local length="$1"
    else
        local length=20
    fi

    printf "$(tr -cd '0-9' < /dev/urandom | head -c $length)\n"
    printf "$(tr -cd 'A-Za-z' < /dev/urandom | head -c $length)\n"
    printf "$(tr -cd 'A-Za-z0-9' < /dev/urandom | head -c $length)\n"
    printf "$(tr -cd 'A-Za-z0-9!@#$*()' < /dev/urandom | head -c $length)\n"
}

icon_data='\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x14\x00\x00\x00\x14\x08\x06\x00\x00\x00\x8d\x89\x1d\r\x00\x00\x00gIDAT8\x11\xad\xc1A\x11\x000\x10\x840\xf0/\x9a\x1a\xd8\xd7M\x13+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06\x81\xf8H >\x12\x88\x8f\x04\xe2#+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x86\x07\xc6\x97D\x01a\xc1\x9d\x0b\x00\x00\x00\x00IEND\xaeB`\x82'

# A little hack to run Python programs without writing to a file. Open a
# Tkinter window and read the file. Execute the program when the Escape key is
# pressed. This should work on all single-threaded Python programs which do not
# create any Tkinter widgets. The random names should prevent name collisions.
P ()
{
    if [[ $# -lt 1 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} <file>\n"
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
    root.iconphoto(True, _ArFfEXZloCCjFNnmSwdw.PhotoImage(data=b'$icon_data'))
    root.title('Python Executor')
    if _kcvGDoKwwVmzVFPNNBzH.system() in {'Darwin', 'Windows'}:
        root.state('zoomed')
    else:
        root.attributes('-zoomed', True)

    text = _ArFfEXZloCCjFNnmSwdw.Text(root, bg='#333333', fg='#CCCCCC', insertbackground='#CCCCCC', font=('Cascadia Code', 13))
    text.insert('1.0', open('$1').read())
    text.focus_set()
    text.mark_set('insert', '1.0')
    text.bind('<Escape>', _sQIvYlfwvgZJnQNmxRyF)
    text.pack(expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    cdg = _IFAYgQKFNUDWRMDyOcfZ.ColorDelegator()
    cdg.tagdefs['COMMENT']    = {'foreground': '#007FFF', 'background': '#333333'}
    cdg.tagdefs['KEYWORD']    = {'foreground': '#00FF00', 'background': '#333333'}
    cdg.tagdefs['BUILTIN']    = {'foreground': '#FFFF00', 'background': '#333333'}
    cdg.tagdefs['STRING']     = {'foreground': '#FF7F00', 'background': '#333333'}
    cdg.tagdefs['DEFINITION'] = {'foreground': '#00FFFF', 'background': '#333333'}
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
    MPLBACKEND=TkAgg p -c "
import matplotlib as _EhdhMmAprSRzwpUPoHvW
import matplotlib.backends.backend_tkagg as _hNzVCYEPlZTSmIqqKOhB
import matplotlib.figure as _WFHjDXaGDEVBLyVLsdmR
import platform as _kcvGDoKwwVmzVFPNNBzH
import tkinter as _ArFfEXZloCCjFNnmSwdw
import time as _HgyxeWRPXNtbhqWyVhlC

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

def _sQIvYlfwvgZJnQNmxRyF(fig, text, entry):
    fig.texts = []
    try:
        size_and_wrap = entry.get().split()
        if len(size_and_wrap) >= 2:
            size, wrap = size_and_wrap[: 2]
        else:
            size = size_and_wrap[0]
            wrap = False
        size = int(size)
        fig.text(0.02, size / 700, text.get('2.0', _ArFfEXZloCCjFNnmSwdw.END).strip(), size=size, color='#CCCCCC', wrap=int(wrap))
    except Exception as e:
        print(e)
    fig.canvas.draw()

def _tovFFPjGPBAdfDHOlVTr(fig, *args):
    fig.texts = []
    fig.text(0.02, 0.02, str(args[1]), size=16, color='#CCCCCC', fontname=_EhdhMmAprSRzwpUPoHvW.rcParams['mathtext.tt'])
    fig.canvas.draw()

def _xtBzBMfnpdQGhwINyACP():
    root = _ArFfEXZloCCjFNnmSwdw.Tk()
    root.iconphoto(True, _ArFfEXZloCCjFNnmSwdw.PhotoImage(data=b'$icon_data'))
    root.title('LaTeX Renderer')
    if _kcvGDoKwwVmzVFPNNBzH.system() in {'Darwin', 'Windows'}:
        root.state('zoomed')
    else:
        root.attributes('-zoomed', True)

    fig = _WFHjDXaGDEVBLyVLsdmR.Figure(figsize=(14, 12))
    fig.patch.set_facecolor('#333333')
    root.report_callback_exception = lambda *args: _tovFFPjGPBAdfDHOlVTr(fig, *args)
    canvas = _hNzVCYEPlZTSmIqqKOhB.FigureCanvasTkAgg(fig, master=root)
    canvas.draw()
    canvas.get_tk_widget().pack(side=_ArFfEXZloCCjFNnmSwdw.LEFT, anchor=_ArFfEXZloCCjFNnmSwdw.W, expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)
    canvas.get_default_filename = lambda *args: 'lr_' + _HgyxeWRPXNtbhqWyVhlC.strftime('%Y-%m-%d_%H-%M-%S') + '.pdf'

    nav_tb_frame = _ArFfEXZloCCjFNnmSwdw.Frame(master=root)
    nav_tb_frame.pack(side=_ArFfEXZloCCjFNnmSwdw.BOTTOM, anchor=_ArFfEXZloCCjFNnmSwdw.SE, expand=False, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)
    nav_tb = _hNzVCYEPlZTSmIqqKOhB.NavigationToolbar2Tk(canvas, nav_tb_frame)

    hashes = [None, None]
    text = _ArFfEXZloCCjFNnmSwdw.Text(root, bg='#333333', fg='#CCCCCC', insertbackground='#CCCCCC', font=('Cascadia Code', 13))
    greek_symbols = r'\$\\Alpha\\Beta\\Gamma\\Delta\\Epsilon\\Zeta\\Eta\\Theta\\Iota\\Kappa\\Lambda\\Mu\\Nu\\Xi\\Omicron\\Pi\\Rho\\Sigma\\Tau\\Upsilon\\Phi\\Chi\\Psi\\Omega\$ \$\\alpha\\beta\\gamma\\delta\\epsilon\\zeta\\eta\\theta\\vartheta\\iota\\kappa\\varkappa\\lambda\\mu\\nu\\xi\\omicron\\pi\\varpi\\rho\\varrho\\sigma\\varsigma\\tau\\upsilon\\phi\\varphi\\chi\\psi\\omega\$'
    text.insert('1.0', f'{greek_symbols}\\n')
    root.after(1000, text.focus_set)
    text.tag_config('ltag', background='#333333', foreground='#FFFF00')
    text.tag_config('ctag', background='#333333', foreground='#007FFF')
    text.tag_raise('sel')
    text.bind('<KeyRelease>', lambda event: _trawgorDBwAQawMZniUb(text, hashes))
    _trawgorDBwAQawMZniUb(text, hashes)
    text.bind('<Escape>', lambda event: _sQIvYlfwvgZJnQNmxRyF(fig, text, entry))
    text.pack(side=_ArFfEXZloCCjFNnmSwdw.TOP, anchor=_ArFfEXZloCCjFNnmSwdw.NE, expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    entry = _ArFfEXZloCCjFNnmSwdw.Entry(root, bg='#333333', fg='#CCCCCC', insertbackground='#CCCCCC', font=('Cascadia Code', 13))
    entry.insert(0, '50 0')
    entry.bind('<Escape>', lambda event: _sQIvYlfwvgZJnQNmxRyF(fig, text, entry))
    entry.pack(side=_ArFfEXZloCCjFNnmSwdw.BOTTOM, anchor=_ArFfEXZloCCjFNnmSwdw.SE, expand=False, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    root.mainloop()

_xtBzBMfnpdQGhwINyACP()
"
}

# Given a target colour, make transparent all colours differing from it by
# `threshold1' or less, but don't touch colours differing from it by
# `threshold2' or more. The alpha (opacity) for colours in between will
# gradually change from 0 to 1.
T ()
{
    if [[ $# -lt 6 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} <file> <R> <G> <B> <threshold1> <threshold2>\n"
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
    out = input('> ')
    if not out or out.isspace():
        print('Cancelled.')
        return

    _qWonDbVEFZquydrdRtVd.fromarray(_YNbCrBdBmvMfWxWTPFeq.uint8(dst * 255)).save(out)

_gKEFgMRsGkTgLsQsBojH.close(_gKEFgMRsGkTgLsQsBojH.figure())
_xtBzBMfnpdQGhwINyACP()
"
}

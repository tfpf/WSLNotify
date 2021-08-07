# ~/.bash_aliases

# WSL: set up a virtual display using VcXsrv to run Qt and other GUI apps. Note
# that you may need to install `x11-xserver-utils', `dconf-editor' and
# `dbus-x11', and create the file `~/.config/dconf/user'.
export DISPLAY=localhost:0.0
export GDK_SCALE=1
export LIBGL_ALWAYS_INDIRECT=1
export XDG_RUNTIME_DIR=/tmp/runtime-tfpf
alias vcx='/mnt/c/Program\ Files/VcXsrv/xlaunch.exe'

# WSL: prevent exit failure if the previous command failed.
alias exit='clear && exit'

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

# Run a PowerShell script without globally changing the execution policy.
alias psh='powershell.exe -ExecutionPolicy Bypass'

alias p='/usr/local/bin/python3.8 -B'
alias t='/usr/local/bin/python3.8 -m timeit'
alias pip='/usr/local/bin/python3.8 -m pip'

alias time='/usr/bin/time -f "----------\n%e s, %M kB (max)\n%I FS inputs, %O FS outputs, %W swaps\n%F major PFs, %R minor PFs\n----------\n" '

alias vg='valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose '

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

# Windows Explorer can open WSL folders, but the command must be invoked after
# navigating to the target folder. Doing so directly will change the
# environment variable `OLDPWD', which is undesirable. Hence, this is done in a
# subshell.
e ()
{
    if [[ $# -lt 1 || ! -d "$1" ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} dirpath\n"
        return 1
    fi

    (cd "$1" && explorer.exe .)
}

# GVIM for Windows can open WSL files, but (like Windows Explorer), the command
# must be invoked after navigating to the containing folder.
g ()
{
    if [[ $# -lt 1 || ! -f "$1" ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} filepath\n"
        return 1
    fi

    local gvimpath='/mnt/c/Program Files (x86)/Vim/vim82/gvim.exe'
    local gvimname=$(basename "$gvimpath")
    local filedir=$(dirname "$1")
    local filename=$(basename "$1")

    # Running the commands in a subshell causes two new processes (`bash' and
    # `gvim.exe', as the `ps' command tells me) to remain running for as long
    # as GVIM is kept open. Killing `gvim.exe' automatically results in the
    # termination of `bash' without affecting GVIM (probably because it is a
    # Windows application, which WSL does not have the ability to close).
    # That's what is done here.
    (cd "$filedir" && "$gvimpath" "$filename" & sleep 1 && pkill "$gvimname") 2> /dev/null
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

icon_data='\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x14\x00\x00\x00\x14\x08\x06\x00\x00\x00\x8d\x89\x1d\r\x00\x00\x00gIDAT8\x11\xad\xc1A\x11\x000\x10\x840\xf0/\x9a\x1a\xd8\xd7M\x13+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06\x81\xf8H >\x12\x88\x8f\x04\xe2#+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x06+.\xd4\x18\xac\xb8Pc\xb0\xe2B\x8d\xc1\x8a\x0b5\x86\x07\xc6\x97D\x01a\xc1\x9d\x0b\x00\x00\x00\x00IEND\xaeB`\x82'

# A little hack to run Python programs without writing to a file. Open a
# Tkinter window and read the file. Execute the program when the F1 key is
# pressed. This should work on all single-threaded Python programs which do not
# create any Tkinter widgets. The random names should prevent name collisions.
P ()
{
    if [[ $# -lt 1 ]]
    then
        printf "Usage:\n"
        printf "\t${FUNCNAME[0]} file\n"
        return 1
    fi

    p -c "
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
    root.attributes('-zoomed', True)

    text = _ArFfEXZloCCjFNnmSwdw.Text(root, bg='#333333', fg='#CCCCCC', insertbackground='#CCCCCC', font=('Cascadia Code', 13))
    text.insert('1.0', open('$1').read())
    text.focus_set()
    text.mark_set('insert', '1.0')
    text.bind('<F1>', _sQIvYlfwvgZJnQNmxRyF)
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

_xtBzBMfnpdQGhwINyACP()
"
}

# Just like the last one, this is a hack to render LaTeX expressions without
# creating a new file. Uses the Tex parser that comes with Matplotlib.
L ()
{
    p -c "
import matplotlib as _EhdhMmAprSRzwpUPoHvW; _EhdhMmAprSRzwpUPoHvW.use('TkAgg')
import matplotlib.backends.backend_tkagg as _hNzVCYEPlZTSmIqqKOhB
import matplotlib.figure as _WFHjDXaGDEVBLyVLsdmR
import time as _FLnhAHSmRHaLdieVRHGq
import tkinter as _ArFfEXZloCCjFNnmSwdw

def _sQIvYlfwvgZJnQNmxRyF(fig, text, entry):
    fig.texts = []
    try:
        size_and_wrap = entry.get().split()
        if len(size_and_wrap) >= 2:
            size, wrap = size_and_wrap[: 2]
        else:
            size = size_and_wrap[0]
            wrap = False
        fig.text(0, 0, text.get('1.0', _ArFfEXZloCCjFNnmSwdw.END), size=int(size), color='#CCCCCC', wrap=int(wrap))
    except Exception as e:
        print(e)
    fig.canvas.draw()

def _xtBzBMfnpdQGhwINyACP():
    root = _ArFfEXZloCCjFNnmSwdw.Tk()
    root.iconphoto(True, _ArFfEXZloCCjFNnmSwdw.PhotoImage(data=b'$icon_data'))
    root.title('LaTeX Renderer')
    root.attributes('-zoomed', True)

    fig = _WFHjDXaGDEVBLyVLsdmR.Figure(figsize=(14, 12))
    fig.patch.set_facecolor('#333333')
    root.bind('<F5>', lambda event: fig.savefig(_EhdhMmAprSRzwpUPoHvW.rcParams['savefig.directory'] + f'lr_{_FLnhAHSmRHaLdieVRHGq.time_ns()}.svg'))
    canvas = _hNzVCYEPlZTSmIqqKOhB.FigureCanvasTkAgg(fig, master=root)
    canvas.draw()
    canvas.get_tk_widget().pack(side=_ArFfEXZloCCjFNnmSwdw.LEFT, anchor=_ArFfEXZloCCjFNnmSwdw.W, expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    text = _ArFfEXZloCCjFNnmSwdw.Text(root, bg='#333333', fg='#CCCCCC', insertbackground='#CCCCCC', font=('Cascadia Code', 13))
    root.after(1000, text.focus_set)
    text.bind('<F1>', lambda event: _sQIvYlfwvgZJnQNmxRyF(fig, text, entry))
    text.pack(side=_ArFfEXZloCCjFNnmSwdw.TOP, anchor=_ArFfEXZloCCjFNnmSwdw.NE, expand=True, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    entry = _ArFfEXZloCCjFNnmSwdw.Entry(root, bg='#333333', fg='#CCCCCC', insertbackground='#CCCCCC', font=('Cascadia Code', 13))
    entry.insert(0, '100 0')
    entry.bind('<F1>', lambda event: _sQIvYlfwvgZJnQNmxRyF(fig, text, entry))
    entry.pack(side=_ArFfEXZloCCjFNnmSwdw.BOTTOM, anchor=_ArFfEXZloCCjFNnmSwdw.SE, expand=False, fill=_ArFfEXZloCCjFNnmSwdw.BOTH)

    root.mainloop()

_xtBzBMfnpdQGhwINyACP()
"
}

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

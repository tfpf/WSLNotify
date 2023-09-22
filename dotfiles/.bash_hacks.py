#! /usr/bin/env python3

import idlelib.colorizer as ic
import idlelib.percolator as ip
import matplotlib as mpl
import matplotlib.backends.backend_tkagg as mbtkagg
import matplotlib.figure as mfigure
import matplotlib.pyplot as plt
import numpy as np
import pathlib
import PIL.Image as Image
import platform
import tkinter as tk
import tkinter.ttk as ttk
import sys
import time
import traceback


data = bytes.fromhex(
    '89504e470d0a1a0a0000000d4948445200000020000000200806000000737a7af40000006249444154789cedd6b10dc0300844d158206512c'
    '6603d4f9099582bd900aa93a5e8d352dc938b33eb7ef6259eb75bba3addccda3d00000000fc1fe0de477844b45dad1e9f9e08000000724055'
    '2d6540669ebd09c72654038eff05000000003035e10720de092361786d790000000049454e44ae426082'
)
greek = (
    r'$\Alpha\Beta\Gamma\Digamma\Delta\Epsilon\Zeta\Eta\Theta\Iota\Kappa\Lambda\Mu\Nu\Xi\Omicron\Pi\Rho\Sigma\Stigma'
    r'\Tau\Upsilon\Phi\Chi\Psi\Omega$ $\mathrm{\alpha\beta\gamma\digamma\delta\epsilon\zeta\eta\theta\vartheta\iota'
    r'\kappa\varkappa\lambda\mu\nu\xi\omicron\pi\varpi\rho\varrho\sigma\varsigma\stigma\tau\upsilon\phi\varphi\chi\psi'
    r'\omega}$'
)
system = platform.system()


# Matplotlib will use a Tk-based backend if we use Tkinter and fail later if
# the user's preferred backend is different. To avoid this, make Matplotlib
# load the latter backend now.
plt.close(plt.figure())


class LatexRenderer(tk.Tk):
    """
Render LaTeX expressions without creating a new file. Use the parser that comes
with Matplotlib.

:param args: Enable light mode if non-empty, and dark mode otherwise.
    """

    def __init__(self, *args):
        super().__init__()
        if args:
            self.bg = '#FFFFFF'
            self.fg = '#000000'
            plt.rc('savefig', transparent=True)
        else:
            self.bg = '#333333'
            self.fg = '#FFFFFF'

        self.iconphoto(True, tk.PhotoImage(data=data))
        self.title('LaTeX Renderer')
        if system in {'Darwin', 'Windows'}:
            self.state('zoomed')
        else:
            self.attributes('-zoomed', True)

        # Figure.
        dpi = self.winfo_fpixels('1i')
        width = 0.7 * self.winfo_screenwidth() / dpi
        height = self.winfo_screenheight() / dpi
        self.fig = mfigure.Figure(figsize=(width, height))
        self.fig.patch.set_facecolor(self.bg)
        self.report_callback_exception = self.render
        canvas = mbtkagg.FigureCanvasTkAgg(self.fig, self)
        canvas.draw()
        canvas.get_tk_widget().pack(side=tk.LEFT, anchor=tk.W, expand=True, fill=tk.BOTH)
        canvas.get_default_filename = lambda *args: 'lr_' + time.strftime('%Y-%m-%d_%H-%M-%S')

        # Navigation toolbar.
        nav_tb_frame = tk.Frame(self)
        nav_tb_frame.pack(side=tk.BOTTOM, anchor=tk.SE, expand=False, fill=tk.BOTH)
        nav_tb = mbtkagg.NavigationToolbar2Tk(canvas, nav_tb_frame)

        # Space to enter LaTeX source.
        self.code = tk.Text(
            self, bg='#333333', fg='#FFFFFF', insertbackground='#F0EC8C', selectbackground='#079486',
            selectforeground='#FFFFFF', inactiveselectbackground='#079486', font=('Cascadia Code', 13)
        )
        self.code.insert('1.0', greek + '\n')
        self.after(0, self.code.focus_set)
        self.code.tag_config('ltag', background='#333333', foreground='#FFFF00')
        self.code.tag_config('ctag', background='#333333', foreground='#007FFF')
        self.code.tag_raise(tk.SEL)
        self.code.bind('<KeyRelease>', self.colour)
        self.colour()
        self.code.bind('<Escape>', self.render)
        self.code.pack(side=tk.TOP, anchor=tk.NE, expand=True, fill=tk.BOTH)

        # Space to enter the font size.
        self.size = tk.Entry(
            self, bg='#333333', fg='#FFFFFF', insertbackground='#F0EC8C', selectbackground='#079486',
            selectforeground='#FFFFFF', font=('Cascadia Code', 13)
        )
        self.size.insert(0, '50')
        self.size.bind('<Escape>', self.render)
        self.size.pack(side=tk.BOTTOM, anchor=tk.SE, expand=False, fill=tk.BOTH)

        self.wrap = tk.BooleanVar(self)
        wrapbtn = tk.Checkbutton(
            self, font=('Cascadia Code', 13), text=' Wrap Text', activebackground='#333333',
            activeforeground='#CCCCCC', bg='#333333', fg='#CCCCCC', selectcolor='#555555', variable=self.wrap,
            command=self.render
        )
        wrapbtn.pack(side=tk.BOTTOM, anchor=tk.SE, expand=False, fill=tk.X)

        self.typeface = tk.StringVar(self)
        typefacecbox = ttk.Combobox(
            self, font=('Cascadia Code', 13), state='readonly', textvariable=self.typeface,
            values=('Cochineal', 'Cascadia Code', 'Angelic')
        )
        self.option_add('*TCombobox*Listbox.font', ('Cascadia Code', 13))
        typefacecbox.current(0)
        typefacecbox.bind('<<ComboboxSelected>>', self.render)
        typefacecbox.pack(side=tk.BOTTOM, anchor=tk.SE, expand=False, fill=tk.X)

        self.mainloop()

    def colour(self, *args, hashes=[0, 0]):
        """
Apply syntax highlighting. Highlight everything between a pair of dollar signs.

:param args: Ignored.
:param hashes: List of the current and previous hashes of the source.
        """
        lines = self.code.get('1.0', tk.END)

        # To ensure that the same object is referenced each time this function
        # is called, do not create a new object. Instead, modify the existing
        # object.
        (hashes[0], hashes[1]) = (hashes[1], hash(lines))
        if hashes[0] == hashes[1]:
            return
        for tag in self.code.tag_names():
            self.code.tag_remove(tag, '1.0', tk.END)

        # The first line is always ignored. Mark it as a comment.
        self.code.tag_add('ctag', '1.0', '2.0')

        # Apply syntax highlighting on the remaining lines.
        lines = lines.split('\n')[1 :]
        for (i, line) in enumerate(lines, 2):
            (lo, hi) = (0, -1)
            while True:
                if (lo := line.find('$', hi + 1)) == -1:
                    break
                if (hi := line.find('$', lo + 1)) == -1:
                    hi = len(line) - 1
                self.code.tag_add('ltag', f'{i}.{lo}', f'{i}.{hi + 1}')
                lo = hi

    def render(self, *args):
        """
Render LaTeX expressions in the figure.

:param args: Used to determine how the function was called.
        """
        self.fig.texts = []
        if args and args[0] is ValueError:
            self.fig.text(
                0.02, 0.02, str(args[1]), size=16, wrap=True, color=self.fg, fontname=mpl.rcParams['mathtext.tt']
            )
            self.fig.canvas.draw()
            return
        try:
            size = int(self.size.get())
        except ValueError:
            size = 50
        plt.rc('font', family=self.typeface.get())
        wrap = self.wrap.get()
        text = self.code.get('2.0', tk.END).strip()
        self.fig.text(0, 0, text, size=size, wrap=wrap, color=self.fg, va='bottom')
        self.fig.canvas.draw()


class PythonExecutor(tk.Tk):
    """
Execute Python programs without creating a new file. Use Tkinter to accept the
Python source. As long as the entered source is single-threaded and does not
create any Tkinter widgets, this should work well.

:param fname: File whose contents should be used as the source.
:param args: Ignored.
    """

    def __init__(self, fname, *args):
        super().__init__()
        with open(fname) as fhandle:
            content = fhandle.read()

        # Make it possible to find Python files in the working directory.
        # (Ordinarily, the interpreter can't do so because the working
        # directory is probably not the directory this file is in.)
        sys.path.append(str(pathlib.Path(fname).resolve().parent))

        self.iconphoto(True, tk.PhotoImage(data=data))
        self.title('Python Executor')
        if system in {'Darwin', 'Windows'}:
            self.state('zoomed')
        else:
            self.attributes('-zoomed', True)

        # Space to enter Python source.
        self.code = tk.Text(
            self, bg='#333333', fg='#FFFFFF', insertbackground='#F0EC8C', selectbackground='#079486',
            selectforeground='#FFFFFF', inactiveselectbackground='#079486', font=('Cascadia Code', 13)
        )
        self.code.insert('1.0', content)
        self.code.focus_set()
        self.code.mark_set(tk.INSERT, '1.0')
        self.code.bind('<Escape>', self.exec)
        self.code.pack(expand=True, fill=tk.BOTH)

        delegator = ic.ColorDelegator()
        delegator.tagdefs['COMMENT']    = {'foreground': '#889999', 'background': '#333333'}
        delegator.tagdefs['KEYWORD']    = {'foreground': '#F0E68C', 'background': '#333333'}
        delegator.tagdefs['BUILTIN']    = {'foreground': '#98FB98', 'background': '#333333'}
        delegator.tagdefs['STRING']     = {'foreground': '#FFA0A0', 'background': '#333333'}
        delegator.tagdefs['DEFINITION'] = {'foreground': '#98FB98', 'background': '#333333'}
        delegator.tagdefs['ERROR']      = {'foreground': '#000000', 'background': '#333333'}
        delegator.tagdefs['HIT']        = {'foreground': '#000000', 'background': '#333333'}
        ip.Percolator(self.code).insertfilter(delegator)

        self.mainloop()

    def exec(self, *args):
        """
Execute the entered source.

:param args: Ignored.
        """
        text = self.code.get('1.0', tk.END)
        try:
            exec(text)
        except Exception:
            print(traceback.format_exc())


class TransparentMaker:
    """
Make certain shades in an image transparent.

:param fname: File to use as the image.
:param args: Colour and threshold information.

`args` is split into `r`, `g`, `b`, `upper` and `lower`. (All must be numbers
in [0, 1].) Colours differing from (`r`, `g`, `b`) by `lower` or less will be
made transparent; those differing from (`r`, `g`, `b`) by `upper` or more will
be left opaque. Those which differ by an amount between `lower` and `upper`
will be given alpha values between 0 and 1, calculated using a linear
transformation.
    """

    def __init__(self, fname, *args):
        (r, g, b, lower, upper) = map(float, args)
        src = np.asarray(Image.open(fname).convert('RGBA')) / 255
        np.abs(src[:, :, 0] - r)
        diff = (np.abs(src[:, :, 0] - r) + np.abs(src[:, :, 1] - g) + np.abs(src[:, :, 2] - b)) / 3
        np.clip((diff - lower) / (upper - lower), 0, 1, out=diff)
        dst = src.copy()
        dst[:, :, 3] = diff
        (fig, axs) = plt.subplots(1, 2)
        axs[0].imshow(src)
        axs[1].imshow(dst)
        plt.show()
        fname = input('Output file name? ').strip()
        if fname:
            Image.fromarray(np.uint8(dst * 255)).save(fname)


classes = {
    'L': LatexRenderer,
    'P': PythonExecutor,
    'T': TransparentMaker,
}


def main():
    if len(sys.argv) <= 1 or sys.argv[1] not in classes:
        return
    classes[sys.argv[1]](*sys.argv[2 :])


if __name__ == '__main__':
    main()

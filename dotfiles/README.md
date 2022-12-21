All of these files are supposed to be placed in the user's `HOME` directory.
The command
```
cp -rT . $HOME
```
will do just that. I am not responsible if this borks your system.

# Notes
* `.bashrc` is included here only for completeness. It shouldn't be necessary
  to replace the one which comes with your Linux distribution.
* An hourglass is printed by the command timer in `.bash_aliases`; if it is not
  rendered properly, `sudo apt install fonts-noto` should fix the problem.

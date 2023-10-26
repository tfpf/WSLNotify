All of these files are supposed to be placed in the user's `HOME` directory.
The command
```
cp -rT . $HOME
```
will do just that. I am not responsible if this borks your system. (It is better to just symlink the files.)

# Notes
* `.bashrc` is included here to show off the `envarmunge` function. It shouldn't be necessary to replace the `.bashrc`
  which comes with your Linux distribution.

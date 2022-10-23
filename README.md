# Native Windows Notifications for WSL
`notify-send` doesn't work on WSL. `WSLNotify.exe` may be used instead. You can
grab it from the
[latest release](https://github.com/tfpf/WSLNotify/releases/latest).

The following commands were run in Bash on Windows Terminal after navigating to
the directory containing `WSLNotify.exe`. (If you use Windows Command Prompt,
type `WSLNotify` instead of `./WSLNotify.exe` while entering these commands.)

```
./WSLNotify.exe "Summary Goes Here"
```
![summary](WSLNotify/gallery/1_summary.png)

```
./WSLNotify.exe "Summary Goes Here" "Body goes here"
```
![summarybody](WSLNotify/gallery/2_summary_and_body.png)

```
./WSLNotify.exe -i "dialog-information" "Good News" "Something good happened"
```
![information](WSLNotify/gallery/3_information.png)

```
./WSLNotify.exe -i "dialog-warning" "News" "Something happened"
```
![warning](WSLNotify/gallery/4_warning.png)

```
./WSLNotify.exe -i "dialog-error" "Bad News" "Something bad happened"
```
![error](WSLNotify/gallery/5_error.png)

As of now, only the `-i` option is supported, and only for the three stock
icons seen above. Support for the `-u` (for urgency) and `-t` (for expire time)
options may never be added, because Windows notification display times are
based on system accessibility settings.

## Use Case
I created this package so that my command timer would also work on WSL. On
GNU/Linux, if you add the following to `~/.bashrc` (or perhaps
`~/.bash_aliases`):
```bash
before_command ()
{
    if [[ -z $CLI_ready ]]
    then
        return
    fi

    CLI_ready=""
}

after_command ()
{
    CLI_ready=1
    notify-send "Command Complete"
}

CLI_ready=1
trap before_command DEBUG
PROMPT_COMMAND=after_command
```
you will get a notification every time a terminal command gets completed. With
a little more work, you can make it so that the notification reports the
elapsed time if the terminal is not the currently active window. To emulate the
same behaviour on WSL (which behaves like a headless system, whereby
notifications and active windows are meaningless), Windows notifications and
Windows window IDs can be used. With a few tricks (using
[`WSLNotify.exe`](https://github.com/tfpf/WSLNotify/releases/latest) and
[`WSLGetActiveWindow.exe`](https://github.com/tfpf/WSLNotify/releases/latest),
as seen in [`dotfiles/.bash_aliases`](dotfiles/.bash_aliases)), the timer works
seamlessly on GNU/Linux and WSL both.

## Known Bugs
* Hovering the mouse over the system tray icon after the application has
returned makes the notification disappear.
* Multiple notifications fill up the system tray with the application icon.

# Environment-Agnostic Configuration Files
`dotfiles` contains my configuration files for Bash, Zsh and GVIM (and some other
stuff). These can be used on GNU/Linux or WSL without making any changes
whatsoever. Having identical files for both means I don't have to spend time
setting up my environment.

There are a few nifty hacks implemented.

## Command Timer
As mentioned above. If the terminal in which a command was executed is not the
active window when the execution is complete, a notification is sent.

## Python Executor
Run Python programs without writing a new file.

## LaTeX Renderer
Render mathematical expressions written in a small subset of LaTeX (the subset
supported by Matplotlib) alongside the code. Basically, a crude version of
Overleaf.

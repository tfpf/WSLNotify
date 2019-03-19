# 8-length tab is too much
# change the default to 4
tabs -4

# a neat Terminal prompt, enclosed by square brackets
# uses ANSI escape sequences to show colours
# green user name: \[\033[01;32m\]\u\[\033[00m\]
# blue directory name: \[\033[01;34m\]\W\[\033[00m\]
# this is for Linux Mint; you may have to modify it for your distribution
PS1='${debian_chroot:+($debian_chroot)}[\[\033[01;32m\]\u\[\033[00m\]@\h \[\033[01;34m\]\W\[\033[00m\]]\$ '

# if you have installed undistract-me, add these lines to .bashrc
# so that after a bash command completes execution, a notification is sent
. /usr/share/undistract-me/long-running.bash
notify_when_long_running_commands_finish_install

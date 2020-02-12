# .bashrc file
# Based on the excellent introduction by Balaji S. Srinivasan
# (balajis@stanford.edu)
#
# (Modified for my own needs and wants)
#
# Concepts:
#
#    1) .bashrc is the *non-login* config for bash, run in scripts and after
#        first connection.
#    2) .bash_profile is the *login* config for bash, launched upon first connection.
#    3) .bash_profile imports .bashrc, but not vice versa.
#    4) .bashrc imports .bashrc_custom, which can be used to override
#        variables specified here.
#
# When using GNU screen:
#
#    1) .bash_profile is loaded the first time you login, and should be used
#       only for paths and environmental settings

#    2) .bashrc is loaded in each subsequent screen, and should be used for
#       aliases and things like writing to .bash_eternal_history (see below)
#
# Do 'man bashrc' for the long version or see here:
# http://en.wikipedia.org/wiki/Bash#Startup_scripts
#
# When Bash starts, it executes the commands in a variety of different scripts.
#
#   1) When Bash is invoked as an interactive login shell, it first reads
#      and executes commands from the file /etc/profile, if that file
#      exists. After reading that file, it looks for ~/.bash_profile,
#      ~/.bash_login, and ~/.profile, in that order, and reads and executes
#      commands from the first one that exists and is readable.
#
#   2) When a login shell exits, Bash reads and executes commands from the
#      file ~/.bash_logout, if it exists.
#
#   3) When an interactive shell that is not a login shell is started
#      (e.g. a GNU screen session), Bash reads and executes commands from
#      ~/.bashrc, if that file exists. This may be inhibited by using the
#      --norc option. The --rcfile file option will force Bash to read and
#      execute commands from file instead of ~/.bashrc.





# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
# xterm-color)
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#     ;;
# *)
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#     ;;
# esac

# Comment in the above and uncomment this below for a color prompt
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/data/Josh/.miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/data/Josh/.miniconda3/etc/profile.d/conda.sh" ]; then
        . "/usr/local/data/Josh/.miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/data/Josh/.miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> conda initialize for the malvinas type machines >>>

if [ "$HOSTNAME" = "malvinas" ]; then
    #echo "on Malvinas"
    __conda_setup="$('/localdata/joshua/.miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/localdata/joshua/.miniconda3/etc/profile.d/conda.sh" ]; then
            . "/localdata/joshua/.miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/localdata/joshua/.miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
# <<< conda initialize for the malvinas type machines <<<



# -----------------------------------
# -- 1.1) Set up umask permissions --
# -----------------------------------
#  The following incantation allows easy group modification of files.
#  See here: http://en.wikipedia.org/wiki/Umask
#
#     umask 002 allows only you to write (but the group to read) any new
#     files that you create.
#
#     umask 022 allows both you and the group to write to any new files
#     which you make.
#
#  In general we want umask 022 on the server and umask 002 on local
#  machines.
#
#  The command 'id' gives the info we need to distinguish these cases.
#
#     $ id -gn  #gives group name
#     $ id -un  #gives user name
#     $ id -u   #gives user ID
#
#  So: if the group name is the same as the username OR the user id is not
#  greater than 99 (i.e. not root or a privileged user), then we are on a
#  local machine (check for yourself), so we set umask 002.
#
#  Conversely, if the default group name is *different* from the username
#  AND the user id is greater than 99, we're on the server, and set umask
#  022 for easy collaborative editing.
if [ "`id -gn`" == "`id -un`" -a `id -u` -gt 99 ]; then
	umask 002
else
	umask 022
fi

# ---------------------------------------------------------
# -- 1.2) Set up bash prompt and ~/.bash_eternal_history --
# ---------------------------------------------------------
#  Set various bash parameters based on whether the shell is 'interactive'
#  or not.  An interactive shell is one you type commands into, a
#  non-interactive one is the bash environment used in scripts.
if [ "$PS1" ]; then

    if [ -x /usr/bin/tput ]; then
      if [ "x`tput kbs`" != "x" ]; then # We can't do this with "dumb" terminal
        stty erase `tput kbs`
      elif [ -x /usr/bin/wc ]; then
        if [ "`tput kbs|wc -c `" -gt 0 ]; then # We can't do this with "dumb" terminal
          stty erase `tput kbs`
        fi
      fi
    fi
    case $TERM in
	xterm*)
		if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
			PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
		else
	    	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007"'
		fi
		;;
	screen)
		if [ -e /etc/sysconfig/bash-prompt-screen ]; then
			PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
		else
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}\033\\"'
		fi
		;;
	*)
		[ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default

	    ;;
    esac

    # Bash eternal history
    # --------------------
    # This snippet allows infinite recording of every command you've ever
    # entered on the machine, without using a large HISTFILESIZE variable,
    # and keeps track if you have multiple screens and ssh sessions into the
    # same machine. It is adapted from:
    # http://www.debian-administration.org/articles/543.
    #
    # The way it works is that after each command is executed and
    # before a prompt is displayed, a line with the last command (and
    # some metadata) is appended to ~/.bash_eternal_history.
    #
    # This file is a tab-delimited, timestamped file, with the following
    # columns:
    #
    # 1) user
    # 2) hostname
    # 3) screen window (in case you are using GNU screen)
    # 4) date/time
    # 5) current working directory (to see where a command was executed)
    # 6) the last command you executed
    #
    # The only minor bug: if you include a literal newline or tab (e.g. with
    # awk -F"\t"), then that will be included verbatime. It is possible to
    # define a bash function which escapes the string before writing it; if you
    # have a fix for that which doesn't slow the command down, please submit
    # a patch or pull request.
    PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo -e $$\\t$USER\\t$HOSTNAME\\tscreen $WINDOW\\t`date +%D%t%T%t%Y%t%s`\\t$PWD"$(history 1)" >> ~/.bash_eternal_history'

    # Turn on checkwinsize
    shopt -s checkwinsize

    #Prompt edited from default
    [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u \w]\\$ "

    if [ "x$SHLVL" != "x1" ]; then # We're not a login shell
        for i in /etc/profile.d/*.sh; do
	    if [ -r "$i" ]; then
	        . $i
	    fi
	done
    fi
fi

# Append to history
# See: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
shopt -s histappend

# Make prompt informative
# See:  http://www.ukuug.org/events/linux2003/papers/bash_tips/
# PS1="\[\033[0;34m\][\u@\h:\w]$\[\033[0m\]"

## -----------------------
## -- 2) Set up aliases --
## -----------------------

# 2.1) Safety
# alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

# 2.2) Listing, directories, and motion
alias ll="ls -alrtF --color"
alias la="ls -A"
alias l="ls -CF"
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias m='less'
alias ..='cd ..'
alias ...='cd ..;cd ..'
alias md='mkdir'
alias cl='clear'
alias du='du -ch --max-depth=1'
alias treeacl='tree -A -C -L 2'

# 2.3) Text and editor commands
alias em='emacs -nw'     # No X11 windows
alias eqq='emacs -nw -Q' # No config and no X11
export EDITOR='emacs -nw'
export VISUAL='emacs -nw'

# 2.4) grep options
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;31' # green for matches

# 2.5) sort options
# Ensures cross-platform sorting behavior of GNU sort.
# http://www.gnu.org/software/coreutils/faq/coreutils-faq.html#Sort-does-not-sort-in-normal-order_0021
unset LANG
export LC_ALL=POSIX

# 2.6) Install rlwrap if not present
# http://stackoverflow.com/a/677212
command -v rlwrap >/dev/null 2>&1 || { echo >&2 "Install rlwrap to use node: sudo apt-get install -y rlwrap";}

# To try and fix the annoying erase commands:
alias ^H='stty erase ^H'
alias ^?='stty erase ^?' # this could be stty errase



## Define any user-specific variables you want here.
source ~/.bashrc_custom


# To get the Jupyter notebook running with no browser, for later consumption
alias jupyterN='jupyter notebook --no-browser --port=8889'


export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/adaptation/joshua/.mujoco/mujoco200/bin

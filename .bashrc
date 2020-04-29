#####
# Time-stamp: <2020-04-29 11:05:14 (elrond@rivendell) .bashrc>
#####
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias lt='ls -ltr'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

########################################
# elrond@rivendell, created 04/25/2020 #
########################################

function timer_start {
    timer=${timer:-$SECONDS}
}

function timer_stop {
    timer_show=$(($SECONDS - $timer))
    unset timer
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

export PS1='\[\033[0;31m\]\u@\h [elt:${timer_show}s] \[\033[1;36m\]\w \[\033[1;32m\]> \[\033[00m\]'

export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTSIZE=
export HISTFILESIZE=

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '
#PS1="\e[0;31m[\u@\h \W]\$ \e[m " # red color prompt
#PS1="\e[0;32m[\u@\h \W]\$ \e[m " # green color prompt
#PS1="\e[0;33m[\u@\h \W]\$ \e[m" # yellow color prompt

alias .a='screenfetch'
alias .b='. ~elrond/.bashrc'
alias .c='rm -f *~ .*~'
alias .d='dfc -d -t -squashfs'
alias .ds='dstat -t --all --vm --tcp'
alias .h='history | less'
alias .m='mount -t vboxsf virtualbox-share /mnt'
#alias .vd='vnstat -d -i enp0s3'
#alias .vm='vnstat -m -i enp0s3'

alias .nf='neofetch'

alias .ep='echo "EPOCHSECONDS: $EPOCHSECONDS"'

alias born='cat ~elrond/adm/birthdate | head -1'
alias age='echo "... to be implemented"'
alias pc='procinfo'

alias .jxe='journalctl -xe'

alias eb='emacs -nw ~elrond/.bashrc'
alias ebolt='emacs -nw ~elrond/adm/bolt'
alias enw='emacs -nw'
alias elpa='cd ~elrond/.emacs.d/elpa'

alias u='uname -a'

alias s='/usr/bin/sudo'
alias slog='less /var/log/syslog'
alias tlog='tail -f /var/log/syslog'

alias .glibc="echo '#include <errno.h>' | gcc -xc - -E -dM | \
      grep -E '^#define __GLIBC(|_MINOR)__ ' | sort"

alias up='uprecords'
alias updb='echo; \
  echo "--------- /var/spool/uptimed -----------"; \
  ls -la /var/spool/uptimed; echo'

alias uprec='echo; \
  echo "------- /var/spool/uptimed/records ------"; \
  cat /var/spool/uptimed/records; echo; \
  echo -n "uptimed record count: "; cat /var/spool/uptimed/records | wc -l | sed -e "s/ //g"; \
  echo'

alias dtdb='echo; \
  echo "----------- /var/lib/downtimed ----------"; \
  ls -la /var/lib/downtimed; \
  echo'

for d in adm bin misc log pkg projects src tmp; do
    alias ${d}="cd ~elrond/${d}"
done

for p in c++ gcc downtimed go haskell kernel lua perl ruby; do
    alias p${p}="cd ~elrond/projects/${p}"
done

alias yavanna='ssh mellon@192.168.122.75'
alias alpine='ssh jgalt@192.168.122.195'

alias ll="ls -la"
alias gs="git status"

PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
PS1="$PS1"'\[\033[32m\]'       # change to green
PS1="$PS1"'\u '                # user<space>
PS1="$PS1"'\[\033[33m\]'       # change to brownish yellow
PS1="$PS1"'\W'                 # current working directory
PS1="$PS1"'\[\033[0m\]'        # change color
PS1="$PS1"'\n'                 # new line
PS1="$PS1"'$ '                 # prompt: always $

set -o vi

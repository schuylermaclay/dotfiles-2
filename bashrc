###########
# Aliases #

alias b='bundle exec'
# Change to the root level directory the current git repository
alias cdg='cd $(git rev-parse --show-toplevel || pwd)'
alias diff=colordiff
alias get='git'
alias gh='hub browse'
alias ls='ls -hFG'
alias l='ls'
alias la='ls -la'
alias ll='ls -l'
alias top='top -s 5 -o cpu -stats pid,user,command,cpu,rsize,vsize,threads,state'

# Use Apple's man page viewer if we are on a local console
if [ "$TERM_PROGRAM" == "Apple_Terminal" ]; then
  function man {
    open x-man-page://$1
  }
fi

###########################
# History and Completions #

export HISTIGNORE="&:ls:l:la:ll:exit"
bind '"\e[A"':history-search-backward # up arrow
bind '"\e[B"':history-search-forward  # down arrow

# Note that bash_completion is necessary for __git_ps1 magic
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

#######
# PS1 #

export LSCOLORS=Dxxxxxxxxxxxxxxxxxxxxx
# Only show last 2 directories that make up the current path
export PROMPT_DIRTRIM=2

# Omit the user@hostname from PS1 if we are on the local console
userhost=""
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  userhost=" $USER@`hostname -s` "
fi

export PS1='\[\e[0;30;43m\]$userhost\[\e[0m\]\[\e[1m\]\w$ \[\e[0m\]'

############
# Homebrew #

export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/share/npm/bin:$PATH

#######
# Git #

# Include git goodies in PS1 if possible
if [ "`type -t __git_ps1`" == 'function' ]; then
  export GIT_PS1_SHOWDIRTYSTATE=true     # '*' for unstaged changes, '+' for staged
  export GIT_PS1_SHOWSTASHSTATE=true     # '$' if smth is stashed
  export GIT_PS1_SHOWUNTRACKEDFILES=true # '%' if un-tracked files

  export PS1='\[\e[0;30;43m\]$userhost\[\e[0m\]\[\e[1m\]\w\[\e[0m\]$(__git_ps1 " (%s)")\[\e[1m\]$ \[\e[0m\]'
fi

########
# Ruby #

if [ -d ~/.rbenv ]; then
  export PATH=~/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
  alias br='bundle install && rbenv rehash'
fi

# OS X has its own way of setting LANG, but only at the console.
# By declaring here in .bashrc, daemons like Pow will also pick it up.
export LANG=en_US.UTF-8

# Shortcut for `bundle exec rails` and `bundle exec rake`.
# If bin/rails and bin/rake are available, use them instead as they are much
# faster to execute than `bundle exec`.
function r() {
  if [[ "g|generate|c|console|s|server|db|dbconsole|new" =~ $1 ]]; then
    if [ -x bin/rails ]; then
      bin/rails "$@"
    elif [ -x script/rails ]; then
      script/rails "$@"
    else
      rails "$@"
    fi
  else
    if [ -x bin/rake ]; then
      bin/rake "$@"
    elif [ -x script/rake ]; then
      script/rake "$@"
    else
      rake "$@"
    fi
  fi
}

#####################
# Python virtualenv #

# You will need to:
#   brew install python
#   pip install --upgrade virtualenv
#   pip install --upgrade virtualenvwrapper
#   mkdir ~/.virtualenvs

if [ -d ~/.virtualenvs ]; then
  export WORKON_HOME=$HOME/.virtualenvs
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  export VIRTUALENV_DISTRIBUTE=true
  export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache
  export PIP_REQUIRE_VIRTUALENV=true

  wrapper_sh=/usr/local/bin/virtualenvwrapper.sh
  [[ -f $wrapper_sh ]] && . $wrapper_sh

  syspip(){
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
  }
fi

##############
# Subversion #

if [ -f ~/.svn_color ]; then
  source ~/.svn_color
fi

####################
# Java Environment #

if [ -d /System/Library/Frameworks/JavaVM.framework/Versions/1.6 ]; then
  export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home
  export MAVEN_OPTS="-Xmx512m -XX:+HeapDumpOnOutOfMemoryError"
fi

#################
# Oracle Client #

# Assume Oracle Instant Client is installed in /opt/custom/oracle
if [ -d /opt/custom/oracle ]; then
  export ORACLE_CLIENT_HOME=/opt/custom/oracle
  export PATH=$ORACLE_CLIENT_HOME:$PATH
  export DYLD_LIBRARY_PATH=$ORACLE_CLIENT_HOME
  export NLS_LANG=AMERICAN_AMERICA.UTF8
  export TWO_TASK=DEVDB
  export SQLPATH=${ORACLE_CLIENT_HOME}

  # User scripts can be placed in ~/Library/Oracle/
  if [ -d ${HOME}/Library/Oracle/ ]; then
    export SQLPATH=${SQLPATH}:${HOME}/Library/Oracle/Scripts
    export TNS_ADMIN=${HOME}/Library/Oracle/Admin
  fi
fi

########
# Misc #
export PAGER=/usr/bin/less

if [ "$TERM_PROGRAM" == "Apple_Terminal" ]; then
  export EDITOR="subl -w"
else
  export EDITOR=vi
fi

##################
# Custom Scripts #

if [ -d ~/.bin ]; then
  export PATH=~/.bin:$PATH
fi

# use .localrc for settings specific to one system
if [ -f ~/.localrc ]; then
  source ~/.localrc
fi

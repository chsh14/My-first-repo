#!/bin/bash
shopt -s expand_aliases

PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
alias vim='/usr/local/bin/mvim'
alias ip="cd ~/Documents/git_directory/scripts ;. perlwrapper.sh -ip $1 $2"

#export GREP_OPTIONS='--colors=auto'


#!/ bin/bash
alias vim='/usr/local/bin/mvim'
export PATH=$PATH:$HOME/bin
if [ -f ~/.bashrc ]; then
		. ~/.bashrc
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
#set the prompt formatting 
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$(parse_git_branch)\[\033[33;1m\]\$\[\033[m\]"
#parses .dircolors and makes env var for GNU ls
#eval `dircolors`
eval "$(dircolors -b ~/.dircolors)"
alias ll='ls -hFal --color=auto'
if [ -f ~/.git-completion.bash ]; then
	source ~/.git-completion.bash
fi

#export CLICOLOR=0
#export CLICOLOR_FORCE=1
#export LSCOLORS=GxFxCxDxBxegedabagaced


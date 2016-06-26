setenv GIT_BRANCH_CMD "sh -c 'git branch 2> /dev/null' | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/\(.*\) \(at.*\)/(\2/'"
set prompt="%{\033[36m%}%n%{\033[m%}@%{\033[32m%}%m:%{\033[33;1m%}%c02`$GIT_BRANCH_CMD`%{\033[m%}$ "


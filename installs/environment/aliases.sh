
# Native ----------------------------------------------------------------------------------------- #

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias pgrep='pgrep -lai'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

alias c='clear'
alias cc='for i in $(seq 1 100); do echo; done && clear'
alias df='df -h'
alias du='du -h'
alias less='less -r'

# Directories ------------------------------------------------------------------------------------ #

alias ls='ls -h --color=auto --group-directories-first'
alias ll='ls -l'
alias la='ls -a'

alias d='ls -l'
alias dd='ls -lA'
alias ddd='ls -la'

alias tree='tree -p -h --du --dirsfirst'
alias t='tree'
alias tt='tree -a -I ".git"'
alias ttt='tree -a'

alias t2='t -L 2'
alias tt2='tt -L 2'
alias ttt2='ttt -L 2'

alias t3='t -L 3'
alias tt3='tt -L 3'
alias ttt3='ttt -L 3'

alias t4='t -L 4'
alias tt4='tt -L 4'
alias ttt4='ttt -L 4'

alias t5='t -L 5'
alias tt5='tt -L 5'
alias ttt5='ttt -L 5'

# Git -------------------------------------------------------------------------------------------- #

alias gadd='git add -A'
alias gcommit='git commit -m '
alias ggg='gadd && grcommit'
alias gclone='git clone --depth=1'

# Tokens ----------------------------------------------------------------------------------------- #

alias token8='tr -cd "[:alnum:]" < /dev/urandom | fold -w8 | head -n1'
alias token16='tr -cd "[:alnum:]" < /dev/urandom | fold -w16 | head -n1'
alias token32='tr -cd "[:alnum:]" < /dev/urandom | fold -w32 | head -n1'
alias token64='tr -cd "[:alnum:]" < /dev/urandom | fold -w64 | head -n1'

# Python ----------------------------------------------------------------------------------------- #

alias pytest='python3 -m pytest'
alias python='python3'
alias pipi='python3 -m pip install'

# Misc ------------------------------------------------------------------------------------------- #

alias base64='base64 -w 0'
alias uniqu='awk '"'"'!x[$0]++'"'"
alias xclip='xclip -sel clip'

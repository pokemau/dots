export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="refined"
ZSH_THEME="af-magic"

#plugins=(git)

source $ZSH/oh-my-zsh.sh

path+=('/home/mau/.local/bin')

# Helpful aliases

# GIT
alias gp='git push'
alias gs='git status'
alias ga='git add'
alias gc='git clone'
alias gcm='git commit -m'

# DEV
alias t='tmux'
alias v='nvim'
alias z='zed'
alias bm='bear -- make'
alias m='make'

export PATH

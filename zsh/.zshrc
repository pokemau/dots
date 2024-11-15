export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="refined"
#ZSH_THEME="af-magic"
#ZSH_THEME="random"
ZSH_THEME="murilasso"

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
alias t='tmux -2'
alias v='nvim'
alias z='zeditor'
alias bm='bear -- make'
alias m='make'
alias p='python'
alias lc='v leetcode.nvim'

export PATH

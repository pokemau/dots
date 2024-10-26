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
alias t='tmux -2'
alias v='nvim'
alias z='zeditor'
alias bm='bear -- make'
alias m='make'
alias p='python'
alias lc='v leetcode.nvim'

export PATH
source /usr/share/nvm/init-nvm.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mau/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mau/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mau/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mau/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

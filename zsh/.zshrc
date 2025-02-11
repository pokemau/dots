export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="refined"
#ZSH_THEME="af-magic"
#ZSH_THEME="random"
#ZSH_THEME="candy-kingdom"
ZSH_THEME="jispwoso"

#plugins=(git)

source $ZSH/oh-my-zsh.sh



# Fedora
alias inst='sudo dnf install'

# GIT
alias gp='git push'
alias gs='git status'
alias ga='git add'
alias gc='git clone'
alias gcm='git commit -m'
alias gsw='git switch'
alias gb='git branch'

# DEV
alias t='tmux -2'
alias v='nvim'
alias z='zeditor'
alias bm='rm -f compile_commands.json && bear -- make'
alias m='make'
alias p='python'
alias lc='v leetcode.nvim'

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Dev/Odin/
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/


export PATH

export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="jispwoso"

source $ZSH/oh-my-zsh.sh
# source /usr/share/nvm/init-nvm.sh

DISABLE_AUTO_TITLE="true"

# Fedora
alias inst='sudo dnf install'

# TOGGLE MONITOR ON SWAY
# alias tm='~/Scripts/sway_toggle_monitor.sh'

# GIT
alias gp='git push'
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias gc='git clone'
alias grh='git reset --hard'
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

# BATTERY 
alias btr='sudo ~/.cargo/bin/batty --value 80'

export EDITOR='nvim'
export PASSWORD_STORE=basic


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ruby gems
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

# Created by `pipx` on 2025-12-05 02:02:24
export PATH="$PATH:/home/mau/.local/bin"

export PATH="$HOME/.cargo/bin:$PATH"

# opencode
export PATH=/home/mau/.opencode/bin:$PATH

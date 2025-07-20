export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="jispwoso"

source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh

DISABLE_AUTO_TITLE="true"



# Fedora
alias inst='sudo dnf install'

# TOGGLE MONITOR ON SWAY
alias tm='~/Scripts/sway_toggle_monitor.sh'

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

export EDITOR='nvim'
export PASSWORD_STORE=basic


# export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init - zsh)"
#
# export PATH


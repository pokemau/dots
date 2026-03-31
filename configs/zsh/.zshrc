export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="jispwoso"
# ZSH_THEME="robbyrussell"

source $ZSH/oh-my-zsh.sh
# source /usr/share/nvm/init-nvm.sh

DISABLE_AUTO_TITLE="true"

# Fedora
alias inst='sudo dnf install'

# Arch
alias yayup='yay -Syu --cleanafter'
alias togglebat='./Scripts/toggle_batt.sh'

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
alias op='opencode'
alias gm='gemini'
alias cl='claude'


# BATTERY
# alias btr='sudo ~/.cargo/bin/batty --value 80'

export EDITOR='nvim'
export PASSWORD_STORE=basic


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
export PATH="$PATH:/home/mau/.local/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export QT_QPA_PLATFORMTHEME=qt6ct
export PATH=/home/mau/.opencode/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mau/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mau/Downloads/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/home/mau/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mau/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

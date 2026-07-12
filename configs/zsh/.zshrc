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

alias shn='shutdown now'

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
alias bm='rm -f compile_commands.json && bear -- make'
alias m='make'
alias p='python'
alias op='opencode'
alias gm='gemini'
alias cl='claude'
alias tm='tmuxer'

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

if [ -n "$XDG_RUNTIME_DIR" ]; then
  _wl=$(systemctl --user show-environment 2>/dev/null | sed -n 's/^WAYLAND_DISPLAY=//p')
  [ -z "$_wl" ] && _wl=$(ls -t "$XDG_RUNTIME_DIR"/wayland-[0-9] 2>/dev/null | head -n1 | xargs -r basename)
  [ -n "$_wl" ] && export WAYLAND_DISPLAY="$_wl"
  unset _wl
fi

export VCPKG_ROOT="$HOME/Apps/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"

eval "$(zoxide init zsh)"

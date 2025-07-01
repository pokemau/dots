export ZSH="$HOME/.oh-my-zsh"

#ZSH_THEME="refined"
#ZSH_THEME="af-magic"
#ZSH_THEME="random"
#ZSH_THEME="candy-kingdom"
ZSH_THEME="jispwoso"

#plugins=(git)

source $ZSH/oh-my-zsh.sh
source /usr/share/nvm/init-nvm.sh

DISABLE_AUTO_TITLE="true"



# Fedora
alias inst='sudo dnf install'

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

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Dev/Odin/
# export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/
export JAVA_HOME=$HOME/.jdks/corretto-21.0.6
export EDITOR='nvim'
export GEMINI_API_KEY='AIzaSyBAC04V5ahW9iwEosomIRog8sstkJ8Xmn4'

export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"


export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

export PATH

# pnpm
export PNPM_HOME="/home/mau/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

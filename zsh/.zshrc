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
alias gd='git diff'
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

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/Dev/Odin/
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk/
export EDITOR='neovim'
export GEMINI_API_KEY='AIzaSyBzlUJxVXojh3-QmCJXCshCK0s3g82I87I'


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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/mau/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/mau/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/mau/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/mau/Downloads/google-cloud-sdk/completion.zsh.inc'; fi


if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

export PATH=$PATH:~/.local/bin
export PATH=$PATH:/home/rodrigo/Android/Sdk/platform-tools
export PATH=$PATH:$HOME/.maestro/bin

export ANDROID_HOME="$HOME/Android/Sdk"
export ZK_NOTEBOOK_DIR="$HOME/Code/Personal/notes/"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

export PATH=$PATH:~/.local/bin
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
export PATH=$PATH:/home/rodrigo/Android/Sdk/platform-tools
export PATH=$PATH:$HOME/.maestro/bin
export PATH=$PATH:$HOME/dotfiles/bin
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/rodrigo/go/bin
export PATH=$PATH:/usr/local/apache-maven-3.9.6/bin
export PATH=$PATH:/home/rodrigo/idea/bin
export PATH=$PATH:/home/rodrigo/dotfiles/bin

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export ANDROID_HOME="$HOME/Android/Sdk"
export ZK_NOTEBOOK_DIR="$HOME/Code/Personal/notes/"
export MANPAGER="nvim +Man!"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

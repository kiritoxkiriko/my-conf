# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    #fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# http proxy function
export HTTP_PROXY_ADDR="http://127.0.0.1:7890"
export NIO_PROXY_ADDR="http://proxy.nioint.com:8080"

proxy() {
    if [[ $1 == "on" ]]; then
        export http_proxy=$HTTP_PROXY_ADDR
        export https_proxy=$HTTP_PROXY_ADDR
        echo "HTTP proxy is turned on"
    elif [[ $1 == "nio" ]]; then
        export http_proxy=$NIO_PROXY_ADDR
        export https_proxy=$NIO_PROXY_ADDR
        echo "NIO proxy is turned on"
    elif [[ $1 == "off" ]]; then
        unset http_proxy
        unset https_proxy
        echo "HTTP proxy is turned off"
    else
        echo "Invalid argument. Usage: proxy on/off/nio"
    fi
}

## keep proxy on
#export http_proxy=$HTTP_PROXY_ADDR
#export https_proxy=$HTTP_PROXY_ADDR

# SYSTEM PATH
export PATH="/opt/homebrew/opt/node@18/bin:$PATH"

# GO ENV
#export GOROOT="/Users/xinmeng.wang/.go"
export GOPATH="/Users/xinmeng.wang/go"
export GOPROXY="https://goproxy.cn,direct"
export GO111MODULE=on
export GOPRIVATE=*.nevint.com,*.nioint.com
export GONOPROXY=*.nevint.com,*.nioint.com
export GONOSUMDB=*.nevint.com,*.nioint.com
export PATH=$PATH:$GOPATH/bin

# alias

# remove git alias
unalias g
alias k='kubectl'
alias kns='kubens'
alias kctx='kubectx'
#alias docker='nerdctl'
alias fk="fuck"
alias pip=pip3
alias cpp="rsync -av --progress"
# add some shortcut


# k8s
export KUBECONFIG="${KUBECONFIG}:$HOME/.kube/config:$(find $HOME/.kube/configs -type f -maxdepth 1 | tr '\n' ':')"
# add k3d
export KUBECONFIG="$KUBECONFIG:$HOME/.k3d/kubeconfig-k3s-default.yaml"

# add java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home
export PATH=$JAVA_HOME:$PATH
# eval
eval $(thefuck --alias)
eval "$(jump shell)"

# config g
# g shell setup
if [ -f "${HOME}/.g/env" ]; then
    . "${HOME}/.g/env"
fi
# set g env
export G_MIRROR=https://golang.google.cn/dl/

git_switch_user () {
  if [[ $1 == "nio" ]]; then
    git config user.name xinmeng.wang
    git config user.email xinmeng.wang@nio.com
    echo "git user switch to $1"
  elif [[ $1 == "gh" ]]; then
    git config user.name kiritoxkiriko
    git config user.email wangxinmeng1997@hotmail.com
    echo "git user switch to $1"
  else
    echo "wrong name"
  fi
}

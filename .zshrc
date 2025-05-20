# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
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
    #zsh-autocomplete
    thefuck
    kubectl
    poetry
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
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# modify values bellow ONLY  ------------------------------------------


# http proxy function
export HTTP_PROXY_ADDR="http://127.0.0.1:7890"

proxy() {
    if [[ $1 == "on" ]]; then
        export http_proxy=$HTTP_PROXY_ADDR
        export https_proxy=$HTTP_PROXY_ADDR
        echo "HTTP proxy is turned on"
    elif [[ $1 == "off" ]]; then
        unset http_proxy
        unset https_proxy
        echo "HTTP proxy is turned off"
    else
        echo "Invalid argument. Usage: proxy on/off"
    fi
}

## keep proxy on
#export http_proxy=$HTTP_PROXY_ADDR
#export https_proxy=$HTTP_PROXY_ADDR

# SYSTEM PATH
export PATH="$(brew --prefix rustup)/bin:$PATH"
export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
export PATH="$PATH:/Users/bytedance/.local/bin"

# GO ENV
export GOPATH="$HOME/go"
export GOPROXY="https://goproxy.byted.org|https://goproxy.cn|direct"
export GO111MODULE=on
export GOPRIVATE="*.byted.org,*.everphoto.cn,git.smartisan.com"
#export GONOPROXY="*.byted.org,*.everphoto.cn,git.smartisan.com"
export GOSUMDB="sum.golang.google.cn"
export PATH=$PATH:$GOPATH/bin

# alias
alias k='kubectl'
alias kns='kubens'
alias kctx='kubectx'
alias kv='kubevpn'
alias kva='kubevpn alias'
#alias docker='nerdctl'
alias pip=pip3
alias cpp="rsync -av --progress"


# add some shortcut


# k8s
export KUBECONFIG="${KUBECONFIG}:$HOME/.kube/config:$(find $HOME/.kube/configs -type f -maxdepth 1 | tr '\n' ':')"

# add java
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home
#export PATH=$JAVA_HOME:$PATH

# eval
eval $(thefuck --alias)
eval "$(jump shell)"

# config g
# g shell setup
# remove git alias
unalias g
if [ -f "${HOME}/.g/env" ]; then
    . "${HOME}/.g/env"
fi
# set g env
export G_MIRROR=https://golang.google.cn/dl/

export GIT_WORK_USER="xinmengwang"
export GIT_WORK_MAIL="xinmengwang@bytedance.com"

git_switch_user () {
  if [[ $1 == "work" ]]; then
    git config user.name $GIT_WORK_USER
    git config user.email $GIT_WORK_MAIL
    git config commit.gpgsign true
    echo "git user switch to $1"
  elif [[ $1 == "gh" ]]; then
    git config user.name kiritoxkiriko
    git config user.email wangxinmeng1997@hotmail.com
    git config commit.gpgsign false
    echo "git user switch to $1"
  else
    echo "wrong name"
  fi
}

devbox () {
  kinit --keychain xinmengwang@BYTEDANCE.COM
  if [[ $1 == "gpu" ]]; then
    ssh dev-gpu
  else
    ssh dev-cpu
  fi
}



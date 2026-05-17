#! /bin/bash

# common cli tool
brew install wget curl git git-lfs unzip zip trzsz tmux vim neovim kubectl kubectx helm

# common dev tool
brew install "python@3.13" go "temurin@21" "node@22"

# shell workflow
brew install thefuck jump

# zsh setup
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if ! command -v starship >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# optional kubernetes workflow
brew install kubevpn

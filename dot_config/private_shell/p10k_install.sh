#!/bin/bash

# Ensure ZSH_CUSTOM is set
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.config/oh-my-zsh/custom}

# Clone powerlevel10k if it doesn't exist
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Reload zsh configuration
zsh -c "source $HOME/.zshrc"

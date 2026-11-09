#!/bin/sh

set -eu

THEME='gnzh'
PLUGINS='git autojump zsh-autosuggestions zsh-syntax-highlighting'

printf 'Are Zsh and Oh My Zsh installed? (y/N) '
IFS= read -r answer || exit 0
case "$answer" in
    y|Y) ;;
    *) exit 0 ;;
esac

sed -i "s|^ZSH_THEME=.*|ZSH_THEME=\"$THEME\"|" "$HOME/.zshrc"
sed -i "s|^plugins=.*|plugins=($PLUGINS)|" "$HOME/.zshrc"

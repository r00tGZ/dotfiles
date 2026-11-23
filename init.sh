#!/bin/sh

set -eu

if [ "$#" -ne 0 ]; then
    echo "Run init.sh without arguments." >&2
    exit 1
fi

checkout="$(pwd -P)/dotfiles"
if [ -d "$checkout/.git" ]; then
    git -C "$checkout" pull --ff-only
else
    git clone --depth 1 --branch core https://github.com/r00tGZ/dotfiles.git "$checkout"
fi

as_root=
[ "$(id -u)" -eq 0 ] || as_root=sudo

install_link() {
    if [ "$(readlink -- "$2")" = "$1" ]; then
        return
    fi
    $as_root mkdir -p "$(dirname -- "$2")"
    $as_root ln -sT -- "$1" "$2"
}

install_link "$checkout/dotfiles.sh" /usr/local/bin/dotfiles
install_link "$checkout/autocomplete.zsh" /usr/local/share/zsh/site-functions/_dotfiles

echo "Run 'dotfiles install' to see the install options."

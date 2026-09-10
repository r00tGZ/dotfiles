#!/bin/sh

set -eu

GITHUB_URL="https://github.com/r00tGZ/dotfiles.git"
INSTALL_DIRECTORY="$HOME/.dotfiles"
COMMAND_PATH="/usr/local/bin/dotfiles"
AUTOCOMPLETE_PATH="/usr/local/share/zsh/site-functions/_dotfiles"

if [ "$#" -ne 0 ]; then
    echo "init.sh does not accept arguments." >&2
    exit 2
fi

if [ "$(id -u)" -eq 0 ]; then
    echo "Run init.sh as the regular user who will own the dotfiles." >&2
    exit 1
fi

command -v git >/dev/null 2>&1 || {
    echo "git is required to install this project." >&2
    exit 1
}

if [ -d "$INSTALL_DIRECTORY/.git" ]; then
    git -C "$INSTALL_DIRECTORY" pull --ff-only
elif [ -e "$INSTALL_DIRECTORY" ]; then
    echo "$INSTALL_DIRECTORY already exists and is not a Git repository." >&2
    exit 1
else
    git clone --depth 1 --branch master "$GITHUB_URL" "$INSTALL_DIRECTORY"
fi

command_target="$INSTALL_DIRECTORY/dotfiles.sh"
[ -x "$command_target" ] || {
    echo "Missing executable: $command_target" >&2
    exit 1
}
command_target=$(readlink -f -- "$command_target")

autocomplete_target="$INSTALL_DIRECTORY/autocomplete.zsh"
[ -r "$autocomplete_target" ] || {
    echo "Missing completion definition: $autocomplete_target" >&2
    exit 1
}
autocomplete_target=$(readlink -f -- "$autocomplete_target")

install_link() {
    link_target=$1
    link_path=$2

    if [ -L "$link_path" ] &&
        [ "$(readlink -- "$link_path")" = "$link_target" ]; then
        return
    fi

    if [ -e "$link_path" ] || [ -L "$link_path" ]; then
        echo "$link_path already exists and was not changed." >&2
        exit 1
    fi

    command -v sudo >/dev/null 2>&1 || {
        echo "sudo is required to create $link_path." >&2
        exit 1
    }

    sudo mkdir -p "$(dirname -- "$link_path")"
    sudo ln -s "$link_target" "$link_path"
}

install_link "$command_target" "$COMMAND_PATH"
install_link "$autocomplete_target" "$AUTOCOMPLETE_PATH"

echo "Dotfiles command and Zsh completion installed."
echo "Run 'dotfiles install all' to set up this machine."

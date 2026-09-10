#!/bin/sh

set -eu

usage() {
    cat >&2 <<'EOF'
Usage:
  dotfiles install <all|environment|software|configs>
  dotfiles profile <kali-htb|kali-off>
EOF
}

case "$0" in
    */*) command_path=$0 ;;
    *) command_path=$(command -v "$0") ;;
esac

command_path=$(readlink -f -- "$command_path") || {
    echo "Cannot locate the dotfiles project." >&2
    exit 1
}
DOTFILES_DIRECTORY=$(dirname -- "$command_path")

run_as_root() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    else
        command -v sudo >/dev/null 2>&1 || {
            echo "sudo is required for this operation." >&2
            exit 1
        }
        sudo "$@"
    fi
}

install_environment() {
    line='source "$HOME/.dotfiles/installs/environment/_load.sh"'

    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
        grep -Fqx "$line" "$rc_file" 2>/dev/null ||
            printf '\n%s\n' "$line" >> "$rc_file"
    done

    echo "Environment installation complete."
}

install_configs() {
    manifest="$DOTFILES_DIRECTORY/installs/configs/MANIFEST.tsv"
    [ -f "$manifest" ] || {
        echo "Missing config manifest." >&2
        exit 1
    }

    tab=$(printf '\t')
    while IFS="$tab" read -r file path extra; do
        if [ -z "$file" ] || [ -z "$path" ] || [ -n "$extra" ]; then
            echo "Invalid config manifest entry." >&2
            exit 1
        fi

        source_file="$DOTFILES_DIRECTORY/installs/configs/$file"
        target="$HOME/$path"
        if [ ! -f "$source_file" ]; then
            echo "Missing config: $source_file" >&2
            exit 1
        fi

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source_file" ]; then
            continue
        fi

        if [ -e "$target" ] || [ -L "$target" ]; then
            mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
        fi

        mkdir -p "$(dirname "$target")"
        ln -s "$source_file" "$target"
    done < "$manifest"

    echo "Config installation complete."
}

install_software() {
    package_file="$DOTFILES_DIRECTORY/installs/software/packages.lst"
    [ -f "$package_file" ] || {
        echo "Missing package list." >&2
        exit 1
    }

    set --
    while IFS= read -r package || [ -n "$package" ]; do
        case "$package" in
            ''|\#*) continue ;;
        esac
        set -- "$@" "$package"
    done < "$package_file"

    [ "$#" -gt 0 ] || {
        echo "Package list is empty." >&2
        exit 1
    }

    run_as_root apt-get update
    run_as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"

    echo "Software installation complete."
}

if [ "$#" -ne 2 ]; then
    usage
    exit 2
fi

command=$1
selection=$2

case "$command:$selection" in
    install:all|install:environment|install:software|install:configs)
        if [ "$(id -u)" -eq 0 ]; then
            echo "Run 'dotfiles install' as the regular user." >&2
            exit 1
        fi
        ;;
    profile:kali-htb|profile:kali-off) ;;
    *)
        usage
        exit 2
        ;;
esac

case "$command:$selection" in
    install:all)
        install_software
        install_configs
        install_environment
        ;;
    install:environment) install_environment ;;
    install:software) install_software ;;
    install:configs) install_configs ;;
    profile:*) run_as_root "$DOTFILES_DIRECTORY/profiles/_run.sh" "$selection" ;;
esac

case "$command:$selection" in
    install:all|install:environment)
        echo "Restart Bash or Zsh to load the environment."
        ;;
esac

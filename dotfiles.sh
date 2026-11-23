#!/bin/sh

set -eu

usage() {
    echo 'Usage: dotfiles install <conf|env|sw> | dotfiles update'
}

install_options() {
    printf '%s\n' 'dotfiles install conf' 'dotfiles install env' 'dotfiles install sw [tag ...]'
}

DOTFILES_DIRECTORY=$(dirname -- "$(readlink -f -- "$0")")
software_dir="$DOTFILES_DIRECTORY/install/software"

install_environment() {
    quoted_dir=$(printf '%s' "$DOTFILES_DIRECTORY" | sed "s/'/'\\\\''/g")
    line="DOTFILES_DIR='$quoted_dir'; . \"\$DOTFILES_DIR/install/environment/_load.sh\""

    for rc_file in "$HOME/.bashrc" "$HOME/.zshrc"; do
        grep -Fqx "$line" "$rc_file" 2>/dev/null ||
            printf '\n%s\n' "$line" >> "$rc_file"
    done

    echo 'Restart Bash or Zsh to load the environment.'
}

install_configs() {
    manifest="$DOTFILES_DIRECTORY/install/configs/MANIFEST.tsv"
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

        source_file="$DOTFILES_DIRECTORY/install/configs/$file"
        target="$HOME/$path"
        if [ ! -f "$source_file" ]; then
            echo "Missing config: $source_file" >&2
            exit 1
        fi

        if [ -L "$target" ] && [ "$(readlink "$target")" = "$source_file" ]; then
            continue
        fi

        if [ -e "$target" ] || [ -L "$target" ]; then
            mv -T --backup=numbered "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
        fi

        mkdir -p "$(dirname "$target")"
        ln -s "$source_file" "$target"
    done < "$manifest"

    echo "Config installation complete."
}

install_software() {
    packages=
    for tag do
        list="$software_dir/$tag.lst"
        case "$tag" in
            */*) echo "Warning: unknown software tag: $tag" >&2; continue ;;
        esac
        if [ -f "$list" ]; then
            packages="$packages $(sed '/^#/d' "$list")"
        else
            echo "Warning: unknown software tag: $tag" >&2
        fi
    done

    # Package lists contain whitespace-separated APT package names.
    set -f
    set -- $packages
    [ "$#" -gt 0 ] || return 0
    as_root=
    [ "$(id -u)" -eq 0 ] || as_root=sudo
    $as_root apt-get update
    $as_root env DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}

case ${1-} in
    '') usage; exit 0 ;;
    update) [ "$#" -eq 1 ] || { usage >&2; exit 2; }
            exec git -C "$DOTFILES_DIRECTORY" pull --ff-only ;;
    install) shift ;;
    *) usage >&2; exit 2 ;;
esac

case ${1-} in
    '') install_options; exit 0 ;;
    conf|env) [ "$#" -eq 1 ] || { install_options >&2; exit 2; } ;;
    sw)
        if [ "$#" -eq 1 ]; then
            for list in "$software_dir"/*.lst; do
                basename "$list" .lst
            done
            exit 0
        fi
        ;;
    *) install_options >&2; exit 2 ;;
esac

case $1 in
    conf) install_configs ;;
    env) install_environment ;;
    sw) shift; install_software "$@" ;;
esac

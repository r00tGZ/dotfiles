#!/bin/sh

set -eu

usage() {
    echo "Usage: dotfiles profile <profile>" >&2
}

if [ "$#" -ne 1 ]; then
    usage
    exit 2
fi

profile=$1
case "$profile" in
    ''|*[!A-Za-z0-9-]*)
        usage
        exit 2
        ;;
esac

PROFILE_DIRECTORY=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
profile_script="$PROFILE_DIRECTORY/$profile.sh"

if [ ! -f "$profile_script" ]; then
    echo "Unknown profile: $profile" >&2
    usage
    exit 2
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script as root." >&2
    exit 1
fi

sh "$profile_script"

echo "Profile '$profile' complete."

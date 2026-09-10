#!/bin/sh

set -eu

usage() {
    echo "Usage: dotfiles profile <kali-htb|kali-off>" >&2
}

if [ "$#" -ne 1 ]; then
    usage
    exit 2
fi

case "$1" in
    kali-htb|kali-off) profile=$1 ;;
    *)
        usage
        exit 2
        ;;
esac

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script as root." >&2
    exit 1
fi

if [ ! -r /etc/os-release ]; then
    echo "Cannot identify this system." >&2
    exit 1
fi

. /etc/os-release
if [ "${ID:-}" != kali ]; then
    echo "This profile requires Kali Linux." >&2
    exit 1
fi

if ! id toor >/dev/null 2>&1; then
    echo "User toor does not exist." >&2
    exit 1
fi

PROFILE_DIRECTORY=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

sh "$PROFILE_DIRECTORY/kali-base.sh"
sh "$PROFILE_DIRECTORY/$profile.sh"

echo "Profile '$profile' complete."

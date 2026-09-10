
mkcd() {
    if [ $# -eq 1 ]; then
        command mkdir -p -- "$1" && cd -- "$1"
    else
        echo "Usage: mkcd <directory>" >&2
        return 2
    fi
}

grcommit() {
    git commit -m "auto: ${RANDOM}-${RANDOM}-${RANDOM}"
}

mktmp() {
    if [ $# -eq 0 ]; then
        cd -- "$(command mktemp -d)"
    elif [ $# -eq 1 ]; then
        command mkdir -p -- "/tmp/$1" && cd -- "/tmp/$1"
    else
        echo "Usage: mktmp [<directory>]" >&2
        return 2
    fi
}

#!/bin/sh

set -eu

if [ "$(id -u)" -ne 0 ]; then
    echo "Run this script as root." >&2
    exit 1
fi

if ! id toor >/dev/null 2>&1; then
    echo "User toor does not exist." >&2
    exit 1
fi

. /etc/os-release

case " ${ID:-} ${ID_LIKE:-} " in
    *" ubuntu "*)
        docker_distribution=ubuntu
        docker_codename=${DOCKER_CODENAME:-${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}}
        ;;
    *" debian "*)
        docker_distribution=debian
        if [ "${ID:-}" = debian ]; then
            docker_codename=${DOCKER_CODENAME:-${VERSION_CODENAME:-}}
        else
            docker_codename=${DOCKER_CODENAME:-}
        fi
        ;;
    *)
        echo "Only Debian and Debian-based systems are supported." >&2
        exit 1
        ;;
esac

case "$docker_codename" in
    ''|*[!A-Za-z0-9._-]*)
        echo "Set DOCKER_CODENAME to the matching Debian or Ubuntu release." >&2
        exit 1
        ;;
esac

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
	ca-certificates \
	curl

install -m 0755 -d /etc/apt/keyrings
curl -fsSL "https://download.docker.com/linux/$docker_distribution/gpg" \
    -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

printf '%s\n' \
    'Types: deb' \
    "URIs: https://download.docker.com/linux/$docker_distribution" \
    "Suites: $docker_codename" \
    'Components: stable' \
    "Architectures: $(dpkg --print-architecture)" \
    'Signed-By: /etc/apt/keyrings/docker.asc' \
    > /etc/apt/sources.list.d/docker.sources

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

usermod -aG docker toor
echo "Docker installed. Log out and back in as toor before using it."

#!/bin/sh

set -eu

install -d -m 0755 -o toor -g "$(id -gn toor)" /box

apt update -y
apt autoclean -y
apt autoremove -y

if getent group wireshark >/dev/null 2>&1; then
    usermod -aG wireshark toor
fi

apt-get install -y build-essential seclists

wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -O /opt/linpeas.sh
wget https://github.com/itm4n/PrivescCheck/releases/latest/download/PrivescCheck.ps1 -O /opt/PrivescCheck.ps1

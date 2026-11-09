#!/bin/sh

set -eu

install -d -m 0755 -o toor -g "$(id -gn toor)" /box
install -d -m 0755 -o toor -g "$(id -gn toor)" /box/public
install -d -m 0755 -o toor -g "$(id -gn toor)" /box/user

apt-get update -y
apt-get install -y build-essential seclists
apt-get autoclean -y
apt-get autoremove -y

if getent group wireshark >/dev/null 2>&1; then
    usermod -aG wireshark toor
fi

searchsploit -u

wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -O /opt/linpeas.sh
wget https://raw.githubusercontent.com/peass-ng/PEASS-ng/refs/heads/master/winPEAS/winPEASbat/winPEAS.bat -O /opt/winpeas.bat
wget https://raw.githubusercontent.com/peass-ng/PEASS-ng/refs/heads/master/winPEAS/winPEASps1/winPEAS.ps1 -O /opt/winpeas.ps1

j -a /box -i 1000

updatedb

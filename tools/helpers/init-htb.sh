#!/bin/sh

set -eu

echo "Updating locate database..."
updatedb

echo "Updating searchsploit..."
searchsploit -u

install -d -m 0755 -o toor -g "$(id -gn toor)" /box
j -a /box -i 1000

wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh -O /opt/linpeas.sh
wget https://raw.githubusercontent.com/peass-ng/PEASS-ng/refs/heads/master/winPEAS/winPEASbat/winPEAS.bat -O /opt/winpeas.bat
wget https://raw.githubusercontent.com/peass-ng/PEASS-ng/refs/heads/master/winPEAS/winPEASps1/winPEAS.ps1 -O /opt/winpeas.ps1

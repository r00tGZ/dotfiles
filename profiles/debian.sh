#!/bin/sh

set -eu

install -d -m 0755 -o toor -g "$(id -gn toor)" /toor

apt update -y
apt autoclean -y
apt autoremove -y

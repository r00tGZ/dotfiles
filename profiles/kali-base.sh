#!/bin/sh

set -eu

if getent group wireshark >/dev/null 2>&1; then
    usermod -aG wireshark toor
fi

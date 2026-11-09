#!/bin/sh

set -eu

git config --global user.name "John Doe"
git config --global user.email "john.doe@example.com"
git config --global core.editor "vim"
git config --global color.ui auto
git config --global init.defaultBranch core

#compdef dotfiles

local -a commands installations
commands=('install:install selected components' 'update:pull the checkout')
installations=('conf:link config files' 'env:enable the shell environment' 'sw:install software by tag')

case $CURRENT in
    2) _describe 'command' commands ;;
    3) [[ $words[2] == install ]] && _describe 'installation' installations ;;
esac

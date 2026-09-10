#compdef dotfiles

local -a commands installations profiles

commands=(
    'install:install selected components'
    'profile:apply a machine profile'
)
installations=(
    'all:install software, configs, and environment'
    'environment:enable the Bash and Zsh environment'
    'software:install the package list'
    'configs:link managed config files'
)
profiles=(
    'kali-htb:apply the Hack The Box profile'
    'kali-off:apply the daily-work profile'
)

case $CURRENT in
    2) _describe 'command' commands ;;
    3)
        case $words[2] in
            install) _describe 'installation' installations ;;
            profile) _describe 'profile' profiles ;;
        esac
        ;;
esac

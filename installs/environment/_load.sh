DOTFILES_DIR="$HOME/.dotfiles"

case ":$PATH:" in
    *":$DOTFILES_DIR/installs/environment/bin:"*) ;;
    *) PATH="$DOTFILES_DIR/installs/environment/bin:$PATH" ;;
esac

export PATH

. "$DOTFILES_DIR/installs/environment/aliases.sh"
. "$DOTFILES_DIR/installs/environment/functions.sh"
. "$DOTFILES_DIR/installs/environment/variables.sh"

if [ -r /usr/share/autojump/autojump.sh ]; then
    . /usr/share/autojump/autojump.sh
fi

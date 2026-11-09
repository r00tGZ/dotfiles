
case ":$PATH:" in
    *":$DOTFILES_DIR/install/environment/bin:"*) ;;
    *) PATH="$DOTFILES_DIR/install/environment/bin:$PATH" ;;
esac

export PATH

. "$DOTFILES_DIR/install/environment/aliases.sh"
. "$DOTFILES_DIR/install/environment/functions.sh"
. "$DOTFILES_DIR/install/environment/variables.sh"

if [ -r /usr/share/autojump/autojump.sh ]; then
    . /usr/share/autojump/autojump.sh
fi

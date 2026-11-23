# dotfiles

Personal Debian and Kali shell tools, config files, and APT package lists.

## Install

Run as root or as a regular user with sudo access from the directory that should contain `dotfiles/`. When running as root, omit `sudo` from the commands below and use a checkout only root can modify.

```sh
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
curl -fsSL https://raw.githubusercontent.com/r00tGZ/dotfiles/core/init.sh | sh
```

Keep the checkout in place. The command and its Zsh completion link to it. Zsh discovers completion through `compinit`.

```sh
dotfiles install conf                # Link configs and back up replaced files
dotfiles install env                 # Enable the environment, then restart Bash or Zsh
dotfiles install sw                  # List available tags
dotfiles install sw core core-heavy  # Install selected tags
dotfiles update                      # Pull the checkout
```

## Standalone tools

- After installing Oh My Zsh and its plugins, run `./tools/helpers/install-ohmyzsh-stuff.sh` to set the theme and plugin list.
- On Debian 13, run `sudo ./tools/helpers/install-docker-debian13.sh` to install Docker Engine, Buildx, and Compose. Log out and back in as `toor` for Docker group access. The `dockerkill` environment command force-removes all containers on the selected daemon.
- For VM installation and setup, see [Debian in VirtualBox](resources/VirtualBox.md) and [HTB on Kali](resources/HTB.md).

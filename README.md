# dotfiles

Bootstrap scripts and shell configuration for Debian- and Kali-based systems, with a shared Bash/Zsh environment.

## Install and update

Use a regular account with working `sudo`. On a preseeded VM, run `passwd` first to replace the public bootstrap password.

```sh
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/r00tGZ/dotfiles/master/init.sh)"
dotfiles install all
```

The initializer clones or updates `~/.dotfiles` and creates these absolute links, requesting sudo when needed:

- `/usr/local/bin/dotfiles` → `~/.dotfiles/dotfiles.sh`
- `/usr/local/share/zsh/site-functions/_dotfiles` → `~/.dotfiles/autocomplete.zsh`

It refuses unrelated entries at those paths. Zsh completion requires `compinit`; neither the command nor completion requires the optional shell environment.

Run `dotfiles install <selection>` as your regular user:

- `all`: software, configs and environment.
- `software`: packages in `installs/software/packages.lst`.
- `configs`: Vim/tmux links from `installs/configs/MANIFEST.tsv`; replaced files receive timestamped backups beside the originals.
- `environment`: add the loader to `.bashrc` and `.zshrc`. Restart your shell afterward.

Rerun the initializer to update the repository, then rerun the affected install selections. Keep `~/.dotfiles` in place: installed links depend on it. When moving from an older layout, remove obsolete loader lines from your shell startup files and reinstall environment/configs.

Optional [Oh My Zsh installation](https://github.com/ohmyzsh/ohmyzsh#basic-installation) may replace `.zshrc`; rerun `dotfiles install environment` afterward.

## Profiles

Run an included profile with `dotfiles profile <name>`. The included profiles assume an existing `toor` account and use APT to refresh indexes, clean cached packages and remove unused dependencies. They stop if a maintenance step fails. The dispatcher does not check the operating system, so select a profile suitable for the system.

- `debian`: create `/toor`, owned by `toor`.
- `kali-off`: create `/toor` and add `toor` to the Wireshark group if it exists.
- `kali-htb`: create `/box`, apply the same Wireshark group membership, install `build-essential` and `seclists`, and download the latest LinPEAS and PrivescCheck to `/opt/linpeas.sh` and `/opt/PrivescCheck.ps1` without executing them. Requires `wget` from `dotfiles install software`; reruns overwrite these downloads, even if a transfer fails.

Log out and back in after group changes. Wireshark capture permissions depend on its package configuration.

## Optional Docker installation

The Docker installer configures access for the `toor` account:

```sh
sudo ~/.dotfiles/installs/software/install-docker.sh
# Kali: supply the matching Debian codename explicitly.
sudo env DOCKER_CODENAME=trixie ~/.dotfiles/installs/software/install-docker.sh
```

Use the appropriate command for your system, then log out and back in. Docker group membership grants effectively root-level access.

Warning: the `dockerkill` shell helper immediately force-removes **all containers** and prunes unused Docker resources on the selected daemon, without confirmation. Do not use it in production.

## OS installation

See [preseeds/README.md](preseeds/README.md) for standalone Debian/Kali installer files. Bare metal keeps account and disk choices interactive. Both VM files **erase `/dev/sda` without asking**, create `toor` / `toor`, and power off when finished.

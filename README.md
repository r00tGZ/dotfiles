# dotfiles

Personal bootstrap files for fresh Debian and Kali machines and VMs. The shared shell environment supports Bash and Zsh and adds `~/.dotfiles/installs/environment/bin` to `PATH`.

## Install

Install the small bootstrap set:

```sh
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
```

Run the initializer as the regular user:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/r00tGZ/dotfiles/master/init.sh)"
```

The initializer clones or updates the project at `~/.dotfiles`, adds an executable `dotfiles` command under `/usr/local/bin`, and installs its Zsh completion under `/usr/local/share/zsh/site-functions`. It asks for `sudo` when creating those links and does not configure the machine itself.

Use the new command to install the selected components:

```sh
dotfiles install all
```

The available installation selections are:

- `all`: install `installs/software/packages.lst`, link configs, and enable the shell environment.
- `environment`: enable the shell environment in `.bashrc` and `.zshrc`.
- `software`: install `installs/software/packages.lst`.
- `configs`: link the files declared in `installs/configs/MANIFEST.tsv`.

For example:

```sh
dotfiles install environment
```

The `dotfiles` command and its Zsh completion are independent of the optional shell environment. Run the bootstrap command again whenever the repository itself needs updating. Existing managed config files are timestamp-backed up, and repeated installation runs are safe.

For an optional Zsh setup, install Oh My Zsh with its suggested curl command:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Its installer replaces an existing `.zshrc`, so run `dotfiles install environment` again afterward.

## Preseeds

- `preseeds/base.cfg` contains the shared installer answers. Use `debian-bare.cfg` for interactive bare-metal partitioning, `debian-vm.cfg` for a Debian VM, or `kali-vm.cfg` for a default Xfce Kali VM. Both VM preseeds erase the first detected disk. Keep all four files together so the final preseeds can include the base.
- For network preseeding, boot with `auto=true priority=critical url=<final-preseed-url>` and point `url` to a final preseed, not the shared base.
- The preseeds create `toor` with the public bootstrap password `s3cr3t`; change it before exposing the machine to a network service.

## Software

- `installs/software/packages.lst` is the full package set used by the `all` and `software` selections.
- `installs/software/install-docker.sh` installs Docker and grants access to `toor`. Run it with `sudo ~/.dotfiles/installs/software/install-docker.sh`, then log out and back in. Docker group membership is effectively root-level access. On a derivative such as Kali, pass its matching base codename, for example `sudo env DOCKER_CODENAME=trixie ~/.dotfiles/installs/software/install-docker.sh`.

## Profiles

Apply one final profile after installing Kali:

```sh
dotfiles profile kali-htb  # or kali-off
```

The command requests root access when needed. Both profiles run the internal Kali base, which grants `toor` access to Wireshark capture when Wireshark is installed. `kali-htb` creates `/box`; `kali-off` creates `/toor`. The directories belong to `toor`, and the profiles are safe to run again. Log out and back in after the first run so new group membership takes effect.

`profiles/_run.sh` remains an internal dispatcher. The internal `kali-base` is not a selectable profile.

Current Kali packages already give Nmap the capabilities required for privileged scans, and Kali allows unprivileged processes to listen on low ports by default. The profiles deliberately leave those distribution defaults alone. General `sudo` remains password-protected.

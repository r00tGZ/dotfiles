# Project instructions

## Purpose

This is a small personal bootstrap repository for fresh Debian and Kali machines and VMs. It is public only so it can be installed easily. Optimize for one owner, direct code, and easy inspection.

Keep changes narrow. Do not introduce dotfile frameworks, plugin systems, generated configuration, cross-platform abstraction, or elaborate test infrastructure unless explicitly requested.

## Design

- Bash and Zsh are the supported interactive shells. Shared shell files must work in both.
- `init.sh` is the public POSIX `sh` bootstrap. It accepts no arguments, must work when invoked with `sh -c "$(curl ...)"`, and must not depend on its own filename or the current directory. It only clones or updates `~/.dotfiles`, exposes the `dotfiles` command, and installs its Zsh completion.
- `dotfiles.sh` is the POSIX `sh` command controller. `/usr/local/bin/dotfiles` is an absolute symlink to it, and the controller must resolve that link before locating repository files. Keep the command usable without loading `installs/environment/_load.sh`.
- `autocomplete.zsh` is the top-level, static Zsh completion definition for the public `dotfiles` commands. `init.sh` exposes it as the absolute `/usr/local/share/zsh/site-functions/_dotfiles` symlink; it must not depend on `installs/environment/_load.sh`. Keep its choices synchronized with `dotfiles.sh`.
- The public command forms are `dotfiles install <all|environment|software|configs>` and `dotfiles profile <kali-htb|kali-off>`. Installation runs as the regular user and elevates only the operations that require root access.
- `installs/` contains the three components managed by `dotfiles install`: `environment/`, `software/`, and `configs/`.
- `installs/environment/_load.sh` is sourced by both `.bashrc` and `.zshrc` and owns loading aliases, functions, variables, and personal commands into `PATH`.
- Personal environment commands live in `installs/environment/bin/`, which is added to `PATH` as one directory. The global `dotfiles` controller is the only exception; do not recreate a multi-directory PATH scheme.
- `installs/configs/MANIFEST.tsv` contains exactly two tab-separated fields per row: a file under `installs/configs/` and its destination relative to `$HOME`.
- `preseeds/base.cfg` is the distribution-neutral shared base. `debian-bare.cfg`, `debian-vm.cfg`, and `kali-vm.cfg` include it and own their distribution and disk-specific behavior; never put mirror, task selection, bootloader, or destructive partition answers in the base.
- `profiles/_run.sh` is the root-only internal dispatcher used by `dotfiles profile`. Kali profiles always run the internal `kali-base.sh` first; do not expose the base as a direct dispatcher option.
- Third-party installers belong in `installs/software/`; small final machine adjustments belong in `profiles/`.

## Change rules

- Preserve existing personal choices unless the user asks to change them.
- Keep installers safe to rerun and back up files before replacing them.
- Refuse to overwrite unrelated `/usr/local/bin/dotfiles` or `/usr/local/share/zsh/site-functions/_dotfiles` entries during bootstrap.
- Keep destructive behavior explicit and documented. `installs/environment/bin/dockerkill` is intentionally immediate, non-interactive, and unsuitable for production environments.
- Do not change the user's default shell; optional shell frameworks handle that separately.
- Prefer standard shell tools over new dependencies.
- Add required system packages to `installs/software/packages.lst`; keep the preseed package subset limited to a usable first boot.
- Do not add private keys, tokens, or real credentials. The public `s3cr3t` value is a disposable bootstrap password and must not be treated as a secret.

## Verification

- Check `#!/bin/sh` files with `sh -n`, and check shared startup files with both `bash -n` and `zsh -n`.
- Source `installs/environment/_load.sh` in clean Bash and Zsh sessions and verify that repeated loading does not duplicate `PATH` entries.
- Verify that the bootstrap creates the `_dotfiles` completion link and that standard Zsh `compinit` registers it without loading the environment or Oh My Zsh.
- Validate every `preseeds/*.cfg` file with `debconf-set-selections -c` when available.
- Test the streamed bootstrap with a temporary `HOME`, command path, and completion path, including a second run for idempotency.
- Test every `dotfiles install` selection with a temporary `HOME`, including a second run for idempotency. Mock privileged package commands.
- Check profile dispatcher failures locally, but run profiles only inside a disposable matching machine.
- Never run package installation, Docker installation, or destructive profiles against the current machine merely as a test.

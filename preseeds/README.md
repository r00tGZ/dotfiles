# Preseeds

Standalone files for Debian 13 (trixie) amd64 installer/netinst media and Kali amd64 Installer media. All select English, a Spanish keyboard and the Madrid timezone. No shared base file is needed.

## Choose a file

- [debian-bare.cfg](debian-bare.cfg): interactive account, disk and bootloader setup, with an editable Xfce desktop selection. Firmware repositories and security/point updates are enabled. Normal completion prompt.
- [debian-vm.cfg](debian-vm.cfg): disposable VirtualBox VM with one SATA disk at `/dev/sda`, NAT/DHCP and Internet access. Installs standard utilities, Xfce, LightDM, Firefox ESR and editors. Guest additions are optional and must be installed separately.
- [kali-vm.cfg](kali-vm.cfg): the same VM assumptions, with Xfce, default Kali tools and VirtualBox guest tools.

**Both VM files erase `/dev/sda` without confirmation**, create `toor` with password `toor` and sudo access, and power off afterward. Run `passwd` after first login, before exposing services. Bare metal lets you choose credentials; use the account name `toor` if you intend to use the repository's profiles or Docker helper.

## Load

Serve the selected file at a URL reachable by the installer. Use **Advanced options → Automated install**, or add these boot parameters to the installer entry:

```text
# Bare metal: retain normal questions.
auto=true priority=high url=YOUR_PRESEED_URL

# Disposable VM: unattended installation.
auto=true priority=critical url=YOUR_PRESEED_URL
```

For bare metal, replace any existing `priority=critical` with `priority=high`. Do not combine it with another preseed that supplies disk/write approvals. Networking must work before a network preseed can be fetched; provide Wi-Fi settings when needed.

Review all bare-metal formatting and EFI partition choices. Interactive partitioning still writes to disk when approved. Debian mirrors are pinned to `trixie`; neither Debian file requests an SSH server or passwordless sudo.

## Validation

```sh
for file in preseeds/*.cfg; do debconf-set-selections -c "$file"; done
```

Run from the repository root. This checks format only; installation, partitioning and bootloader behavior require a disposable VM test.

Reference: [Debian Installer preseeding guide](https://www.debian.org/releases/trixie/amd64/apb.en.html).

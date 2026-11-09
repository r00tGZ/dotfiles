# Debian in VirtualBox

## VM settings

| VirtualBox section | Preferences |
| --- | --- |
| System → Motherboard | At least 4 GB RAM, PIIX3 chipset, I/O APIC on. Leave EFI off unless testing UEFI. |
| System → Processor | 2–4 vCPUs, 100% execution cap, PAE/NX on. Enable nested VT-x/AMD-V only for virtualization inside the guest. |
| System → Acceleration | KVM paravirtualization, nested paging on. |
| Display → Screen | Use VMSVGA with 128 MB of video memory. Disable 3D acceleration for VMs that run Burp. For other VMs, leave it on unless you see display issues. |
| Storage | One dynamically allocated VDI on SATA/AHCI, 20–40 GB for Debian. |
| Network → Adapter 1 | NAT by default. |

## Boot with a preseed

**The VM preseed erases `/dev/sda` without confirmation.** Attach the Debian 13 amd64 netinst ISO. In the VM’s boot menu, highlight the installer entry.

- **BIOS (EFI off):** Press **Tab** to edit the boot parameters.
- **UEFI:** Press **e**, find the line beginning with `linux`, and press **End** on that line.

On the **host**, run the hook below, replacing `Debian` with the VirtualBox VM name. Keep the leading space inside the argument so it appends cleanly.

```sh
VBoxManage controlvm "Debian" keyboardputstring \
  " auto=true priority=critical language=en country=ES locale=en_US.UTF-8 keymap=es interface=auto hostname=debian-vm domain= url=https://raw.githubusercontent.com/r00tGZ/dotfiles/core/tools/preseeds/debian-vm.cfg"
```

Inspect the appended text in the VM, then press **Enter** (BIOS) or **F10** (UEFI) to boot. The installer fetches the preseed from GitHub, so publish it on `core` first. After the installer powers off, take a **Pristine Debian VM from preseed** snapshot. On first boot, sign in to Xfce as `toor` with the public password `toor` and change it with `passwd`.

## Set up the guest

1. Open **Power Manager** and choose when the display turns off and when the guest suspends.
2. Open the sound controls, select the output device, and set the volume.
3. Add your usual applications to the Xfce panel and arrange their launchers.
4. Open **Xfce Terminal → Edit → Preferences** and set the font and colors.
5. Launch Firefox once to create its profile and complete the first-run prompts.

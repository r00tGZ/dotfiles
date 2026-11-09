### 1. VirtualBox VM settings

| VirtualBox section             | Setting                      | Recommended                                              |
| ------------------------------ | ---------------------------- | -------------------------------------------------------- |
| **System → Motherboard**       | Base Memory                  | **4 GB minimum; 6–8 GB** for Kali/Burp/browser-heavy use |
| **System → Motherboard**       | Chipset                      | **PIIX3**                                                |
| **System → Motherboard**       | I/O APIC                     | **Enabled**                                              |
| **System → Motherboard**       | EFI                          | **Disabled** unless specifically testing UEFI            |
| **System → Processor**         | Processor(s)                 | **2–4 vCPUs**                                            |
| **System → Processor**         | Execution Cap                | **100%**                                                 |
| **System → Processor**         | PAE/NX                       | **Enabled**                                              |
| **System → Processor**         | Nested VT-x/AMD-V            | **Disabled** unless running virtualization inside the VM |
| **System → Acceleration**      | Paravirtualization Interface | **KVM**                                                  |
| **System → Acceleration → HW** | Nested Paging                | **Enabled**                                              |
| **Display → Screen**           | Graphics Controller          | **VMSVGA**                                               |
| **Display → Screen**           | Video Memory                 | **128 MB**                                               |
| **Display → Screen**           | 3D Acceleration              | **Enabled**; disable only if it causes graphical issues  |
| **Storage**                    | Controller                   | **SATA / AHCI**                                          |
| **Storage**                    | Virtual Disk                 | **Dynamically allocated VDI**                            |
| **Storage**                    | Disk Size                    | ~**30–50 GB Kali**, ~**20–40 GB Debian**                 |
| **Network**                    | Adapter 1                    | **NAT** by default                                       |

### 2. VirtualBox preseed fetch

Run on the host with the VM's installer boot-parameter line open for editing. Inspect the appended text, then boot. The preseed erases the VM's `/dev/sda`; push repository changes first to use them from this URL.

```sh
VBoxManage controlvm "Kali" keyboardputstring \
  " auto=true priority=critical language=en country=ES locale=en_US.UTF-8 keymap=es interface=auto hostname=kali domain= url=https://raw.githubusercontent.com/r00tGZ/dotfiles/master/preseeds/kali-vm.cfg"
```

### Snapshot: Pristine Kali VM from preseed

### 3. Manual steps

###### Configurations

- Power & Sound
- Favorite apps
- Cherrytree
- Geany
- Terminal

###### Awakenings

- Firefox
- Metasploit
- Burp + browser
- Nuclei templates

### Snapshot: Ready-to-use Kali VM

### 4. Dotfiles

Run inside the installed VM as `toor`. First run `passwd` to replace the public bootstrap password.

```zsh
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
curl -fsSL https://raw.githubusercontent.com/r00tGZ/dotfiles/master/init.sh | sh
dotfiles install all
dotfiles profile kali-htb
```

### 5. Final HTB tweaks

- HTB Cherrytree file
- VPN file on /etc + OpenVPN GUI
- `updatedb`
- Delete `~/.bash_history` and `~/.zsh_history`

### Snapshot: Ready-to-use Kali VM, opinionated and HTB focused

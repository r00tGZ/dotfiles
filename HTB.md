### VirtualBox preseed fetch

Run on the host with the VM's installer boot-parameter line open for editing. Inspect the appended text, then boot. The preseed erases the VM's `/dev/sda`; push repository changes first to use them from this URL.

```sh
VBoxManage controlvm "Kali" keyboardputstring \
  " auto=true priority=critical language=en country=ES locale=en_US.UTF-8 keymap=es interface=auto hostname=kali domain= url=https://raw.githubusercontent.com/r00tGZ/dotfiles/master/preseeds/kali-vm.cfg"
```

### Dotfiles

Run inside the installed VM as `toor`. First run `passwd` to replace the public bootstrap password.

```sh
sudo apt-get update
sudo apt-get install -y ca-certificates curl git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/r00tGZ/dotfiles/master/init.sh)"
dotfiles install all
dotfiles profile kali-htb
```

### Manual steps

###### Configurations

- Power & Sound
- Terminal
- Cherrytree + file (Kali)
- OpenVPN GUI? (Kali)

###### Awakenings

- Burp + browser
- Firefox
- Metasploit
- Nuclei templates

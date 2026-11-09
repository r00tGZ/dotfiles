# HTB on Kali

1. Allocate 30–50 GB of disk and 6–8 GB of RAM. Disable **Display → Screen → Enable 3D Acceleration** for Burp. Use the [VirtualBox preseed hook](VirtualBox.md#boot-with-a-preseed) with VM name `Kali`, `hostname=kali`, and filename `kali-vm.cfg`. After installation, take the **Pristine Kali VM from preseed** snapshot.
2. Apply the shared desktop preferences, configure CherryTree, and launch Firefox, Metasploit, and Burp with its browser. Initialize the Nuclei templates. Take the **Ready-to-use Kali VM** snapshot.
3. Install the [dotfiles](../README.md#install) and run `dotfiles install sw core htb`. Configure Geany. From the checkout, run `sudo sh tools/helpers/init-htb.sh`. In your own shell with autojump loaded, run `(cd /box && j -i 1000)` to give the directory its jump weight.
4. Set up the HTB CherryTree file, place the VPN file under `/etc`, and configure the OpenVPN GUI. Run `updatedb` and delete `~/.bash_history` and `~/.zsh_history` before taking the final **Ready-to-use Kali VM, opinionated and HTB focused** snapshot.

# LUKS Remote Unlock via Dropbear SSH

This project enables remote unlocking of LUKS-encrypted root partitions on Ubuntu servers during boot using Dropbear SSH.

By installing a lightweight Dropbear SSH server into the initramfs, you can unlock encrypted disks remotely without physical access or KVM consoles.

---

## Features

- Supports Ubuntu/Debian with LUKS encrypted root partitions  
- Dropbear SSH server listens during early boot for remote unlocking  
- SSH key-based authentication for security (no passwords)  
- Customizable Dropbear options (e.g., custom port, session timeout)  
- Automated deployment script to install and configure Dropbear remotely

---

## Prerequisites

- Ubuntu/Debian server with LUKS encrypted root partition  
- SSH access with sudo privileges to the target machine  
- Your local machine with SSH keypair (RSA recommended)

---

## Quickstart: Deploy Dropbear Remote Unlock

1. Generate an SSH keypair (if you don't have one):

```bash
ssh-keygen -t rsa -f ~/.ssh/remote_luks_key
```

2. Deploy Dropbear initramfs remote unlock setup:

```bash
chmod +x deploy-dropbear.sh
./deploy-dropbear.sh <user>@<host> ~/.ssh/remote_luks_key.pub
```

Replace `<user>@<host>` with your remote Ubuntu username and IP address or hostname.

3. Reboot the remote machine:

```bash
ssh <user>@<host> sudo reboot
```

4. When the system boots and prompts for the LUKS passphrase, connect via Dropbear SSH:

```bash
ssh -i ~/.ssh/remote_luks_key -p 2222 root@<host> cryptroot-unlock
```

---

## How it works

- The script installs `dropbear-initramfs` on the remote host  
- Copies your SSH public key to Dropbear’s authorized keys for initramfs  
- Configures Dropbear to listen on port 2222 and disable password logins  
- Updates the initramfs image to include Dropbear and your keys  
- On boot, Dropbear starts early, letting you SSH in and run `cryptroot-unlock` to decrypt the disk

---

## Advanced Usage

- Modify `/etc/dropbear-initramfs/config` on the remote host to tweak Dropbear options  
- Use static IP settings in `/etc/initramfs-tools/initramfs.conf` for remote environments  
- Combine with firewall rules for enhanced security  

---

## License

MIT License — Use and modify freely.



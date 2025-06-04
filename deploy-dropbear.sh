#!/bin/bash

# deploy-dropbear.sh
# Automated script to install and configure Dropbear SSH remote unlock for LUKS on Ubuntu/Debian

if [ $# -ne 2 ]; then
  echo "Usage: $0 <user>@<host> <ssh-public-key-file>"
  exit 1
fi

TARGET="$1"
PUBKEY="$2"

echo "Deploying Dropbear initramfs remote unlock to $TARGET ..."

# Step 1: Install dropbear-initramfs
ssh "$TARGET" "sudo apt update && sudo apt install -y dropbear-initramfs"

# Step 2: Copy SSH public key to remote temp file
scp "$PUBKEY" "$TARGET":/tmp/temp_dropbear_key.pub

# Step 3: Append SSH key, configure Dropbear, update initramfs
ssh "$TARGET" << EOF
sudo mkdir -p /etc/dropbear-initramfs
sudo touch /etc/dropbear-initramfs/authorized_keys
sudo bash -c "cat /tmp/temp_dropbear_key.pub >> /etc/dropbear-initramfs/authorized_keys"
sudo rm /tmp/temp_dropbear_key.pub

# Configure Dropbear options for remote unlock
sudo tee /etc/dropbear-initramfs/config > /dev/null << CONFIG
DROPBEAR_OPTIONS="-I 180 -j -k -p 2222 -s -c cryptroot-unlock"
CONFIG

# Update initramfs
sudo update-initramfs -u
EOF

echo "Deployment complete! Reboot the target machine to test remote unlocking."

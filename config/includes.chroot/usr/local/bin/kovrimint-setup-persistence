#!/bin/bash
# KovriMint encrypted-persistence setup.
# RUN THIS FROM INSIDE A BOOTED KovriMint LIVE SESSION (not from your main OS).
#
# It creates a LUKS-encrypted partition in the free space of your USB stick,
# labels the unlocked volume "persistence", and writes persistence.conf so the
# live system picks it up on the next boot (you'll be asked for the passphrase
# at boot — that unlocks /home, wallet files, Tor state, wifi profiles).
#
#   sudo ./setup-persistence.sh
#
# DANGER: this partitions a disk. Triple-check the device name.
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: run as root: sudo $0"
    exit 1
fi

echo "=== Block devices ==="
lsblk -d -o NAME,SIZE,MODEL,TRAN | grep -v loop || true
echo
read -rp "USB stick device (e.g. /dev/sdb — NOT a partition like /dev/sdb1): " DISK

if [ ! -b "$DISK" ]; then
    echo "ERROR: $DISK is not a block device."
    exit 1
fi

echo
echo "!!! ALL DATA in the free space of $DISK will be used for an encrypted"
echo "!!! persistence partition. Existing partitions are left alone, but if"
echo "!!! you pick the wrong disk you can still destroy data. Be sure."
read -rp "Type YES to continue: " CONFIRM
[ "$CONFIRM" = "YES" ] || { echo "Aborted."; exit 1; }

# Create a new partition using all remaining free space
parted -s "$DISK" mkpart primary ext4 100% 100% || {
    # fallback: last 8 GiB if 100%-100% syntax fails on this layout
    parted -s "$DISK" mkpart primary ext4 -8192MB 100%
}
partprobe "$DISK"
sleep 2

PART="$(lsblk -ln -o NAME "$DISK" | tail -n1)"
PART="/dev/$PART"
echo ">>> New partition: $PART"

echo
echo ">>> Encrypting $PART with LUKS (you'll choose a passphrase — make it strong) ..."
cryptsetup luksFormat --type luks2 "$PART"
cryptsetup open "$PART" kovrimint-persist

mkfs.ext4 -L persistence /dev/mapper/kovrimint-persist

MNT="$(mktemp -d)"
mount /dev/mapper/kovrimint-persist "$MNT"

# What survives between boots (unioned over the read-only live system):
cat > "$MNT/persistence.conf" <<'EOF'
/home
/var/lib/tor
/etc/NetworkManager/system-connections
EOF

umount "$MNT"
cryptsetup close kovrimint-persist
rmdir "$MNT"

echo
echo ">>> DONE. Reboot, and at the boot prompt enter your LUKS passphrase"
echo ">>> when asked. Your /home (Feather wallets included) is now encrypted"
echo ">>> and persistent. Everything else stays amnesic."

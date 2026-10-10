# Encrypted persistence

## The idea

A stock KovriMint boot is **amnesic**: the system is read-only, everything
happens in RAM, shutdown wipes it. That's great for privacy and terrible for
usability — you'd restore your wallet from seed every boot.

Encrypted persistence fixes that: a LUKS-encrypted partition on the same USB
stick holds the directories you choose to keep. At boot, the live system asks
for your LUKS passphrase, unlocks the partition, and overlays it onto the
live filesystem. Everything else stays amnesic.

## What persists (v1)

Defined in `persistence.conf`, written by the setup script:

| Path | Why |
|---|---|
| `/home` | Feather wallets, configs, your files |
| `/var/lib/tor` | Tor cached descriptors (faster bootstrap) |
| `/etc/NetworkManager/system-connections` | Saved Wi-Fi networks |

Everything else — system files, logs, browser state outside Tor Browser's
own profile handling — vanishes on shutdown.

## Setting it up

1. Flash the ISO to a USB stick, **leaving unpartitioned free space** after it
   (a 16 GB+ stick with a ~3 GB ISO leaves plenty).
2. Boot KovriMint from the stick.
3. Open a terminal and run:

   ```bash
   sudo kovrimint-setup-persistence
   ```

4. Type the USB device (e.g. `/dev/sdb`), confirm with `YES`, choose a **strong
   passphrase** when `cryptsetup` asks.
5. Reboot. At the boot prompt, enter your LUKS passphrase when asked.

That's it. Create your Feather wallet — it'll be in `/home`, encrypted at
rest, available next boot.

## Security notes

- The passphrase is the whole game. Lose it and the partition is
  unrecoverable — by you and by anyone else. There is no reset.
- LUKS2 with argon2id is the default via `cryptsetup`. Good.
- Persistence slightly weakens the amnesic story: a forensic analyst with
  your passphrase (or a cold-boot attack while running) can read `/home`.
  That's the documented trade-off; pure amnesic mode (just don't set up
  persistence) remains the strongest option.
- Back up your wallet seed phrase on paper regardless. Persistence is
  convenience, not backup.

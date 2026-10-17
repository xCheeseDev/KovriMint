# Building KovriMint

## Host requirements

- A Debian 13 ("trixie") machine — physical or VM. Building on other distros
  is unsupported for v1 (live-build bootstraps a Debian system; mismatched
  hosts cause subtle breakage).
- Root access (`sudo`).
- ~15 GB free disk space, 4 GB+ RAM.
- Internet access (the build downloads ~2 GB of Debian packages plus the
  Feather Wallet AppImage).

## Build steps

```bash
git clone https://github.com/xCheeseDev/KovriMint.git
cd KovriMint
sudo ./scripts/build.sh
```

That's it. The script installs `live-build` if missing, runs `lb clean`,
`lb config` (which reads `auto/config`), then `lb build`. Expect 20–60
minutes depending on your machine and network.

On success you'll have:

- `kovrimint-*.iso` (or similar) — the hybrid ISO, boots from USB or VM
- `*.iso.sha256` — checksum file

## Flashing to USB

```bash
# Replace /dev/sdX with your actual stick. TRIPLE-CHECK — this erases it.
sudo dd if=kovrimint-*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

Or use Balena Etcher if you prefer a GUI. Leave free space after the ISO
partition — that's where encrypted persistence goes (see PERSISTENCE.md).

## Testing in a VM first (recommended)

```bash
sudo apt install qemu-system-x86
qemu-system-x86_64 -m 4096 -enable-kvm -cdrom kovrimint-*.iso
```

Boot it, open Feather Wallet, browse with Tor Browser. If something's broken,
the fix goes in `config/` — see the repo layout in the README.

## How the build works

1. `auto/config` tells live-build: Debian trixie, XFCE, hybrid ISO, boot with
   `persistence persistence-encryption=luks` enabled.
2. `config/package-lists/kovrimint.list` selects every installed package.
3. `config/hooks/*.hook.chroot` run inside the new system during the build:
   branding, enabling Tor, downloading + PGP-verifying Feather Wallet.
4. `config/includes.chroot/` files are copied verbatim into the live system
   (torrc, MAC randomization, sysctl hardening, the START-HERE desktop note).

## Troubleshooting

- **Build fails downloading Feather:** the hook warns and continues without
  it — you'll get an ISO without Feather. Re-run when network is fine, or
  bump `FEATHER_VERSION` in `config/hooks/0120-feather.hook.chroot`.
- **Build fails downloading Cake Wallet or Brave:** same pattern — the
  `0125-cakewallet` and `0128-brave` hooks warn and continue without them.
  Re-run when network is fine.
- **`lb: command not found`:** the build script installs it; if you're calling
  `lb` manually, `sudo apt install live-build`.
- **Out of space:** `lb clean --purge` wipes the build tree (`cache/`,
  `chroot/`, `binary/`).

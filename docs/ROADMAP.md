# KovriMint roadmap

## v1 (this scaffold) — "it boots"
- [x] Debian trixie + XFCE live ISO via live-build
- [x] Tor daemon + Tor Browser
- [x] Feather Wallet (PGP-verified AppImage) + Debian monero CLI tools
- [x] MAC randomization, sysctl hardening
- [x] LUKS encrypted persistence (opt-in script)
- [x] KovriMint branding
- [ ] Actually build and boot-test the ISO (first real milestone)
- [ ] Fix whatever breaks (there will be things)

## v1.1 — hardening pass
- [ ] Hardware wallet support: udev rules for Ledger/Trezor, docs
- [ ] Firewall default-deny with Tor-only exceptions (nftables)
- [ ] Disable microphone/camera kernel modules by default
- [ ] Boot-time integrity notice / verified-boot exploration

## v2 — trust
- [ ] Reproducible builds (same source → bit-identical ISO)
- [ ] Signed releases + published signing key + verification docs
- [ ] Automated build pipeline (GitHub Actions) with build logs public
- [ ] Independent security review before any "safe for real use" claim

## Ideas (uncommitted)
- Tor transparent proxying (route ALL traffic through Tor, kill-switch style)
- I2P option alongside Tor
- ARM64 image (Raspberry Pi)
- Monero node bootstrap config (pruned node on persistence)
- Installer for "KovriMint on internal drive" variant

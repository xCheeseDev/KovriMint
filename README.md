# KovriMint

An amnesic, Monero-first live USB operating system. Boot any computer from a
USB stick into a clean workspace with a Monero wallet and Tor ready to go —
leave no trace on the host machine.

Built on **Debian 13 ("trixie")** with `live-build`.

> ⚠️ **v1 is experimental.** It boots, it works, it has not been audited.
> Read [docs/SECURITY.md](docs/SECURITY.md) before trusting it with real
> money.

## What's inside v1

- **XFCE desktop** — lightweight, fast off USB
- **Feather Wallet** (PGP-verified AppImage, always current) + **Cake Wallet**
  (SHA256-verified Linux build, multi-currency) + Debian's `monero` CLI tools
  (`monerod`, `monero-wallet-cli`)
- **Brave Browser (stable)** from Brave's official APT repo — the clearnet
  browser next to Tor Browser, with built-in ad/tracker blocking
- **qBittorrent** — clearnet downloads (never over Tor, see SECURITY.md)
- **Tor** daemon + Tor Browser, MAC address randomization, kernel hardening
- **Encrypted persistence (opt-in):** LUKS2 partition keeps `/home` (wallets),
  Tor state, and Wi-Fi profiles between boots; everything else stays amnesic
- **KovriMint branding** and a START-HERE note on the desktop

## Quick start

```bash
git clone https://github.com/xCheeseDev/KovriMint.git
cd KovriMint
sudo ./scripts/build.sh     # → produces a bootable .iso (20–60 min)
```

Full instructions: [docs/BUILD.md](docs/BUILD.md)
Encrypted persistence setup: [docs/PERSISTENCE.md](docs/PERSISTENCE.md)
Threat model & honest limitations: [docs/SECURITY.md](docs/SECURITY.md)
Where this is going: [docs/ROADMAP.md](docs/ROADMAP.md)

## Repo layout

```
auto/config                  # live-build configuration (Debian trixie, ISO settings)
config/
  package-lists/kovrimint.list   # every package baked into the ISO
  hooks/                         # build-time scripts (branding, Tor, wallet installs)
  includes.chroot/               # files copied into the live system (torrc, hardening…)
scripts/
  build.sh                   # one-command ISO builder (run as root)
  setup-persistence.sh       # LUKS encrypted-persistence setup (run from live session)
docs/                        # build guide, persistence guide, security model, roadmap
```

## Design decisions

- **Debian stable, not Ubuntu/Arch:** a privacy tool needs a stable,
  slow-moving base. Same stack Tails uses.
- **live-build, not Cubic:** everything is config files in git — reproducible,
  reviewable, AI-friendly to iterate on.
- **Feather over Monero GUI:** lighter, faster, Tor-aware, and the AppImage is
  PGP-verified during the build.
- **Persistence is opt-in:** default boot is fully amnesic. You choose the
  convenience/trace trade-off explicitly.

## Contributing

Issues and PRs welcome. If you know more about live-boot hardening than the
author (likely), your review is the most valuable contribution possible.

## License

MIT — see [LICENSE](LICENSE).

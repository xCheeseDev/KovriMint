# Security model — read this before trusting KovriMint with real money

> **v1 is an experimental personal build. It has not been audited by anyone.
> Do not use it for amounts you can't afford to lose until it has been
> independently reviewed.**

## What KovriMint v1 protects against

- **Host snooping:** booting from USB means the computer's installed OS never
  runs. No keyloggers from the host OS, no disk forensics on the host drive.
- **Network surveillance:** Tor daemon on board, Tor Browser for web, MAC
  address randomization on Wi-Fi/Ethernet, hardened sysctl defaults.
- **Casual theft/loss of the stick:** with encrypted persistence, `/home`
  (wallets) is LUKS2-encrypted. Without the passphrase it's noise.
- **"Oops I left traces":** default boot is amnesic — RAM-only, wiped on
  shutdown.

## What it does NOT protect against (v1 limitations)

- **Evil-maid / hardware attacks:** someone who tampers with the stick, the
  machine's firmware, or plants a hardware keylogger beats any live OS.
- **Cold-boot / DMA attacks:** RAM contents can theoretically be recovered
  from a running or recently-shut-down machine. Amnesia helps; it isn't magic.
- **Supply chain:** v1 ISOs are built by one person and not reproducibly.
  Until builds are reproducible and releases are signed + verified, you're
  trusting the builder. (See ROADMAP.md.)
- **Outdated Monero packages:** Debian's `monero` package can lag upstream.
  Feather Wallet (PGP-verified in the build) is the recommended wallet for v1.
- **User error:** phishing, clipboard hijackers on the *websites* you visit,
  and weak passphrases are still on you.

## Recommendations

1. Test with small amounts first. Then test recovery from seed. Then consider
   larger use.
2. Use a hardware wallet (Ledger/Trezor) for anything serious — v2 will add
   udev rules and docs for this.
3. Keep your seed phrase on paper, offline, in a separate location from the
   stick.
4. Verify ISO checksums, and when signed releases exist, verify signatures.

## Prior art worth knowing

- **Tails** — the gold standard amnesic OS (general-purpose, Debian-based).
- **Prestium** — a privacy-focused I2P-based live OS that bundles Feather
  Wallet. Closest existing project to KovriMint's concept.
- **Whonix** — Tor-isolated workstation/gateway design.

KovriMint's niche: Monero-first, boots straight into a wallet-ready
environment, rather than a general-purpose privacy desktop.

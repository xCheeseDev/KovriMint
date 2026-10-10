#!/bin/bash
# KovriMint ISO builder. Run from the repo root as root:
#   sudo ./scripts/build.sh
# See docs/BUILD.md for host requirements.
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    echo "ERROR: run as root: sudo ./scripts/build.sh"
    exit 1
fi

if ! command -v lb >/dev/null 2>&1; then
    echo ">>> Installing live-build ..."
    apt-get update
    apt-get install -y live-build
fi

echo ">>> Cleaning previous build ..."
lb clean --purge 2>/dev/null || lb clean 2>/dev/null || true

echo ">>> Configuring (auto/config) ..."
lb config

echo ">>> Building ISO (this takes a while, grab a coffee) ..."
lb build

ISO="$(ls -1t *.iso 2>/dev/null | head -n1 || true)"
if [ -n "$ISO" ]; then
    echo ">>> DONE: $ISO ($(du -h "$ISO" | cut -f1))"
    sha256sum "$ISO" | tee "$ISO.sha256"
else
    echo ">>> ERROR: no ISO produced — check the log above."
    exit 1
fi

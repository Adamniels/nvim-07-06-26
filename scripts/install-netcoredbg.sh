#!/usr/bin/env bash
# =============================================================================
# install-netcoredbg.sh — native arm64 netcoredbg for the C# debugger
# =============================================================================
# Mason's netcoredbg package is pinned to an x86_64 build (v3.1.3) even on
# darwin_arm64 — see lua/plugins/debug/dap.lua for why that breaks debugging
# on Apple Silicon ("Failed command 'configurationDone' : 0x80131c3c").
# This installs Samsung's native arm64 build to the path dap.lua prefers:
#   ~/.local/share/netcoredbg/netcoredbg/netcoredbg
#
# Usage: ./scripts/install-netcoredbg.sh
# Safe to re-run — always fetches and overwrites with the latest release.

set -euo pipefail

if [[ "$(uname -m)" != "arm64" ]]; then
  echo "Not running on arm64 — Mason's netcoredbg build works fine here, nothing to do."
  exit 0
fi

install_dir="$HOME/.local/share/netcoredbg"
tmp_zip="$(mktemp -t netcoredbg).zip"
trap 'rm -f "$tmp_zip"' EXIT

echo "Looking up latest netcoredbg release..."
download_url=$(curl -sL https://api.github.com/repos/Samsung/netcoredbg/releases/latest \
  | grep '"browser_download_url"' \
  | grep 'osx-arm64' \
  | sed -E 's/.*"(https[^"]+)".*/\1/')

if [[ -z "$download_url" ]]; then
  echo "Could not find an osx-arm64 asset in the latest release. Aborting." >&2
  exit 1
fi

echo "Downloading $download_url"
curl -sL -o "$tmp_zip" "$download_url"

mkdir -p "$install_dir"
unzip -q -o "$tmp_zip" -d "$install_dir"

binary="$install_dir/netcoredbg/netcoredbg"
if [[ ! -x "$binary" ]]; then
  echo "Install finished but $binary is missing or not executable." >&2
  exit 1
fi

# Downloaded via curl, so macOS will quarantine it — strip that or the
# debug adapter fails to launch with a Gatekeeper prompt.
xattr -d com.apple.quarantine "$binary" 2>/dev/null || true

echo "Installed: $("$binary" --version | head -1)"
echo "at $binary"

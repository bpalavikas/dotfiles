#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Do NOT run as root."
  exit 1
fi

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }
need_cmd curl
need_cmd bash

echo "[1/5] Node.js via NVM"
# Install NVM (official install method is via their install script)
# NOTE: pinning exact version is your choice; this uses the latest install endpoint.
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load nvm for this script run
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"

# Install latest LTS Node
nvm install --lts
nvm alias default 'lts/*'

echo "[2/5] TypeScript tooling (global in NVM’s Node context)"
npm install -g typescript ts-node

echo "[3/5] SDKMAN + Kotlin"
curl -s "https://get.sdkman.io" | bash
# Load sdkman for this script run
# shellcheck disable=SC1091
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install kotlin  # Kotlin docs recommend SDKMAN :contentReference[oaicite:6]{index=6}

echo "[4/5] R (CRAN repo helper hint)"
echo "R is best installed via APT as root (see 44-r-setup.sh)."

echo "[5/5] Done"
echo "Open a new shell (or source your rc files) to pick up nvm/sdkman."

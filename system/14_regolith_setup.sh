#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: sudo $0 {x11|wayland}"
  exit 1
}

if [[ $# -ne 1 ]]; then usage; fi

SESSION_MODE="$1"
if [[ "$SESSION_MODE" != "x11" && "$SESSION_MODE" != "wayland" ]]; then
  usage
fi

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0 {x11|wayland}"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

USER_NAME="${SUDO_USER:-}"
if [[ -z "$USER_NAME" || "$USER_NAME" == "root" ]]; then
  echo "Run via sudo from your normal user."
  exit 1
fi

USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"
DOTFILES_DIR="${USER_HOME}/dotfiles"

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }
need_cmd wget
need_cmd gpg
need_cmd tee
need_cmd lsb_release
need_cmd apt

ARCH="$(dpkg --print-architecture)"   # amd64, arm64, etc.
CODENAME="$(lsb_release -cs)"         # noble, jammy, etc.

# Session package selection (per Regolith docs)
# X11: regolith-session-flashback
# Wayland: regolith-session-sway
# :contentReference[oaicite:2]{index=2}
if [[ "$SESSION_MODE" == "x11" ]]; then
  SESSION_PKG="regolith-session-flashback"
else
  SESSION_PKG="regolith-session-sway"
fi

LOOK_PKG="regolith-look-blackhole"

echo "[1/7] Add Regolith apt keyring"
wget -qO - https://archive.regolith-desktop.com/regolith.key \
  | gpg --dearmor \
  | tee /usr/share/keyrings/regolith-archive-keyring.gpg > /dev/null

echo "[2/7] Add Regolith apt repo (stable)"
# Use stable suite + "main" component to track current release.
# Docs show the same pattern with fixed vX.Y components; we use main.
# :contentReference[oaicite:3]{index=3}
echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/regolith-archive-keyring.gpg] \
https://archive.regolith-desktop.com/ubuntu/stable ${CODENAME} main" \
  > /etc/apt/sources.list.d/regolith.list

echo "[3/7] Install Regolith + session + Blackhole look"
apt update -y
apt install -y \
  regolith-desktop \
  "${SESSION_PKG}" \
  "${LOOK_PKG}"

echo "[4/7] Best-effort: set look to blackhole for the user"
# Installing a look at install time is recommended; setting it explicitly is harmless.
# If the command isn't available until first login, we just skip.
sudo -u "$USER_NAME" bash <<'EOF'
set -euo pipefail
if command -v regolith-look >/dev/null 2>&1; then
  regolith-look set blackhole || true
fi
EOF

echo "[5/7] Stow Regolith dotfiles (last step)"
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "ERROR: dotfiles directory not found: $DOTFILES_DIR"
  exit 1
fi
if ! command -v stow >/dev/null 2>&1; then
  echo "ERROR: stow not found (should be installed earlier)."
  exit 1
fi

# Prefer laptop profile + shared regolith3 if present.
sudo -u "$USER_NAME" bash <<EOF
set -euo pipefail
cd "$DOTFILES_DIR"

# Shared baseline (if you use it)
if [[ -d "regolith3" ]]; then
  stow -R regolith3
fi

# Laptop profile (preferred on this machine)
if [[ -d "regolith-laptop" ]]; then
  stow -R regolith-laptop
elif [[ -d "regolith-desktop" ]]; then
  stow -R regolith-desktop
fi
EOF

echo "[6/7] Reminder: select the session on login"
echo "On the login screen, choose the Regolith session:"
echo "  - X11: Regolith (Flashback)"
echo "  - Wayland: Regolith (Sway)"
echo "(Package installed: ${SESSION_PKG})"

echo "[7/7] Reboot recommended"
echo "Reboot so the display manager picks up the new session entries."

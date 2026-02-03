#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0"
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

echo "[1/7] Install build dependencies for Alacritty"
apt update -y
apt install -y --no-install-recommends \
  pkg-config \
  libfreetype6-dev \
  libfontconfig1-dev \
  libxkbcommon-dev \
  libxcb-xfixes0-dev

echo "[2/7] Install rustup (user) if missing + update toolchain"
sudo -u "$USER_NAME" bash <<'EOF'
set -euo pipefail

if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

source "$HOME/.cargo/env"
rustup default stable
rustup update
rustup component add rustfmt clippy
EOF

echo "[3/7] cargo install alacritty (user)"
sudo -u "$USER_NAME" bash <<'EOF'
set -euo pipefail
source "$HOME/.cargo/env"

# Install/update Alacritty
cargo install --locked alacritty
EOF

ALACRITTY_USER_BIN="${USER_HOME}/.cargo/bin/alacritty"
if [[ ! -x "$ALACRITTY_USER_BIN" ]]; then
  echo "ERROR: Alacritty not found at ${ALACRITTY_USER_BIN}"
  exit 1
fi

echo "[4/7] Make Alacritty available system-wide"
install -D -m 0755 "$ALACRITTY_USER_BIN" /usr/local/bin/alacritty

echo "[5/7] Register as default x-terminal-emulator"
update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/alacritty 50
update-alternatives --set x-terminal-emulator /usr/local/bin/alacritty || true

echo "[6/7] Set GNOME default terminal (best-effort)"
sudo -u "$USER_NAME" bash <<'EOF'
set -euo pipefail
if gsettings writable org.gnome.desktop.default-applications.terminal exec >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.default-applications.terminal exec 'alacritty'
  if gsettings writable org.gnome.desktop.default-applications.terminal exec-arg >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg ''
  fi
fi
EOF

echo "[7/7] Stow Alacritty dotfiles (only if present)"
if [[ -d "${DOTFILES_DIR}/alacritty" ]]; then
  # stow should already be installed in essentials
  if ! command -v stow >/dev/null 2>&1; then
    echo "ERROR: stow not found (should be installed in essentials)"
    exit 1
  fi

  sudo -u "$USER_NAME" bash <<EOF
set -euo pipefail
cd "${DOTFILES_DIR}"
stow -R alacritty
EOF
else
  echo "NOTE: ${DOTFILES_DIR}/alacritty not found; skipping stow."
fi

echo "Done: Rust + Alacritty installed, set as default terminal, and dotfiles stowed."

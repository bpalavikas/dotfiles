#!/usr/bin/env bash
set -euo pipefail


if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

USER_NAME="${SUDO_USER:-}"
if [[ -z "$USER_NAME" || "$USER_NAME" == "root" ]]; then
  echo "Run via sudo from a normal user."
  exit 1
fi

USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"
REPO_DIR="${USER_HOME}/repo"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing command: $1"; exit 1; }
}

need_cmd git
need_cmd curl
need_cmd install

echo "[1/6] Create ~/repo"
sudo -u "$USER_NAME" mkdir -p "$REPO_DIR"

echo "[2/6] Clone upstream repos (if missing)"

clone_if_missing() {
  local url="$1"
  local dir="$2"

  if [[ -d "$dir/.git" ]]; then
    echo "Already exists: $dir"
  else
    sudo -u "$USER_NAME" git clone "$url" "$dir"
  fi
}

clone_if_missing https://github.com/neovim/neovim.git \
  "${REPO_DIR}/neovim"

clone_if_missing https://github.com/sezanzeb/input-remapper.git \
  "${REPO_DIR}/input-remapper"

echo "[3/6] Install Neovim (AppImage)"
NVIM_BIN="/usr/local/bin/nvim"

if [[ -x "$NVIM_BIN" ]]; then
  echo "Neovim already installed at $NVIM_BIN"
else
  TMPDIR="$(mktemp -d)"
  trap 'rm -rf "$TMPDIR"' EXIT

  echo "Downloading Neovim AppImage"
  curl -fL \
    https://github.com/neovim/neovim/releases/latest/download/nvim.appimage \
    -o "${TMPDIR}/nvim.appimage"

  install -m 0755 "${TMPDIR}/nvim.appimage" "$NVIM_BIN"
fi

echo "[4/6] Verify Neovim install"
/usr/local/bin/nvim --version | head -n 2

echo "[5/6] Install input-remapper (APT)"
apt update -y
apt install -y --no-install-recommends input-remapper

echo "[6/6] Enable input-remapper service"
systemctl enable --now input-remapper || true

echo
echo "Done:"
echo "  ~/repo created"
echo "  neovim repo cloned"
echo "  input-remapper repo cloned"
echo "  Neovim installed at /usr/local/bin/nvim"
echo "  input-remapper installed and service enabled"

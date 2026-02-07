#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# 21-zsh-setup.sh
# - stow zsh dotfiles
# - install zsh-syntax-highlighting
# - set zsh as default shell
# ============================================================

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
ZSHRC="${USER_HOME}/.zshrc"

echo "[1/5] Stow zsh dotfiles"
if [[ ! -d "${DOTFILES_DIR}/zsh" ]]; then
  echo "ERROR: ${DOTFILES_DIR}/zsh not found"
  exit 1
fi

sudo -u "$USER_NAME" bash <<EOF
cd "${DOTFILES_DIR}"
stow -R zsh
EOF

echo "[2/5] Install zsh syntax highlighting"
apt update -y
apt install -y --no-install-recommends zsh-syntax-highlighting

echo "[3/5] Verify .zshrc exists"
if [[ ! -f "$ZSHRC" ]]; then
  echo "ERROR: ${ZSHRC} missing after stow"
  exit 1
fi

echo "[4/5] Set zsh as default shell"
ZSH_PATH="$(command -v zsh)"
chsh -s "$ZSH_PATH" "$USER_NAME"

echo "[5/5] Done"
echo "Log out and back in for zsh to become the default shell."

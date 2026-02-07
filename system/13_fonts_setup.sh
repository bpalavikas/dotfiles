#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  echo "Do NOT run as root."
  exit 1
fi

DOTFILES_DIR="${HOME}/dotfiles"
SRC_DIR="${DOTFILES_DIR}/system/fonts"
DEST_DIR="${HOME}/.local/share/fonts"

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }
need_cmd rsync
need_cmd fc-cache

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Fonts source directory not found: $SRC_DIR"
  exit 1
fi

mkdir -p "$DEST_DIR"

echo "[1/3] Copy fonts to user font directory"
# Copy only font files; keep directory structure (one folder per family)
# We ignore license/readme text but keep the folders.
rsync -av --delete \
  --include='*/' \
  --include='*.ttf' \
  --include='*.otf' \
  --exclude='*' \
  "${SRC_DIR}/" "${DEST_DIR}/dotfiles-fonts/"

echo "[2/3] Rebuild font cache (user)"
fc-cache -f "${DEST_DIR}"

echo "[3/3] List installed font families (quick check)"
# This prints unique family names containing your common nerd fonts keywords.
fc-list : family | tr ',' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//' | sort -u | grep -i -E 'hack|mononoki|courier' || true

echo "Done: fonts installed to ${DEST_DIR}/dotfiles-fonts/"

#!/usr/bin/env bash
set -euo pipefail


if [[ $EUID -eq 0 ]]; then
  echo "Do NOT run as root."
  exit 1
fi

DOTFILES_DIR="${HOME}/dotfiles"

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }
need_cmd stow

if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Dotfiles dir not found: $DOTFILES_DIR"
  exit 1
fi

cd "$DOTFILES_DIR"

for pkg in vim nvim tmux; do
  if [[ ! -d "$pkg" ]]; then
    echo "Missing stow package: $DOTFILES_DIR/$pkg"
    exit 1
  fi
done

echo "Stowing: vim nvim tmux"
stow -R -v vim nvim tmux

echo "Sanity checks:"
command -v tmux >/dev/null && echo "  tmux: OK" || echo "  tmux: NOT FOUND"
command -v nvim >/dev/null && echo "  nvim: OK" || echo "  nvim: NOT FOUND"
command -v vim  >/dev/null && echo "  vim:  OK" || echo "  vim:  NOT FOUND"

echo "Done: editor dotfiles stowed."

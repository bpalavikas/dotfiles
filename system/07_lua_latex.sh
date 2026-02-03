#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt update -y

echo "[1/3] Lua"
apt install -y --no-install-recommends \
  lua5.4 \
  luarocks

echo "[2/3] LaTeX (recommended workstation set)"
# Avoid texlive-full unless you explicitly want the huge install.
# This set covers most academic docs + bib + latexmk.
apt install -y --no-install-recommends \
  texlive-latex-recommended \
  texlive-latex-extra \
  texlive-fonts-recommended \
  texlive-science \
  texlive-bibtex-extra \
  latexmk \
  biber

echo "[3/3] Cleanup"
apt autoremove -y
apt autoclean -y

echo "Done: Lua + LaTeX installed."

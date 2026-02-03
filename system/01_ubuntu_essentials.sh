#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "[0/8] Preseed license prompts (ms core fonts via ubuntu-restricted-extras)"
# Prevent interactive EULA prompt from blocking automation.
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" \
  | debconf-set-selections

echo "[1/8] Update + upgrade"
apt update -y
apt full-upgrade -y

echo "[2/8] Restricted extras (codecs + fonts)"
# Day-1 desktop requirement: media codecs + fonts
apt install -y ubuntu-restricted-extras ubuntu-restricted-addons

echo "[3/8] Base APT + CLI essentials"
apt install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  wget \
  gnupg \
  lsb-release \
  software-properties-common \
  jq \
  unzip \
  zip \
  tar \
  xz-utils \
  rsync \
  tree \
  less \
  vim \
  nano \
  man-db \
  manpages \
  htop \
  tmux \
  fzf \
  ripgrep \
  ncdu  \
  stow

echo "[4/8] Core dev toolchain"
apt install -y --no-install-recommends \
  git \
  build-essential \
  g++ \
  cmake \
  ninja-build \
  pkg-config \
  gdb \
  strace \
  clang \
  clang-format \
  clang-tidy

echo "[5/8] Desktop setup basics"
apt install -y --no-install-recommends \
  gnome-tweaks \
  dconf-editor \
  flameshot \
  xclip \
  xsel \
  wl-clipboard

echo "[6/8] Laptop / hardware basics"
apt install -y --no-install-recommends \
  network-manager \
  blueman \
  bluez \
  powertop \
  acpi \
  lm-sensors \
  usbutils \
  pciutils

# sensors can be configured later interactively if you want:
#   sudo sensors-detect

echo "[7/8] Locale (AU English) + common spelling dictionary"
apt install -y --no-install-recommends \
  language-pack-en \
  language-pack-en-base \
  language-pack-gnome-en \
  language-pack-gnome-en-base \
  wbritish

# Set defaults (safe if already set)
if command -v locale-gen >/dev/null 2>&1; then
  locale-gen en_AU.UTF-8 || true
  update-locale LANG=en_AU.UTF-8 || true
fi

echo "[8/8] Cleanup"
apt autoremove -y
apt autoclean -y

echo "Done: Ubuntu desktop essentials installed."

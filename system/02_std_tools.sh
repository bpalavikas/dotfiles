#!/usr/bin/env bash
set -euo pipefail


if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

have_pkg() {
  apt-cache show "$1" >/dev/null 2>&1
}

apt_install_if_available() {
  local p="$1"
  if have_pkg "$p"; then
    apt install -y --no-install-recommends "$p"
  else
    echo "Skipping (not in apt repos): $p"
  fi
}

echo "[1/5] Update package lists"
apt update -y

echo "[2/5] Networking & diagnostics"
apt install -y --no-install-recommends \
  iproute2 \
  net-tools \
  network-manager \
  iputils-ping iputils-arping iputils-tracepath \
  traceroute mtr-tiny \
  dnsutils whois avahi-utils \
  netcat-openbsd nmap telnet \
  curl wget \
  iftop nethogs bmon vnstat nload iptraf-ng \
  tcpdump tshark termshark \
  iw ethtool


echo "[3/5] Monitoring / performance"
apt_install_if_available atop
apt_install_if_available btop
apt_install_if_available pcp

# IO monitoring: prefer iotop-c if available (some releases)
if have_pkg iotop-c; then
  apt_install_if_available iotop-c
else
  apt_install_if_available iotop
fi

echo "[4/5] Modern CLI niceties"
apt_install_if_available bat
apt_install_if_available eza


echo "[5/5] Command shims"
install -d /usr/local/bin

echo "Done: main tools installed."

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

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1"; exit 1; }; }

need_cmd curl
need_cmd gpg
need_cmd install
need_cmd apt

echo "[0/8] Base deps"
apt update -y
apt install -y --no-install-recommends \
  ca-certificates curl gpg apt-transport-https software-properties-common \
  wget

# ------------------------------------------------------------
echo "[1/8] Brave Browser (official apt repo)"
# Brave official instructions use keyring + .sources file
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources \
  https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
apt update -y
apt install -y brave-browser

# ------------------------------------------------------------
echo "[2/8] Zen Browser (Flatpak / Flathub)"
apt install -y --no-install-recommends flatpak
# Add Flathub if missing
sudo -u "$USER_NAME" flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# Install Zen
sudo -u "$USER_NAME" flatpak install -y flathub app.zen_browser.zen

# ------------------------------------------------------------
echo "[3/8] Visual Studio Code (Microsoft apt repo)"
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
  | gpg --dearmor -o /etc/apt/keyrings/packages.microsoft.gpg
chmod 0644 /etc/apt/keyrings/packages.microsoft.gpg

cat > /etc/apt/sources.list.d/vscode.list <<'EOF'
deb [arch=amd64,arm64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main
EOF

apt update -y
apt install -y code

# ------------------------------------------------------------
echo "[4/8] VLC"
apt install -y vlc

# ------------------------------------------------------------
echo "[5/8] JabRef (Snap, upstream-recommended on Ubuntu)"
apt install -y snapd
snap install jabref

# ------------------------------------------------------------
echo "[6/8] Proton VPN (official repo package -> apt)"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

# Proton VPN provides a repo config .deb; install it, then apt install the app
wget -qO "${TMPDIR}/protonvpn-stable-release.deb" \
  https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb
dpkg -i "${TMPDIR}/protonvpn-stable-release.deb" || apt -f install -y
apt update -y
apt install -y proton-vpn-gnome-desktop

# ------------------------------------------------------------
echo "[7/8] Proton Pass / Proton Mail / Proton Authenticator (official .deb direct)"
# These URLs are the official “latest” DEB endpoints referenced by Proton’s own install docs.
# We download to /tmp, then install via apt so dependencies are handled.

wget -qO "${TMPDIR}/ProtonPass.deb" \
  https://proton.me/download/PassDesktop/linux/x64/ProtonPass.deb
apt install -y "${TMPDIR}/ProtonPass.deb"

wget -qO "${TMPDIR}/ProtonMail-desktop-beta.deb" \
  https://proton.me/download/mail/linux/ProtonMail-desktop-beta.deb
apt install -y "${TMPDIR}/ProtonMail-desktop-beta.deb"

wget -qO "${TMPDIR}/ProtonAuthenticator.deb" \
  https://proton.me/download/authenticator/linux/ProtonAuthenticator.deb
apt install -y "${TMPDIR}/ProtonAuthenticator.deb"

# ------------------------------------------------------------
echo "[8/8] Cleanup"
apt autoremove -y
apt autoclean -y

echo
echo "Done. Installed:"
echo "  brave-browser, Zen (flatpak), code, vlc, jabref (snap), proton-vpn-gnome-desktop,"
echo "  Proton Pass, Proton Mail (beta), Proton Authenticator"
echo
echo "Notes:"
echo "  - Zen is a Flatpak: update with 'flatpak update'"
echo "  - JabRef is a Snap: update via snap auto-updates (or 'snap refresh')"

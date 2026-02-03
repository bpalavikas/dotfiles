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

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1"
    exit 1
  }
}

need_cmd curl
need_cmd tar
need_cmd uname

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) GOARCH="amd64" ;;
  aarch64|arm64) GOARCH="arm64" ;;
  *)
    echo "Unsupported architecture for Go: $ARCH"
    exit 1
    ;;
esac

OS="$(uname -s)"
if [[ "$OS" != "Linux" ]]; then
  echo "This script supports Linux only."
  exit 1
fi

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "[1/6] Determine latest Go version"
GO_VERSION="$(curl -fsSL https://go.dev/VERSION?m=text)"
if [[ -z "$GO_VERSION" ]]; then
  echo "Failed to determine Go version"
  exit 1
fi
echo "Latest Go version: $GO_VERSION"

GO_TARBALL="${GO_VERSION}.linux-${GOARCH}.tar.gz"
GO_URL="https://go.dev/dl/${GO_TARBALL}"

echo "[2/6] Download Go"
curl -fSL "$GO_URL" -o "${TMPDIR}/${GO_TARBALL}"

echo "[3/6] Remove any existing Go installation"
rm -rf /usr/local/go

echo "[4/6] Install Go to /usr/local/go"
tar -C /usr/local -xzf "${TMPDIR}/${GO_TARBALL}"

echo "[5/6] Configure PATH system-wide"
cat > /etc/profile.d/go.sh <<'EOF'
# Go toolchain
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
EOF
chmod 0644 /etc/profile.d/go.sh

echo "[6/6] Create Go workspace for user"
sudo -u "$USER_NAME" mkdir -p "${USER_HOME}/go"/{bin,src,pkg}

echo "Go installed successfully."
echo
echo "Verify after re-login:"
echo "  go version"
echo "  go env GOPATH"

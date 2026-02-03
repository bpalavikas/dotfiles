#!/usr/bin/env bash
set -euo pipefail


if [[ $EUID -eq 0 ]]; then
  echo "Do NOT run as root."
  exit 1
fi

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing command: $1"; exit 1; }
}

need_cmd curl
need_cmd uname
need_cmd bash

ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) MINICONDA_ARCH="x86_64" ;;
  aarch64|arm64) MINICONDA_ARCH="aarch64" ;;
  *)
    echo "Unsupported arch for this script: $ARCH"
    exit 1
    ;;
esac

OS="$(uname -s)"
if [[ "$OS" != "Linux" ]]; then
  echo "This script is for Linux only."
  exit 1
fi

MINICONDA_DIR="${HOME}/miniconda3"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "[1/6] Install Miniconda (if missing)"
if [[ -x "${MINICONDA_DIR}/bin/conda" ]]; then
  echo "Miniconda already present at ${MINICONDA_DIR}"
else
  # Use current installer naming (Miniconda3-latest-Linux-<arch>.sh)
  # This is the standard Miniconda installer path. (Anaconda/Miniconda docs)
  INSTALLER="Miniconda3-latest-Linux-${MINICONDA_ARCH}.sh"
  URL="https://repo.anaconda.com/miniconda/${INSTALLER}"
  echo "Downloading: ${URL}"
  curl -fSL "$URL" -o "${TMPDIR}/${INSTALLER}"
  bash "${TMPDIR}/${INSTALLER}" -b -p "${MINICONDA_DIR}"
fi

echo "[2/6] Configure conda: disable auto-activate"
# shellcheck disable=SC1091
source "${MINICONDA_DIR}/etc/profile.d/conda.sh"
conda config --set auto_activate_base false

echo "[3/6] Update conda base tooling (minimal)"
conda update -n base -y conda || true

echo "[4/6] Install uv (if missing)"
if command -v uv >/dev/null 2>&1; then
  echo "uv already installed: $(uv --version)"
else
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Make uv available in this script run (installer typically places it under ~/.cargo/bin)
export PATH="$HOME/.cargo/bin:$PATH"

echo "[5/6] Configure uv defaults"
mkdir -p ~/.config/uv
cat > ~/.config/uv/uv.toml <<'EOF'
[python]
prefer-system = true

[venv]
in-project = true
EOF

echo "[6/6] Print quick usage reminders"
cat <<'EOF'

Conda (coursework / ad-hoc):
  conda create -n hw python=3.11
  conda activate hw

uv (projects):
  mkdir myproj && cd myproj
  uv init
  uv venv
  uv add <pkgs>
  uv run python ...

Rule: do not mix conda + uv in the same project.
EOF

echo "Done: Miniconda + uv installed."

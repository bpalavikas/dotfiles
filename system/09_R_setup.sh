#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Run as root: sudo $0"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt update -y
apt install -y --no-install-recommends \
  ca-certificates \
  dirmngr \
  gnupg \
  software-properties-common

# Add CRAN apt repo (uses Ubuntu codename, e.g. noble)
CODENAME="$(lsb_release -cs)"

# Import CRAN signing key and add repo (per CRAN instructions)
# Exact steps are documented by CRAN for Ubuntu. :contentReference[oaicite:7]{index=7}
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | gpg --dearmor -o /etc/apt/keyrings/cran.gpg

echo "deb [signed-by=/etc/apt/keyrings/cran.gpg] https://cloud.r-project.org/bin/linux/ubuntu ${CODENAME}-cran40/" \
  > /etc/apt/sources.list.d/cran-r.list

apt update -y
apt install -y --no-install-recommends r-base r-base-dev

echo "Done: R installed from CRAN repo."

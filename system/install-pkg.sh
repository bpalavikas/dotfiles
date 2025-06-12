#!/bin/bash
# A script to install packages from a list

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
APT_LIST="$SCRIPT_DIR/packages.apt"
FLATPAK_LIST="$SCRIPT_DIR/packages.flatpak"

echo "Updating package sources..."
sudo apt-get update

echo "Installing APT packages..."
if [ -f "$APT_LIST" ]; then
    sudo xargs -a "$APT_LIST" apt-get install -y
else
    echo "APT package list not found."
fi

echo "Installing Flatpak packages..."
if [ -f "$FLATPAK_LIST" ]; then
    # Install from flathub repository, one by one
    xargs -n 1 flatpak install -y flathub < "$FLATPAK_LIST"
else
    echo "Flatpak package list not found."
fi

echo "Package installation complete."

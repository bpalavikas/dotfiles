#!/bin/bash
# A script to save installed packages to a list

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Saving APT packages..."
# Save a list of manually installed packages, excluding libraries
apt-mark showmanual > "$SCRIPT_DIR/packages.apt"

echo "Saving Flatpak packages..."
# Save a list of installed Flatpak application IDs
flatpak list --app --columns=application > "$SCRIPT_DIR/packages.flatpak"

echo "Package lists saved successfully."

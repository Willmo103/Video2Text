#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Define paths
TOOL_DIR="$HOME/Videos/vid2text"
SHELL_FILE="/usr/local/bin/vid2text"

# Deactivate the virtual environment
source "$TOOL_DIR/venv/bin/activate"
deactivate

# Remove the vid2text directory and all its contents
rm -rf "$TOOL_DIR"
echo "Removed directory: $TOOL_DIR"

# Remove the shell wrapper from /usr/local/bin
if [ -f "$SHELL_FILE" ]; then
    rm "$SHELL_FILE"
    echo "Removed command: vid2text"
fi

echo "Uninstallation complete."

#!/bin/bash

# Function to check if script is running as root
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or use sudo."
    exit 1
  fi
}

check_root

# Define the paths
TOOL_DIR="$HOME/Videos/vid2text"
VENV_DIR="$TOOL_DIR/venv"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Update Python packages
pip install --upgrade ffmpeg-python whisper pyyaml torch torchvision torchaudio

# Update the script file if a new version exists
cp "$SCRIPT_DIR/vid2text.py" "$TOOL_DIR/vid2text.py"

echo "Update complete. vid2text is now up-to-date."

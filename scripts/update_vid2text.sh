#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Define paths
TOOL_DIR="$HOME/Videos/vid2text"
VENV_DIR="$TOOL_DIR/venv"

# Activate the virtual environment
source "$VENV_DIR/bin/activate"

# Update Python packages
pip install --upgrade ffmpeg-python whisper pyyaml torch torchvision torchaudio

# Update the source code in the tool directory
cp -r vid2text "$TOOL_DIR/"

echo "Update complete. vid2text is now up-to-date."

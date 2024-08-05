#!/bin/bash

# Install dependencies
pip install ffmpeg-python whisper

# Create a directory for the tool
mkdir -p ~/vid2text
cd ~/vid2text

# Copy the script to the directory
cp /path/to/vid2text.py ~/vid2text/

# Create a symbolic link to the script in a directory that's in the PATH
ln -s ~/vid2text/vid2text.py /usr/local/bin/vid2text

# Make the script executable
chmod +x /usr/local/bin/vid2text

echo "Installation complete. You can now use 'vid2text' command."

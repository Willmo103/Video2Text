#!/bin/bash

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Define paths
TOOL_DIR="$HOME/Videos/vid2text"
VENV_DIR="$TOOL_DIR/venv"
CONFIG_FILE="$TOOL_DIR/config.yml"
SHELL_FILE="/usr/local/bin/vid2text"

# Create directories
mkdir -p "$TOOL_DIR"

# Create virtual environment
python3 -m venv "$VENV_DIR"

# Activate virtual environment and install dependencies
source "$VENV_DIR/bin/activate"
pip install ffmpeg-python whisper pyyaml torch torchvision torchaudio

# Copy the scripts to the tool directory
cp -r vid2text "$TOOL_DIR/"

# Create config.yml with default paths
echo "input_directory: \"$HOME/Videos/input_videos\"" > "$CONFIG_FILE"
echo "output_directory: \"$TOOL_DIR/output\"" >> "$CONFIG_FILE"
echo "db_path: \"$TOOL_DIR/vid2text.db\"" >> "$CONFIG_FILE"

# Create a shell wrapper in /usr/local/bin
echo "#!/bin/bash" > "$SHELL_FILE"
echo "source \"$VENV_DIR/bin/activate\"" >> "$SHELL_FILE"
echo "python \"$TOOL_DIR/vid2text/cli.py\" \"\$@\"" >> "$SHELL_FILE"
chmod +x "$SHELL_FILE"

echo "Installation complete. You can now use 'vid2text' command from the command line."

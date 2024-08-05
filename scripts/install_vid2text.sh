#!/bin/bash

# Function to check if script is running as root
check_root() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or use sudo."
    exit 1
  fi
}

# Check if the script is run as root
check_root

# Define paths
TOOL_DIR="$HOME/Videos/vid2text"
VENV_DIR="$TOOL_DIR/venv"
CONFIG_FILE="$TOOL_DIR/config.yml"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SHELL_FILE="/usr/local/bin/vid2text"

# Create necessary directories
mkdir -p "$TOOL_DIR"

# Create a virtual environment
python3 -m venv "$VENV_DIR"

# Activate the virtual environment and install dependencies
source "$VENV_DIR/bin/activate"
pip install ffmpeg-python whisper pyyaml torch torchvision torchaudio

# Copy the script to the tool directory
cp "$SCRIPT_DIR/vid2text.py" "$TOOL_DIR/vid2text.py"

# Create config.yml with default paths
echo "input_directory: \"$HOME/Videos/input_videos\"" > "$CONFIG_FILE"
echo "output_directory: \"$TOOL_DIR/output\"" >> "$CONFIG_FILE"
echo "db_path: \"$TOOL_DIR/vid2text.db\"" >> "$CONFIG_FILE"

# Create a shell wrapper in /usr/local/bin
echo "#!/bin/bash" > "$SHELL_FILE"
echo "source \"$VENV_DIR/bin/activate\"" >> "$SHELL_FILE"
echo "python \"$TOOL_DIR/vid2text.py\" \"\$@\"" >> "$SHELL_FILE"
chmod +x "$SHELL_FILE"

echo "Installation complete. You can now use 'vid2text' command from the command line."

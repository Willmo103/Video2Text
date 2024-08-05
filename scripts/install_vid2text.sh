#!/bin/bash

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo."
  exit 1
fi

# Define paths
TOOL_DIR="$HOME/Videos/vid2text"
VENV_DIR="$TOOL_DIR/venv"
CONFIG_FILE="$TOOL_DIR/config.yml"
SHELL_FILE="/usr/local/bin/vid2text"

# Create necessary directories
mkdir -p "$TOOL_DIR"

# Create a virtual environment
python3 -m venv "$VENV_DIR"

# Activate the virtual environment and install dependencies
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install ffmpeg-python whisper pyyaml torch torchvision torchaudio

# Copy the source code to the tool directory
cp -r vid2text "$TOOL_DIR/"

# Create config.yml with default paths
cat <<EOL > "$CONFIG_FILE"
input_directory: "$HOME/Videos/input_videos"
output_directory: "$TOOL_DIR/output"
db_path: "$TOOL_DIR/vid2text.db"
EOL

# Create a shell wrapper in /usr/local/bin
cat <<EOL > "$SHELL_FILE"
#!/bin/bash
source "$VENV_DIR/bin/activate"
python "$TOOL_DIR/vid2text/cli.py" "\$@"
EOL
chmod +x "$SHELL_FILE"

echo "Installation complete. You can now use the 'vid2text' command."

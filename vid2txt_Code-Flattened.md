# .gitignore

```gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C extensions
*.so

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# PyInstaller
#  Usually these files are written by a python script from a template
#  before PyInstaller builds the exe, so as to inject date/other infos into it.
*.manifest
*.spec

# Installer logs
pip-log.txt
pip-delete-this-directory.txt

# Unit test / coverage reports
htmlcov/
.tox/
.nox/
.coverage
.coverage.*
.cache
nosetests.xml
coverage.xml
*.cover
*.py,cover
.hypothesis/
.pytest_cache/
cover/

# Translations
*.mo
*.pot

# Django stuff:
*.log
local_settings.py
db.sqlite3
db.sqlite3-journal

# Flask stuff:
instance/
.webassets-cache

# Scrapy stuff:
.scrapy

# Sphinx documentation
docs/_build/

# PyBuilder
.pybuilder/
target/

# Jupyter Notebook
.ipynb_checkpoints

# IPython
profile_default/
ipython_config.py

# pyenv
#   For a library or package, you might want to ignore these files since the code is
#   intended to run in multiple environments; otherwise, check them in:
# .python-version

# pipenv
#   According to pypa/pipenv#598, it is recommended to include Pipfile.lock in version control.
#   However, in case of collaboration, if having platform-specific dependencies or dependencies
#   having no cross-platform support, pipenv may install dependencies that don't work, or not
#   install all needed dependencies.
#Pipfile.lock

# poetry
#   Similar to Pipfile.lock, it is generally recommended to include poetry.lock in version control.
#   This is especially recommended for binary packages to ensure reproducibility, and is more
#   commonly ignored for libraries.
#   https://python-poetry.org/docs/basic-usage/#commit-your-poetrylock-file-to-version-control
#poetry.lock

# pdm
#   Similar to Pipfile.lock, it is generally recommended to include pdm.lock in version control.
#pdm.lock
#   pdm stores project-wide configurations in .pdm.toml, but it is recommended to not include it
#   in version control.
#   https://pdm.fming.dev/latest/usage/project/#working-with-version-control
.pdm.toml
.pdm-python
.pdm-build/

# PEP 582; used by e.g. github.com/David-OConnor/pyflow and github.com/pdm-project/pdm
__pypackages__/

# Celery stuff
celerybeat-schedule
celerybeat.pid

# SageMath parsed files
*.sage.py

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Spyder project settings
.spyderproject
.spyproject

# Rope project settings
.ropeproject

# mkdocs documentation
/site

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Pyre type checker
.pyre/

# pytype static type analyzer
.pytype/

# Cython debug symbols
cython_debug/

# PyCharm
#  JetBrains specific template is maintained in a separate JetBrains.gitignore that can
#  be found at https://github.com/github/gitignore/blob/main/Global/JetBrains.gitignore
#  and can be added to the global gitignore or merged into this file.  For a more nuclear
#  option (not recommended) you can uncomment the following to ignore the entire idea folder.
#.idea/

```

# README.md

```markdown
# CLI Tool: vid2text

## Features

**The CLI tool will have the following features:**

    - Extract Audio: Extract audio from the provided video file.
    - Transcribe Audio: Generate a transcript from the extracted audio.
    - Database Tracking: Store paths and metadata for each transcription process.
    - SQLite Database Schema

**The database will have a table transcriptions with the following fields:**

    - id: Unique identifier for each record.
    - video_path: Path to the input video file.
    - audio_path: Path to the extracted audio file.
    - transcript_path: Path to the generated transcript.
    - timestamp: Date and time when the transcription was created.

## CLI Argument Schema

    --video (-v): Path to the input video file.
    --output (-o): Directory where the audio and transcript will be saved.
    --db (-d): Path to the SQLite database file.

## Key Changes Version 0.0.3

**print_usage Function:**

This function provides a clear usage message with examples. It details the required `-v` or `--video` argument and the optional `-u` or `--update` argument.

**Argument Check:**

In the `main()` function, the script now checks if neither `args.video` nor `args.update` is provided. If neither argument is present, it prints the usage message and exits.

**Interactive Configuration Update:**

The `-u` or `--update` option is retained for updating the configuration interactively.

## Usage Instructions

To Transcribe a Video:

    ```cmd
    vid2text -v C:\path\to\video.mp4
    ```

To Update Configuration Settings:

    ```cmd
    vid2text -u
    ```

Without Arguments:

- If you run `vid2text` without any arguments, it will display the usage message and guide you on how to use the tool.

```

# requirements.txt

```plaintext
ffmpeg==1.4
six==1.16.0
whisper==1.1.10

```

# setup.py

```python
from setuptools import setup, find_packages

setup(
    name='vid2text',
    version='0.1.0',
    description='A tool for transcribing videos to text using Whisper',
    author='Will Morris',
    author_email='willmorris188.com',
    url='https://github.com/willmo103/vid2text',
    packages=find_packages(),
    install_requires=[
        'ffmpeg-python',
        'whisper',
        'pyyaml',
        'torch',
        'torchvision',
        'torchaudio'
    ],
    entry_points={
        'console_scripts': [
            'vid2text=vid2text.cli:main',
        ],
    },
)

```

# scripts/install_vid2text.sh

```bash
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

```

# scripts/install_zid2text.bat

```batch
@echo off
setlocal

REM Function to check if the script is running as administrator
:checkAdmin
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo This script requires administrative privileges.
    echo Please right-click the script and select 'Run as administrator'.
    pause
    exit /b
)

REM Check for Microsoft Visual C++ Redistributable installation
:checkVCRedist
set "VCRedist=vc_redist.x64.exe"
set "VCRedistURL=https://aka.ms/vs/17/release/vc_redist.x64.exe"

echo Checking for Microsoft Visual C++ Redistributable...
if exist "%SystemRoot%\System32\msvcp140.dll" (
    echo Visual C++ Redistributable is already installed.
) else (
    echo Visual C++ Redistributable not found. Downloading and installing...
    curl -o %VCRedist% %VCRedistURL%
    start /wait %VCRedist% /install /quiet /norestart
    del %VCRedist%
)

REM Define the paths
set SCRIPT_DIR=%~dp0
set USER_VIDEOS=%USERPROFILE%\Videos
set TOOL_DIR=%USER_VIDEOS%\vid2text
set VENV_DIR=%TOOL_DIR%\venv
set CONFIG_FILE=%TOOL_DIR%\config.yml
set BATCH_FILE=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\vid2text.bat

REM Create a directory for the tool
if not exist "%TOOL_DIR%" mkdir "%TOOL_DIR%"
cd /d "%TOOL_DIR%"

REM Create a virtual environment
python -m venv "%VENV_DIR%"

REM Activate the virtual environment and install dependencies
call "%VENV_DIR%\Scripts\activate"
pip install ffmpeg-python whisper pyyaml torch torchvision torchaudio

REM Copy the script to the directory
copy "%SCRIPT_DIR%\vid2text.py" "%TOOL_DIR%\vid2text.py"

REM Create config.yml with default paths
echo input_directory: "%USER_VIDEOS%\input_videos" > "%CONFIG_FILE%"
echo output_directory: "%USER_VIDEOS%\vid2text\output" >> "%CONFIG_FILE%"
echo db_path: "%USER_VIDEOS%\vid2text\vid2text.db" >> "%CONFIG_FILE%"

REM Create the batch file for running the script
echo @echo off > "%BATCH_FILE%"
echo call "%VENV_DIR%\Scripts\activate" >> "%BATCH_FILE%"
echo python "%TOOL_DIR%\vid2text.py" %%* >> "%BATCH_FILE%"

REM Make sure the script is executable
icacls "%TOOL_DIR%\vid2text.py" /grant Everyone:F

echo Installation complete. You can now use 'vid2text' command from the command line.

endlocal

```

# scripts/uninstall_vid2text.bat

```batch
REM Define the paths
set TOOL_DIR=%USERPROFILE%\Videos\vid2text
set BATCH_FILE=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\vid2text.bat

REM Deactivate the virtual environment
call "%TOOL_DIR%\venv\Scripts\deactivate"

REM Remove the vid2text directory and all its contents
if exist "%TOOL_DIR%" (
    rmdir /s /q "%TOOL_DIR%"
    echo Removed directory: %TOOL_DIR%
)

REM Remove the batch file from the PATH
if exist "%BATCH_FILE%" (
    del "%BATCH_FILE%"
    echo Removed command: vid2text
)

echo Uninstallation complete.

```

# scripts/uninstall_vid2text.sh

```bash
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

```

# scripts/update_vid2text.bat

```batch
@echo off
setlocal

REM Check if the script is running as administrator
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo This script requires administrative privileges.
    echo Please right-click the script and select 'Run as administrator'.
    pause
    exit /b
)

REM Define the paths
set TOOL_DIR=%USERPROFILE%\Videos\vid2text
set VENV_DIR=%TOOL_DIR%\venv
set SCRIPT_DIR=%~dp0

REM Activate the virtual environment
call "%VENV_DIR%\Scripts\activate"

REM Update Python packages
pip install --upgrade ffmpeg-python whisper pyyaml torch torchvision torchaudio

REM Update the script file if a new version exists
copy /Y "%SCRIPT_DIR%\vid2text.py" "%TOOL_DIR%\vid2text.py"

echo Update complete. vid2text is now up-to-date.

endlocal

```

# scripts/update_vid2text.sh

```bash
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

```

# vid2text/cli.py

```python
import argparse
from vid2text import core, utils
import os


def main():
    parser = argparse.ArgumentParser(
        description='Video to Text Transcription Tool')
    parser.add_argument(
        '-v', '--video', help='Path to the input video file', required=True)
    parser.add_argument('-u', '--update', action='store_true',
                        help='Update configuration settings')

    args = parser.parse_args()

    if args.update:
        utils.update_config()
        return

    video_path = args.video
    config = utils.load_config()
    output_dir = config['output_directory']
    db_path = config['db_path']

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    audio_path = os.path.join(output_dir, os.path.splitext(
        os.path.basename(video_path))[0] + '.wav')
    transcript_path = os.path.join(output_dir, os.path.splitext(
        os.path.basename(video_path))[0] + '.txt')

    core.extract_audio(video_path, audio_path)
    transcript = core.transcribe_audio(audio_path)

    with open(transcript_path, 'w') as f:
        f.write(transcript)

    core.store_transcription_info(
        db_path, video_path, audio_path, transcript_path)


if __name__ == '__main__':
    main()

```

# vid2text/core.py

```python
import ffmpeg
import whisper
import sqlite3
from datetime import datetime


def extract_audio(video_path, audio_output_path):
    ffmpeg.input(video_path).output(audio_output_path).run()


def transcribe_audio(audio_path, model=None):
    if model is None:
        # Load the model once and keep it in memory
        model = whisper.load_model("base")
    result = model.transcribe(audio_path)
    return result['text']


def store_transcription_info(db_path, video_path, audio_path, transcript_path):
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute("""
        CREATE TABLE IF NOT EXISTS transcriptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            video_path TEXT,
            audio_path TEXT,
            transcript_path TEXT,
            timestamp TEXT
        );
        """)
        conn.commit()
        cursor.execute("""
        INSERT INTO transcriptions (video_path, audio_path, transcript_path, timestamp)
        VALUES (?, ?, ?, ?)
        """, (video_path, audio_path, transcript_path, datetime.now().isoformat()))
        conn.commit()

```

# vid2text/utils.py

```python
import yaml
import os

CONFIG_PATH = os.path.join(os.path.expanduser(
    "~"), "Videos", "vid2text", "config.yml")


def load_config():
    with open(CONFIG_PATH, 'r') as f:
        return yaml.safe_load(f)


def save_config(config):
    with open(CONFIG_PATH, 'w') as f:
        yaml.safe_dump(config, f)


def update_config():
    config = load_config()
    print("Current Configuration:")
    for key, value in config.items():
        print(f"{key}: {value}")
    key = input(
        "Enter the key you want to update (or 'exit' to finish): ").strip()
    if key in config:
        new_value = input(f"Enter the new value for {key}: ").strip()
        config[key] = new_value
        save_config(config)
        print(f"Updated {key} to {new_value}")
    elif key.lower() == 'exit':
        return
    else:
        print("Invalid key.")
    update_config()

```

# vid2text/__init__.py

```python
# vid2text/__init__.py
from .core import extract_audio, transcribe_audio, store_transcription_info
from .utils import load_config, save_config, update_config

```

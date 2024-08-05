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
pip install ffmpeg-python whisper pyyaml torch

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

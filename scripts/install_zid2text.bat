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

REM Define paths
set "TOOL_DIR=%USERPROFILE%\Videos\vid2text"
set "VENV_DIR=%TOOL_DIR%\venv"
set "CONFIG_FILE=%TOOL_DIR%\config.yml"
set "BATCH_FILE=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\vid2text.bat"

REM Create necessary directories
mkdir "%TOOL_DIR%"

REM Create a virtual environment
python -m venv "%VENV_DIR%"

REM Activate the virtual environment and install dependencies
call "%VENV_DIR%\Scripts\activate"
pip install --upgrade pip
pip install ffmpeg-python whisper pyyaml torch torchvision torchaudio

REM Copy the source code to the tool directory
xcopy /s /e vid2text "%TOOL_DIR%\vid2text\"

REM Create config.yml with default paths
echo input_directory: "%USERPROFILE%\Videos\input_videos" > "%CONFIG_FILE%"
echo output_directory: "%TOOL_DIR%\output" >> "%CONFIG_FILE%"
echo db_path: "%TOOL_DIR%\vid2text.db" >> "%CONFIG_FILE%"

REM Create a batch wrapper in user's PATH
echo @echo off > "%BATCH_FILE%"
echo call "%VENV_DIR%\Scripts\activate" >> "%BATCH_FILE%"
echo python "%TOOL_DIR%\vid2text\cli.py" %%* >> "%BATCH_FILE%"

REM Make sure the script is executable
icacls "%BATCH_FILE%" /grant Everyone:F

echo Installation complete. You can now use the 'vid2text' command.
endlocal

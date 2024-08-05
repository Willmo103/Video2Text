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

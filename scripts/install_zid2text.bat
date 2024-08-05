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

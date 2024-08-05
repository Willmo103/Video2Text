@echo off
REM Install Python dependencies
pip install ffmpeg-python whisper

REM Create a directory for the tool
set TOOL_DIR=%USERPROFILE%\vid2text
if not exist "%TOOL_DIR%" mkdir "%TOOL_DIR%"
cd /d "%TOOL_DIR%"

REM Copy the script to the directory
REM Replace "path\to\vid2text.py" with the actual path where the Python script is located
copy "vid2text.py" "%TOOL_DIR%\vid2text.py"

REM Add the script to the PATH by creating a wrapper batch file in the user's PATH
set BATCH_FILE=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\vid2text.bat
echo @echo off > "%BATCH_FILE%"
echo python "%TOOL_DIR%\vid2text.py" %%* >> "%BATCH_FILE%"

REM Make sure the script is executable
icacls "%TOOL_DIR%\vid2text.py" /grant Everyone:F

echo Installation complete. You can now use 'vid2text' command from the command line.

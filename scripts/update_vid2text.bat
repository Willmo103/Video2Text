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
set "BATCH_FILE=%USERPROFILE%\AppData\Local\Microsoft\WindowsApps\vid2text.bat"

REM Deactivate the virtual environment
call "%TOOL_DIR%\venv\Scripts\deactivate"

REM Remove the vid2text directory and all its contents
rmdir /s /q "%TOOL_DIR%"
echo "Removed directory: %TOOL_DIR%"

REM Remove the batch file from user's PATH
if exist "%BATCH_FILE%" (
    del "%BATCH_FILE%"
    echo "Removed command: vid2text"
)

echo "Uninstallation complete."
endlocal

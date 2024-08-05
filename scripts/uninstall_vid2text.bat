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

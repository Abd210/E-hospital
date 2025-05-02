@echo off
REM This script helps run E-Hospital from the correct directory

echo E-Hospital Launcher
echo ------------------

echo Checking for Flutter...
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Flutter not found in PATH. Please make sure Flutter is installed and in your PATH.
    exit /b 1
)

echo Navigating to the correct directory...
cd e_hospital
if %ERRORLEVEL% NEQ 0 (
    echo Could not find e_hospital directory. Make sure you are running this script from the parent directory.
    echo Current directory: %CD%
    exit /b 1
)

echo Starting E-Hospital...
echo.
echo Choose platform:
echo 1. Chrome
echo 2. Android
echo 3. iOS
echo 4. Windows
echo.

set /p choice=Enter your choice (1-4): 

if "%choice%"=="1" (
    flutter run -d chrome
) else if "%choice%"=="2" (
    flutter run -d android
) else if "%choice%"=="3" (
    flutter run -d ios
) else if "%choice%"=="4" (
    flutter run -d windows
) else (
    echo Invalid choice. Running on Chrome by default...
    flutter run -d chrome
)

pause 
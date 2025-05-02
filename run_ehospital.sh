#!/bin/bash
# This script helps run E-Hospital from the correct directory

echo "E-Hospital Launcher"
echo "------------------"

echo "Checking for Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found in PATH. Please make sure Flutter is installed and in your PATH."
    exit 1
fi

echo "Navigating to the correct directory..."
cd e_hospital || {
    echo "Could not find e_hospital directory. Make sure you are running this script from the parent directory."
    echo "Current directory: $(pwd)"
    exit 1
}

echo "Starting E-Hospital..."
echo ""
echo "Choose platform:"
echo "1. Chrome"
echo "2. Android"
echo "3. iOS"
echo ""

read -p "Enter your choice (1-3): " choice

case $choice in
    1)
        flutter run -d chrome
        ;;
    2)
        flutter run -d android
        ;;
    3)
        flutter run -d ios
        ;;
    *)
        echo "Invalid choice. Running on Chrome by default..."
        flutter run -d chrome
        ;;
esac 
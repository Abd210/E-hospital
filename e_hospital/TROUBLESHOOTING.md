# E-Hospital Troubleshooting Guide

## Common Issues and Solutions

### "No pubspec.yaml file found" Error

This error occurs when you're running Flutter commands from the wrong directory.

**Solution:**
```bash
# Incorrect - this is the parent folder
cd E-hospital
flutter run  # ERROR: No pubspec.yaml file found

# Correct - navigate to the actual project folder
cd e_hospital
flutter run  # This will work correctly
```

When troubleshooting, remember that the actual Flutter project is in the `e_hospital` directory (with lowercase 'e'), not the parent `E-hospital` directory.

### Dependency Issues

If you're having issues with dependencies:

```bash
# Make sure you're in the right directory first
cd e_hospital

# Clean the project
flutter clean

# Get dependencies again
flutter pub get

# Try running the app
flutter run -d chrome
```

### Firebase Configuration Issues

Make sure your Firebase configuration files are correctly placed:

- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`
- Web: Properly configured `web/index.html`

If you're setting up the project for the first time, you need to create a Firebase project and add these configuration files.

### UI Issues in Doctor Pages

If the doctor dashboard or profile pages aren't displaying correctly:

1. Make sure you're running the latest version of the codebase
2. Check that your Firestore database has proper doctor records with the correct structure
3. Ensure that doctors have the role 'medicalPersonnel' set in their user document

### Getting Started with a Clean Database

If you want to start with a fresh database for testing:

1. Go to your Firebase console
2. Create a new project
3. Set up Authentication, Firestore, and Storage
4. Update your configuration files 
5. Run the app and use the admin interface to create initial data

## Need More Help?

If you're still experiencing issues, please create an issue in the repository with:

1. A clear description of the problem
2. Steps to reproduce
3. Expected vs. actual behavior
4. Screenshots if applicable 
# E-Hospital

A comprehensive hospital management system built with Flutter and Firebase.

## Getting Started

This project is a Flutter application that requires proper setup to run correctly.

### Prerequisites

- Flutter SDK (latest stable version recommended)
- Firebase project setup
- Git

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd e_hospital  # Important: make sure you are in the e_hospital directory, NOT E-hospital
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Make sure your Firebase configuration files are correctly set up
   - For Android: `android/app/google-services.json`
   - For iOS: `ios/Runner/GoogleService-Info.plist`
   - For Web: Configure the web/index.html file

### Running the application

Make sure you're in the correct directory (e_hospital) before running commands:

```bash
# To run on Chrome
flutter run -d chrome

# To run on Android
flutter run -d android

# To run on iOS
flutter run -d ios
```

## Common Issues

- **"No pubspec.yaml file found"**: This error occurs when running flutter commands from the wrong directory. Make sure you're in the `e_hospital` directory, not the parent `E-hospital` directory.
- **Doctor page issues**: If experiencing problems with the doctor page, make sure the Firestore database has the correct user roles and patient assignments.

## Features

- User authentication (Admin, Doctor, Patient)
- Patient management
- Doctor management
- Appointment scheduling
- Medical records management
- Dashboard analytics

## Project Structure

- `lib/models/` - Data models
- `lib/screens/` - UI screens for different user roles
- `lib/services/` - Service classes for backend operations
- `lib/core/` - Core UI components and utilities
- `lib/theme/` - App theme configuration

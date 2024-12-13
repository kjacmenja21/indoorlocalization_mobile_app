# Indoor Localization Mobile App

## Overview
The **Indoor Localization Mobile App** is a Flutter-based application designed to provide users with an intuitive interface for indoor navigation and asset management. It integrates seamlessly with the backend infrastructure to offer real-time data visualization, asset tracking, and navigation assistance.

## Features
- **Interactive Floor Maps**: Displays indoor floor maps with detailed overlays of assets.
- **Data Visualization**: Includes heatmaps and other visual tools for tracking asset usage and movement.
- **Reporting Tools**: Generate and view reports for individual or grouped assets.

## Technology Stack
- **Framework**: Flutter (Dart)
- **Platform**: Supports Android
- **Backend Integration**: API communication with the Indoor Localization Backend

## Getting Started

### Prerequisites
- Flutter SDK installed ([Get Started with Flutter](https://flutter.dev/docs/get-started/install))
- Android Studio for emulator setup
- Access to the Indoor Localization Backend API

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/kjacmenja21/indoorlocalization_mobile_app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd indoorlocalization_mobile_app
   ```
3. Fetch the required dependencies:
   ```bash
   flutter pub get
   ```

### Configuration
Update the configuration file (`lib/config.dart`) with the API base URL and other environment settings:
```dart
const String apiBaseUrl = "https://your-backend-url.com/api";
```

### Running the App
To run the app on an emulator or connected device:
1. Start the Flutter development server:
   ```bash
   flutter run
   ```
2. Select the target device from the available options.

### Building the App
To build APK or IPA files:
- **Android**: 
   ```bash
   flutter build apk
   ```

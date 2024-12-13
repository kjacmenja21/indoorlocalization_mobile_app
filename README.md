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

1. Install Android Studio

To build an Android application, Flutter requires Android Studio to be installed. To install Android Studio, please follow the official instructions available at https://developer.android.com/studio/install .

2. Install Android SDK Command-line Tools

In Android Studio, open Settings. Then navigate to Languages & Frameworks > Android SDK. Then select SDK Tools tab and check Android SDK Command-line Tools item and click Apply.
![SDK_commandline_tools](https://github.com/user-attachments/assets/de2c9b75-d168-43b9-adcc-0fdbacaaea56)

3. Install Flutter framework

To install and configure Flutter, please follow the official instructions available at https://docs.flutter.dev/get-started/install. If you did everything correctly, after running the shell command flutter doctor from any working directory, you should see an output similar to below.
![Install_flutter_framework](https://github.com/user-attachments/assets/6e173534-527e-4037-a1e7-dc3d3dffcf10)

4. Prepare IDE

Next, make sure to prepare your code editor. You can use the following editors:

Visual Studio Code (recommended),

Android Studio,

IntelliJ IDEA.

To set up your code editor, please follow the official instructions available at https://docs.flutter.dev/get-started/editor. 

5. Clone repository

To run the project, clone this repository https://github.com/kjacmenja21/indoorlocalization_mobile_app to your computer.

6. Run project (Visual Studio Code)

In the root directory of the repository, you will see a file il_app_project.code-workspace. This is a Visual Studio Code Workspace file (see https://code.visualstudio.com/docs/editor/workspaces) and you can open the project with this file.

Next, in the il_app project, find and open the file main.dart. This file is an entry point to the Flutter application. Once this file is open, you will be able to easily run the project. Also, don’t forget to prepare your physical or virtual Android device.

If needed, run the command flutter pub get in il_app to fetch all dependent packages.
![Run_project](https://github.com/user-attachments/assets/97241bac-6ea4-4a8d-b4e5-5d7c7b4fa852)

7. Run project (Android Studio)

In Android Studio, open the il_app project.
![Run_project_AS](https://github.com/user-attachments/assets/3411950f-ec83-4ece-aff2-953662ad4b5d)

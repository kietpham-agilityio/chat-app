# chat_app

This project was created for the purpose of training on notifications.

- [chat\_app](#chat_app)
  - [Flutter Version Management (Using Puro)](#flutter-version-management-using-puro)
    - [Flutter and Dart versions of the project](#flutter-and-dart-versions-of-the-project)
    - [Puro](#puro)
  - [Getting Started](#getting-started)

## Flutter Version Management (Using Puro)

### Flutter and Dart versions of the project

Flutter: **_3.29.2_** / Dart SDK: **_3.7.2_**

### Puro

[Puro](https://puro.dev/) is a powerful tool for installing and upgrading Flutter versions

1. The command line corresponding to the operating system.

   - Mac:
     ```
     curl -o- https://puro.dev/install.sh | PURO_VERSION="1.4.6" bash
     ```
   - Linux:
     ```
     curl -o- https://puro.dev/install.sh | PURO_VERSION="1.4.6" bash
     ```
   - Windows:
     ```
     Invoke-WebRequest -Uri "https://puro.dev/builds/1.4.6/windows-x64/puro.exe" -OutFile "$env:temp\puro.exe"; &"$env:temp\puro.exe" install-puro --promote
     ```

2. Install the package Puro
   ```
   dart pub global activate puro 1.4.6
   puro create chat_app 3.29.2
   puro use chat_app
   ```

You need to use `puro flutter ...` everywhere instead of just `flutter ...` when working with the project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

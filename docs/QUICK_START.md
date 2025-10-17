# 🚀 Quick Start Guide

Get up and running with Eratani in 5 minutes!

## ⚡ TL;DR (Too Long; Didn't Read)

```bash
# Clone
git clone https://github.com/igobhaktiar/user_management_app.git
cd eratani

# Install
flutter pub get

# Run
flutter run
```

## 📋 Prerequisites Checklist

Before you begin, make sure you have:

- [ ] Flutter SDK 3.35.4+ installed
- [ ] Dart 3.9.2+ installed
- [ ] Android Studio or VS Code
- [ ] Git installed
- [ ] A device/emulator ready

### Check Your Installation

```bash
# Check Flutter installation
flutter doctor

# Expected output:
# ✓ Flutter (Channel stable, 3.35.4)
# ✓ Android toolchain
# ✓ Chrome - develop for the web
# ✓ Android Studio
# ✓ VS Code
# ✓ Connected device
```

If you see any ❌, follow the instructions to fix them.

## 🎯 Step-by-Step Setup

### Step 1: Clone the Repository

```bash
# Using HTTPS
git clone https://github.com/igobhaktiar/user_management_app.git

# OR using SSH
git clone git@github.com:igobhaktiar/user_management_app.git

# Navigate to project
cd eratani
```

### Step 2: Install Dependencies

```bash
# Get all packages
flutter pub get

# You should see:
# Running "flutter pub get" in eratani...
# Got dependencies!
```

### Step 3: Run the App

#### Option A: Using Command Line

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# OR run on first available device
flutter run
```

#### Option B: Using VS Code

1. Open project in VS Code
2. Press `F5` or click "Run > Start Debugging"
3. Select device from bottom bar
4. Wait for app to build and launch

#### Option C: Using Android Studio

1. Open project in Android Studio
2. Select device from device dropdown
3. Click green play button ▶️
4. Wait for app to build and launch

## 📱 First Launch

When the app launches, you'll see:

### 1. User Management (Home Page)

- List of users from API
- Search bar at top
- Click ❤️ icon for Heart Beat Monitor
- Click 📦 icon for Stock Management
- Click ➕ button to add new user

### 2. Try the Features

**User Management:**

```
1. Try searching for a user
2. Click "Add User" button
3. Fill in the form
4. Click "Register User"
```

**Stock Management:**

```
1. Click 📦 icon in top right
2. See list of products
3. Click any product to add transaction
4. Click 📊 icon for monthly summary
```

**Heart Beat Monitor:**

```
1. Click ❤️ icon in top right
2. Adjust BPM slider
3. Click "Start" button
4. Watch the animation!
```

## 🔧 Troubleshooting

### Problem: Build fails

**Solution:**

```bash
# Clean build
flutter clean

# Get dependencies again
flutter pub get

# Run again
flutter run
```

### Problem: "Module not found" error

**Solution:**

```bash
# Make sure you're in the right directory
cd e:\FLUTTER\eratani

# Check pubspec.yaml exists
dir pubspec.yaml

# Get dependencies
flutter pub get
```

### Problem: Device not found

**Solution:**

```bash
# For Android Emulator
# Start emulator from Android Studio

# For Physical Device
# 1. Enable Developer Options
# 2. Enable USB Debugging
# 3. Connect via USB
# 4. Accept RSA key

# Check devices
flutter devices
```

### Problem: "Target file not found"

**Solution:**

```bash
# Make sure main.dart exists
dir lib\main.dart

# Run from project root
flutter run
```

## 🎓 Next Steps

Now that your app is running:

### Learn the Code

1. **Check the architecture**: `lib/features/`
2. **Read the documentation**: [docs/INDEX.md](INDEX.md)
3. **Explore the UI**: `lib/*/presentation/pages/`

### Customize the App

1. **Change colors**: Edit theme in `main.dart`
2. **Add features**: Follow Clean Architecture pattern
3. **Modify data**: Edit JSON files in `assets/data/`

### Development Workflow

```bash
# Hot reload (press 'r' in terminal)
# or save file in VS Code

# Hot restart (press 'R')
# Use when changing state structure

# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

## 🏗️ Building for Production

### Android APK

```bash
# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS (macOS only)

```bash
# Build for iOS
flutter build ios --release

# Follow code signing steps
```

### Web

```bash
# Build for web
flutter build web --release

# Output: build/web/
```

## 📚 Additional Resources

### Documentation

- [README.md](../README.md) - Full project documentation
- [CONTRIBUTING.md](../CONTRIBUTING.md) - How to contribute
- [API_DOCUMENTATION.md](../API_DOCUMENTATION.md) - API reference

### Learning Flutter

- [Flutter Official Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Cookbook](https://flutter.dev/docs/cookbook)

### Community

- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Community](https://flutter.dev/community)

## ⚙️ Configuration

### Changing App Name

**Android:** `android/app/src/main/AndroidManifest.xml`

```xml
<application
    android:label="Your App Name">
```

**iOS:** `ios/Runner/Info.plist`

```xml
<key>CFBundleName</key>
<string>Your App Name</string>
```

### Changing Package Name

Use the `change_app_package_name` package:

```bash
flutter pub global activate change_app_package_name
flutter pub global run change_app_package_name:main com.yourcompany.yourapp
```

### Changing App Icon

Use the `flutter_launcher_icons` package:

1. Add to `pubspec.yaml`
2. Place icon in `assets/icon/icon.png`
3. Run: `flutter pub run flutter_launcher_icons`

## 🐛 Common Issues

| Issue                  | Solution                                         |
| ---------------------- | ------------------------------------------------ |
| Gradle sync failed     | Check internet connection, update Android Studio |
| CocoaPods error        | Run `pod install` in `ios/` directory            |
| Asset not found        | Run `flutter clean` then `flutter pub get`       |
| Hot reload not working | Try hot restart (R) or full restart              |
| White screen on launch | Check for errors in console                      |

## 💡 Pro Tips

1. **Use hot reload** - Saves time during development
2. **Use DevTools** - `flutter pub global activate devtools`
3. **Use breakpoints** - Debug in VS Code or Android Studio
4. **Read error messages** - Flutter errors are usually helpful
5. **Use `const` constructors** - Better performance
6. **Format on save** - Enable in your editor settings

## 🎯 Development Commands Cheat Sheet

```bash
# Project commands
flutter create .            # Create new Flutter project
flutter pub get            # Install dependencies
flutter pub upgrade        # Update dependencies
flutter clean              # Clean build files

# Run commands
flutter run                # Run app
flutter run -d chrome      # Run on Chrome
flutter run --release      # Run in release mode

# Build commands
flutter build apk          # Build Android APK
flutter build appbundle    # Build Android App Bundle
flutter build ios          # Build iOS app
flutter build web          # Build web app

# Development commands
flutter analyze            # Analyze code
flutter test               # Run tests
flutter format .           # Format code
flutter doctor             # Check installation

# Device commands
flutter devices            # List devices
flutter emulators          # List emulators
flutter emulators --launch <id>  # Launch emulator
```

## 📞 Need Help?

- **Documentation issues**: [Open an issue](https://github.com/igobhaktiar/user_management_app/issues)
- **Code questions**: Check [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- **Feature requests**: [Create a discussion](https://github.com/igobhaktiar/user_management_app/discussions)

---

**You're all set!** 🎉 Start coding and have fun with Flutter!

For more details, see the [full documentation](../README.md).

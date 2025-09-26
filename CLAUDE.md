# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application for a self-ordering kiosk designed to be used at booths offering AI-based services (AI photobooth, AI consultation, AI health scan, etc.). The app is intended to run in kiosk mode on Android tablets.

## Development Commands

### Building and Running
- `flutter run` - Run the app in development mode
- `flutter build apk` - Build APK for Android
- `flutter build appbundle` - Build Android App Bundle for Play Store
- `flutter clean` - Clean build artifacts
- `flutter pub get` - Install dependencies

### Testing and Analysis
- `flutter test` - Run unit and widget tests
- `flutter analyze` - Run static analysis
- `flutter doctor` - Check Flutter installation and dependencies

### Android Development
- `./android/gradlew assembleDebug` - Build debug APK directly with Gradle
- `./android/gradlew assembleRelease` - Build release APK directly with Gradle

## Code Generation Commands

- `dart run build_runner build` - Generate JSON serialization code for models
- `dart run build_runner watch` - Watch for changes and regenerate JSON serialization code

## Architecture

This Flutter kiosk application follows a Provider-based state management pattern with clear separation of concerns:

### Core Features (Implemented)
1. **Service Selection Interface** - Touch-friendly UI for browsing AI services (attract mode, service catalog)
2. **Shopping Cart System** - Complete cart management with Provider state management
3. **QR Code Generation** - Order completion with QR codes containing order details and payment information
4. **Kiosk Mode** - Full Android tablet lockdown with system UI hiding and hardware button prevention

### Key Dependencies
- `qr_flutter: ^4.1.0` - QR code generation
- `provider: ^6.1.2` - State management
- `screen_protector: ^1.4.2` - Kiosk mode functionality and screenshot prevention
- `json_annotation: ^4.9.0` + `json_serializable: ^6.8.0` - Model serialization

### Project Structure
- `lib/main.dart` - Kiosk app entry point with full kiosk mode setup and custom Material 3 theming
- `lib/models/` - Data models with JSON serialization (`Service`, `Order`)
- `lib/providers/` - State management (`CartProvider` for shopping cart functionality)
- `lib/screens/` - UI screens (attract mode, cart, checkout)
- `lib/data/` - Static data definitions for available services
- `lib/widgets/` - Reusable UI components
- `lib/utils/` - Utility functions
- `android/` - Android-specific configuration and build files

### Architectural Patterns
- **State Management**: Provider pattern with `CartProvider` for cart operations
- **Navigation**: Material 3 navigation with custom theming optimized for kiosk use
- **Models**: JSON-serializable data classes with code generation
- **Kiosk Security**: Multi-layered approach including screen protection, system UI hiding, and hardware button override

## Development Notes

### Kiosk Mode Implementation
- Full system UI hiding with `SystemUiMode.immersiveSticky`
- Screenshot and screen recording prevention via `ScreenProtector`
- Hardware back button prevention with custom `PopScope` handling
- App lifecycle management to re-enable kiosk mode on resume
- Portrait orientation lock

### Model Code Generation
- Models use `json_annotation` and require `build_runner` for code generation
- Generated `.g.dart` files are committed to the repository
- Run `dart run build_runner build` after modifying model classes

### Theming
- Custom Material 3 theme with navy blue primary colors optimized for kiosk displays
- Touch-friendly button sizing and spacing
- Consistent typography scale for readability at distance
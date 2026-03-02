# VPN App - AI Agent Instructions

## Project Overview
Early-stage Flutter VPN application targeting iOS, Android, macOS, Linux, and Windows. **No external VPN packages are integrated yet** - Models and Widgets folders are empty, awaiting implementation. Theme foundation exists but feature architecture is minimal.

## Architecture Patterns

### Directory Structure & Responsibilities
- **`lib/main.dart`** - App entry point, instantiates MaterialApp with theme and IndexPage
- **`lib/Utils/Theme.dart`** - Global theme configuration with Poppins font family and PRIMARYCOLOR (orange: #F55804)
- **`lib/Utils/Global.dart`** - Currently empty; reserved for global constants and helper functions
- **`lib/Screen/Index.dart`** - Main stateful widget scaffold for UI screens
- **`lib/Models/`** - Empty; will contain data models (use nullable types for optional fields in Dart)
- **`lib/Widgets/`** - Empty; reserve for reusable Flutter widgets

### State Management & Material Design
- Uses **StatefulWidget** pattern with mutable State classes
- Applied theme uses `ThemeData` with bodyText1/bodyText2 overrides for Poppins font
- Material Design 3 conventions; always use `super.key` in widget constructors

## Dart/Flutter Coding Conventions

### Naming & Code Style
- **Classes**: PascalCase (`IndexPage`, `MyApp`)
- **Variables/Functions**: camelCase (`themeData`, `textTheme`)
- **Constants**: SCREAMING_SNAKE_CASE (`PRIMARYCOLOR`)
- Use `const` for widget constructors and compile-time constants
- Prefer `final` for instance variables; use `var` sparingly for type inference

### Common Patterns
1. **Widget constructors**: Always include `super.key` parameter
   ```dart
   class MyWidget extends StatefulWidget {
     const MyWidget({super.key});
   }
   ```

2. **Stateful widgets**: Implement `createState()` returning `State<MyWidget>`
3. **Build method signature**: `Widget build(BuildContext context)`
4. **Color definitions**: Use `Color.fromARGB(255, r, g, b)` format consistently

## Build & Deployment

### Flutter Commands (Cross-Platform)
```bash
flutter analyze          # Lint check (uses analysis_options.yaml)
flutter test             # Run widget tests (test/widget_test.dart)
flutter build apk        # Android APK build
flutter build ipa        # iOS IPA build
flutter pub get          # Dependency management
```

### Platform-Specific Setup
- **Android**: Uses Gradle with Flutter integration; requires `local.properties` with flutter.sdk path
- **iOS**: Deployment target managed via XCode; Info.plist defines CFBundleName: "vpn_app"
- **Windows/macOS/Linux**: Generated platform stubs included; build via platform-specific CMakeLists.txt

### Version Management
Version controlled in `pubspec.yaml` as `version: 1.0.0+1` (semver + build number)

## Dependencies & Analysis

### Current Minimal Stack
- **SDK Constraint**: Dart >=2.18.4 <3.0.0 (enable null safety features)
- **Core Dependencies**: flutter, cupertino_icons (iOS-style icons)
- **Dev Dependencies**: flutter_test, flutter_lints
- **Linting**: Enabled via `package:flutter_lints/flutter.yaml`; customizable in analysis_options.yaml

### Known Empty Pieces
- No state management framework (Provider, Riverpod, Bloc) yet
- No networking packages; VPN functionality not implemented
- No database/persistence layer

## Debugging & Hot Reload

- **Hot Reload**: Supported for UI iterations; State class changes may require hot restart
- **Run Debug**: `flutter run` (auto-selects attached device; use `-d <device-id>` to specify)
- **Logs**: View via `flutter logs` or platform-specific console (XCode, Android Studio)
- **Analysis**: Run `flutter analyze` before commits to catch lint violations

## Key Developer Workflows

1. **Adding a new screen**: Create class in `lib/Screen/` extending StatefulWidget with IndexPage pattern
2. **Adding UI components**: Define in `lib/Widgets/` and import via relative paths (e.g., `import 'package:vpn_app/Widgets/MyWidget.dart'`)
3. **Theming adjustments**: Modify `lib/Utils/Theme.dart`; use PRIMARYCOLOR constant for consistency
4. **Testing**: Add widget tests to `test/widget_test.dart`; tests run via `flutter test`

## Important Constraints

- **No external VPN libraries**: VPN functionality must be implemented from scratch or via platform channels
- **Multi-platform**: Changes must be tested across target platforms (iOS, Android minimally)
- **Null safety**: This project enforces Dart null safety; use `Type?` for nullable fields


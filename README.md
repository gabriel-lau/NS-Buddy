- [ ] Add data binding with ChangeNotifier and notifyListeners
- [ ] Proper theme colour options
- [ ] Clear logic for isNSF and dates
- [ ] Google Ads integration (AdMob)

# Flutter Application 1

A Flutter application with Material 3 design system integration and dynamic colors support.

## Features

- **Material 3 Design**: Modern Material Design 3 components and theming
- **Dynamic Colors**: Support for Android 12+ dynamic colors that adapt to the user's wallpaper
- **Dark/Light Theme**: Automatic theme switching with Material 3 color schemes
- **Interactive Demo**: Toggle between dynamic and static colors to see the difference
- **Color Scheme Preview**: Visual preview of the current color scheme

## Material 3 Integration

This app demonstrates the following Material 3 features:

### Dynamic Colors

- Uses `colorSchemeSeed` to enable dynamic colors on supported platforms
- Automatically adapts to the user's system accent colors (Android 12+)
- Fallback to static colors on unsupported platforms

### Material 3 Components

- **AppBar**: Modern surface-based design with proper elevation
- **FloatingActionButton**: Uses `primaryContainer` and `onPrimaryContainer` colors
- **Cards**: Material 3 card design with proper surface colors
- **Switches**: Material 3 switch components
- **Typography**: Material 3 text styles (`bodyLarge`, `displayMedium`, etc.)

### Color Scheme

The app uses Material 3 color tokens:

- `primary`: Main brand color
- `secondary`: Secondary brand color
- `tertiary`: Tertiary brand color
- `surface`: Background surfaces
- `surfaceVariant`: Variant background surfaces
- `primaryContainer`: Container for primary color
- `onPrimaryContainer`: Text/icons on primary containers

## Platform Support

### Android

- **Minimum SDK**: API 31 (Android 12) for dynamic colors support
- **Material 3 Theme**: Uses `Theme.Material3.Light.NoTitleBar` and `Theme.Material3.Dark.NoTitleBar`
- **Transparent System Bars**: Status bar and navigation bar are transparent for edge-to-edge design
- **Back Navigation**: Enabled `enableOnBackInvokedCallback` for Android 13+ predictive back gesture

### iOS

- Supports Material 3 design components
- Dynamic colors support (iOS 15+)

### Web/Desktop

- Material 3 design components
- Static color schemes (dynamic colors not supported)

## Getting Started

1. Ensure you have Flutter installed and set up
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

## Testing Dynamic Colors

### On Android 12+:

1. Change your wallpaper to see the app colors adapt
2. Use the "Dynamic Colors" toggle to switch between dynamic and static colors
3. Use the theme toggle in the app bar to switch between light and dark modes

### On Other Platforms:

- The app will use static colors but still showcase Material 3 design
- Theme switching still works for light/dark mode

## Key Files Modified

- `lib/main.dart`: Main app with Material 3 theming and dynamic colors
- `android/app/src/main/AndroidManifest.xml`: Added back navigation support
- `android/app/src/main/res/values/styles.xml`: Updated to Material 3 themes
- `android/app/src/main/res/values-night/styles.xml`: Updated to Material 3 dark themes
- `android/app/build.gradle.kts`: Set minimum SDK to API 31

## Dependencies

- Flutter SDK: ^3.8.1
- Material Design: Built into Flutter framework
- No additional dependencies required for Material 3 support

## Learn More

- [Material 3 Design](https://m3.material.io/)
- [Flutter Material 3](https://docs.flutter.dev/ui/design/material-3)
- [Dynamic Colors](https://m3.material.io/foundations/color/color-system/color-roles#dynamic-colors)

# Project Build Info

This document summarizes the toolchain and build settings used by this Flutter project.

## Versions Used In This Project

- Flutter: `3.35.5` on the stable channel
- Dart: `3.9.2`
- Gradle: `8.12`
- iOS deployment target: `15.0`

## Where These Values Come From

- Flutter version: the project tracks Flutter framework revision `ac4e799d237041cf905519190471f657b657155a` in [`.metadata`](./.metadata), which corresponds to Flutter `3.35.5` stable.
- Dart version: Flutter `3.35.5` ships with Dart `3.9.2`.
- Gradle version: pinned in [`android/gradle/wrapper/gradle-wrapper.properties`](./android/gradle/wrapper/gradle-wrapper.properties).
- iOS target: pinned in [`ios/Podfile`](./ios/Podfile).

## Successful APK Build Command

Run this from the project root:

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## Notes

- This project uses a release signing config in [`android/app/build.gradle`](./android/app/build.gradle).
- The release build expects [`android/key.properties`](./android/key.properties) to exist and point to the signing keystore.
- If you only want a debug APK for local testing, you can use:

```bash
flutter build apk --debug
```

## Helpful Files

- [`.metadata`](./.metadata)
- [`pubspec.yaml`](./pubspec.yaml)
- [`android/gradle/wrapper/gradle-wrapper.properties`](./android/gradle/wrapper/gradle-wrapper.properties)
- [`ios/Podfile`](./ios/Podfile)
- [`android/app/build.gradle`](./android/app/build.gradle)

// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC3lFwZ7FPrOZwPNsqCgP761MjeT4TyiKE',
    appId: '1:226645900971:web:96a1537087f918c43ac1ee',
    messagingSenderId: '226645900971',
    projectId: 'restart-378613',
    authDomain: 'restart-378613.firebaseapp.com',
    storageBucket: 'restart-378613.appspot.com',
    measurementId: 'G-V24SE3HRX4',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlVluF5OhKuUw8gol7GfKYGcL-Mb_nmE8',
    appId: '1:226645900971:android:6ebc4eedbe4743133ac1ee',
    messagingSenderId: '226645900971',
    projectId: 'restart-378613',
    storageBucket: 'restart-378613.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQ9Dl7Y-Km_JqV_YYix25sxhFUIeUWU3U',
    appId: '1:226645900971:ios:11233a213cab0cdb3ac1ee',
    messagingSenderId: '226645900971',
    projectId: 'restart-378613',
    storageBucket: 'restart-378613.appspot.com',
    iosClientId: '226645900971-uhl5vvcus4c9ek6tvgja7jt5t0j954hh.apps.googleusercontent.com',
    iosBundleId: 'com.example.restart',
  );
}
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
        return macos;
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
    apiKey: 'AIzaSyD8Ma35-l77VVNRZOujF2pLiH_hEbpDFKU',
    appId: '1:17676571719:web:38e05018a93010623ccd62',
    messagingSenderId: '17676571719',
    projectId: 'fir-class-579ae',
    authDomain: 'fir-class-579ae.firebaseapp.com',
    storageBucket: 'fir-class-579ae.appspot.com',
    measurementId: 'G-VQY6ZZHS73',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAGevGjD49EvxylxgAIOoA3qF38bCeF0cc',
    appId: '1:17676571719:android:dd53289bd70070ec3ccd62',
    messagingSenderId: '17676571719',
    projectId: 'fir-class-579ae',
    storageBucket: 'fir-class-579ae.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAU5e8R2x_soRN0ZbSH9ENB09OGWRvivg',
    appId: '1:17676571719:ios:1f7f84f228563a333ccd62',
    messagingSenderId: '17676571719',
    projectId: 'fir-class-579ae',
    storageBucket: 'fir-class-579ae.appspot.com',
    iosBundleId: 'com.example.flutterMwff',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAU5e8R2x_soRN0ZbSH9ENB09OGWRvivg',
    appId: '1:17676571719:ios:3da2d5c558d7e7873ccd62',
    messagingSenderId: '17676571719',
    projectId: 'fir-class-579ae',
    storageBucket: 'fir-class-579ae.appspot.com',
    iosBundleId: 'com.example.flutterMwff.RunnerTests',
  );
}

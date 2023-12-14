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
    apiKey: 'AIzaSyDUo73w244scxjtGVSZIOmEldWaku_qj58',
    appId: '1:626861009403:web:b8834a906af3394f53c35e',
    messagingSenderId: '626861009403',
    projectId: 'rent-car-42ec2',
    authDomain: 'rent-car-42ec2.firebaseapp.com',
    storageBucket: 'rent-car-42ec2.appspot.com',
    measurementId: 'G-CC1VQQ7PDX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD-zFkxrHww5O1JmCKFkvW25w5lS7QyIME',
    appId: '1:626861009403:android:786ef7161992a40453c35e',
    messagingSenderId: '626861009403',
    projectId: 'rent-car-42ec2',
    storageBucket: 'rent-car-42ec2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDkS0epBNqhJn_VCS8hoLJTPjPpDo5LPxg',
    appId: '1:626861009403:ios:e9e37bb566aca68f53c35e',
    messagingSenderId: '626861009403',
    projectId: 'rent-car-42ec2',
    storageBucket: 'rent-car-42ec2.appspot.com',
    iosBundleId: 'com.example.rentCar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDkS0epBNqhJn_VCS8hoLJTPjPpDo5LPxg',
    appId: '1:626861009403:ios:dcacfbd52ec7533e53c35e',
    messagingSenderId: '626861009403',
    projectId: 'rent-car-42ec2',
    storageBucket: 'rent-car-42ec2.appspot.com',
    iosBundleId: 'com.example.rentCar.RunnerTests',
  );
}

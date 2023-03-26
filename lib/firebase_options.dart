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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6Lm2SRoAJf3m_6w9Q9cyZAwRfUtJq-tQ',
    appId: '1:73712879979:android:9f85025626aedefe7ee42e',
    messagingSenderId: '73712879979',
    projectId: 'unisphere-58b8b',
    storageBucket: 'unisphere-58b8b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOuPQqsRsof_jWb480n2VxX2pKXFJbIAw',
    appId: '1:73712879979:ios:7cee6072ed08c1837ee42e',
    messagingSenderId: '73712879979',
    projectId: 'unisphere-58b8b',
    storageBucket: 'unisphere-58b8b.appspot.com',
    androidClientId: '73712879979-1dk5ab8i121ces07ksfvp5no5l04dhud.apps.googleusercontent.com',
    iosClientId: '73712879979-h8vuvmucbfbccfvj94trrcq5o4fc7q6s.apps.googleusercontent.com',
    iosBundleId: 'com.example.unione',
  );
}

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyBCeSQtUZnqG6qbAGkpRYcUUXqS3x0pygY',
    appId: '1:124630563209:web:6de6fe6b44ec4874c98958',
    messagingSenderId: '124630563209',
    projectId: 'messageapp-c844e',
    authDomain: 'messageapp-c844e.firebaseapp.com',
    storageBucket: 'messageapp-c844e.firebasestorage.app',
    measurementId: 'G-209FX03K5R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAtC1T6XwiBqInckexXp9rRhzmXBITSGVs',
    appId: '1:124630563209:android:4442276e2f0b84c1c98958',
    messagingSenderId: '124630563209',
    projectId: 'messageapp-c844e',
    storageBucket: 'messageapp-c844e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZUNTVpQ5ynIAFPdguIdYwe8WhUdeBHkw',
    appId: '1:124630563209:ios:c771523c4621a48ec98958',
    messagingSenderId: '124630563209',
    projectId: 'messageapp-c844e',
    storageBucket: 'messageapp-c844e.firebasestorage.app',
    androidClientId:
        '124630563209-p6128oug1b5qlgfl5okhadu02ncch57k.apps.googleusercontent.com',
    iosClientId:
        '124630563209-uos2an7r2ljsmmiusf2jpnu5vf2n5bm6.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterAndroidApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZUNTVpQ5ynIAFPdguIdYwe8WhUdeBHkw',
    appId: '1:124630563209:ios:c771523c4621a48ec98958',
    messagingSenderId: '124630563209',
    projectId: 'messageapp-c844e',
    storageBucket: 'messageapp-c844e.firebasestorage.app',
    androidClientId:
        '124630563209-p6128oug1b5qlgfl5okhadu02ncch57k.apps.googleusercontent.com',
    iosClientId:
        '124630563209-uos2an7r2ljsmmiusf2jpnu5vf2n5bm6.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterAndroidApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBCeSQtUZnqG6qbAGkpRYcUUXqS3x0pygY',
    appId: '1:124630563209:web:749636c92771b03fc98958',
    messagingSenderId: '124630563209',
    projectId: 'messageapp-c844e',
    authDomain: 'messageapp-c844e.firebaseapp.com',
    storageBucket: 'messageapp-c844e.firebasestorage.app',
    measurementId: 'G-9PM61TM5NS',
  );
}

// Configuración del proyecto de Firebase "repositorio-uca".
// Estos datos son públicos por diseño: la seguridad la dan las reglas de Firestore.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    if (defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError(
      'Para iOS corré `flutterfire configure` (agrega GoogleService-Info.plist).',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAS_4RzUgk3KWz5BOnfly-0Nw3vRY-yvRQ',
    appId: '1:1021521393827:android:fbfa526a050f600e3f6716',
    messagingSenderId: '1021521393827',
    projectId: 'repositorio-uca',
    storageBucket: 'repositorio-uca.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB173Rap_IKpky9gfgeO70fCnelrIDOULQ',
    authDomain: 'repositorio-uca.firebaseapp.com',
    projectId: 'repositorio-uca',
    storageBucket: 'repositorio-uca.firebasestorage.app',
    messagingSenderId: '1021521393827',
    appId: '1:1021521393827:web:a56c6973f4e8e0703f6716',
    measurementId: 'G-5LCP9DJDBK',
  );
}

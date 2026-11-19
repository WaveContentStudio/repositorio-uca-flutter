// Configuración del proyecto de Firebase "repositorio-uca".
// Estos datos son públicos por diseño: la seguridad la dan las reglas de Firestore.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    throw UnsupportedError(
      'Para Android/iOS corré `flutterfire configure` (agrega google-services.json y GoogleService-Info.plist).',
    );
  }

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

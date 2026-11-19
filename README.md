# Repositorio UCA — versión Flutter + Firebase

App para compartir apuntes entre estudiantes de la UCA, hecha en **Dart/Flutter**
con **Firebase** como base de datos y armada también en **FlutterFlow**.
Reemplaza a la versión HTML + Supabase.

Trabajo final de Práctica Profesional Interna 2026 — Lic. en Comunicación Digital e Interactiva (UCA).
Equipo: Nogara, Jerovsek y Yasiulewicz.

## Probala

- **Web:** https://wavecontentstudio.github.io/repositorio-uca-flutter/
- **Android:** descargá `RepositorioUCA.apk` de la [última versión](https://github.com/WaveContentStudio/repositorio-uca-flutter/releases/latest).

Las dos se arman solas con GitHub Actions cada vez que se sube un cambio a `main`
(`.github/workflows/apk.yml` y `.github/workflows/pages.yml`).

## Qué hay en este repositorio

| Archivo | Para qué sirve |
|---|---|
| `lib/repositorio_uca_app.dart` | Toda la app (pantallas, lógica y conexión con Firebase) en un solo widget: `RepositorioUcaApp`. |
| `lib/main.dart` | Arranque del proyecto Flutter normal (fuera de FlutterFlow). |
| `lib/firebase_options.dart` | Datos del proyecto de Firebase para web y Android. Son públicos por diseño: la seguridad la dan las reglas. |
| `flutterflow/RepositorioUcaApp.dart` | El mismo código, con el encabezado que pide FlutterFlow para un Custom Widget. |
| `firebase/firestore.rules` | Reglas de seguridad de la base de datos (se publican desde la consola de Firebase). |

## Cómo correrla

```bash
flutter pub get
flutter run -d chrome
```

Web y Android ya están configurados. Para iOS hay que correr `flutterfire configure`.

## Cómo se guardan los datos en Firebase (plan gratis)

- **Authentication**: correo y contraseña (también "Olvidé mi contraseña" por mail).
- **Firestore**
  - `users/{uid}`: nombre, correo, sede, carrera, año, votos, guardados, colecciones, recientes y descargas.
  - `users/{uid}/notifs/{id}`: avisos (votos, comentarios, descargas).
  - `materials/{id}`: datos del apunte y contadores (`up`, `down`, `dl`, `nc`).
  - `materials/{id}/chunks/{000..}`: el archivo partido en pedazos de hasta 900 KB.
    El plan gratis de Firebase no incluye Storage, así que los archivos van dentro de Firestore.
  - `materials/{id}/comments/{id}`: comentarios.
  - `reports/{id}`: reportes de material.

## FlutterFlow

- El widget `RepositorioUcaApp` se carga como Custom Widget y ocupa toda la página de inicio.
- **No desplegar las reglas de Firestore desde FlutterFlow**: pisarían las de `firebase/firestore.rules`.

## Versiones

Las versiones de los paquetes están fijadas a las mismas que usa FlutterFlow,
para que el código funcione igual en los dos lados.

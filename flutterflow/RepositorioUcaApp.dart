// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Repositorio UCA — app completa en un solo widget de Flutter.
// Base de datos: Firebase (Auth + Cloud Firestore; los archivos también van en Firestore).
//
// Este archivo es autocontenido a propósito: se pega tal cual en FlutterFlow
// como Custom Widget (RepositorioUcaApp) y también se usa en el proyecto
// Flutter normal desde lib/main.dart.

import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/* ============================== datos ============================== */

const Map<String, List<String>> kAcad = {
  'Sede Mendoza': [
    'Diseño Interactivo',
    'Licenciatura en Comunicación Digital e Interactiva',
    'Licenciatura en Administración de Empresas',
    'Contador Público',
    'Licenciatura en Marketing',
    'Licenciatura en Relaciones Internacionales',
  ],
  'Sede Buenos Aires': [
    'Ingeniería en Informática',
    'Ingeniería Industrial',
    'Licenciatura en Administración de Empresas',
    'Contador Público',
    'Abogacía',
    'Medicina',
  ],
  'Sede Rosario': [
    'Abogacía',
    'Contador Público',
    'Ingeniería Industrial',
    'Licenciatura en Comunicación Digital e Interactiva',
  ],
  'Sede Paraná': [
    'Abogacía',
    'Contador Público',
    'Licenciatura en Administración de Empresas',
  ],
};
final List<String> kSedes = kAcad.keys.toList();
final List<String> kAllCareers = (kAcad.values.expand((e) => e).toSet().toList()..sort());

const List<String> kTypes = ['Resumen', 'Examen', 'Guía', 'Apunte'];
const Map<String, String> kTypePlural = {
  'Resumen': 'Resúmenes',
  'Examen': 'Exámenes',
  'Guía': 'Guías',
  'Apunte': 'Apuntes',
};
const Map<String, IconData> kTypeIcon = {
  'Resumen': Icons.description_outlined,
  'Examen': Icons.star_outline_rounded,
  'Guía': Icons.folder_outlined,
  'Apunte': Icons.edit_outlined,
};
const Map<String, Color> kTypeColor = {
  'Resumen': Color(0xFF1D4ED8),
  'Examen': Color(0xFFD97706),
  'Guía': Color(0xFF059669),
  'Apunte': Color(0xFF7C3AED),
};
const List<String> kFormats = ['PDF', 'DOCX', 'PPTX', 'IMG'];
const Map<String, String> kExtFormat = {
  'pdf': 'PDF',
  'doc': 'DOCX',
  'docx': 'DOCX',
  'ppt': 'PPTX',
  'pptx': 'PPTX',
  'jpg': 'IMG',
  'jpeg': 'IMG',
  'png': 'IMG',
};
const Map<String, String> kExtMime = {
  'pdf': 'application/pdf',
  'doc': 'application/msword',
  'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'ppt': 'application/vnd.ms-powerpoint',
  'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
};
const int kMaxBytes = 20 * 1024 * 1024;

class Level {
  const Level(this.name, this.min);
  final String name;
  final int min;
}

const List<Level> kLevels = [
  Level('Novato', 0),
  Level('Colaborador', 30),
  Level('Referente', 80),
  Level('Leyenda', 150),
];
Level levelOf(int pts) => kLevels.lastWhere((l) => pts >= l.min);

/* ============================== colores ============================== */

class RC {
  static const brand = Color(0xFF1E2955);
  static const brand2 = Color(0xFF172147);
  static const action = Color(0xFF1D4ED8);
  static const amber = Color(0xFFF59E0B);
  static const bg = Color(0xFFF1F5F9);
  static const line = Color(0xFFE2E8F0);
  static const text = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const ok = Color(0xFF047857);
  static const bad = Color(0xFFBE123C);
  static const darkBg = Color(0xFF0F1530);
  static const darkSurface = Color(0xFF18214A);
  static const darkLine = Color(0xFF2A3566);
}

ThemeData _theme(Brightness b) {
  final dark = b == Brightness.dark;
  final base = ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: ColorScheme.fromSeed(
      seedColor: RC.action,
      brightness: b,
      primary: dark ? const Color(0xFF6E95F7) : RC.action,
      secondary: RC.amber,
      surface: dark ? RC.darkSurface : Colors.white,
      error: RC.bad,
    ),
    scaffoldBackgroundColor: dark ? RC.darkBg : RC.bg,
    dividerColor: dark ? RC.darkLine : RC.line,
  );
  final txt = GoogleFonts.interTextTheme(base.textTheme).apply(
    bodyColor: dark ? Colors.white : RC.text,
    displayColor: dark ? Colors.white : RC.text,
  );
  return base.copyWith(
    textTheme: txt,
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? RC.darkBg : RC.bg,
      foregroundColor: dark ? Colors.white : RC.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: dark ? Colors.white : RC.text),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? RC.darkSurface : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: dark ? RC.darkLine : RC.line)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: dark ? RC.darkLine : RC.line)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RC.action, width: 1.6)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: RC.action,
        foregroundColor: Colors.white,
        minimumSize: const Size(48, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: dark ? RC.darkLine : RC.line),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
  );
}

/* ============================== modelos ============================== */

class Apunte {
  Apunte({
    required this.id,
    required this.title,
    required this.subject,
    required this.sede,
    required this.career,
    required this.year,
    required this.type,
    required this.format,
    required this.ownerId,
    required this.uploader,
    required this.date,
    required this.up,
    required this.down,
    required this.dl,
    required this.nc,
    required this.pages,
    required this.desc,
    required this.tags,
    required this.fileName,
    required this.chunks,
    required this.size,
    required this.ready,
  });

  final String id, title, subject, sede, career, type, format, ownerId, uploader, desc;
  final int year, up, down, dl, nc, pages;
  final DateTime date;
  final List<String> tags;
  final String? fileName;
  final int chunks, size; // el archivo vive en materials/{id}/chunks/{000..}
  final bool ready; // false mientras se suben los pedazos

  int get pct => (up + down) == 0 ? 0 : (up * 100 / (up + down)).round();
  bool get isImage => format == 'IMG';
  bool get hasFile => chunks > 0;

  factory Apunte.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    int i(String k) => (m[k] as num?)?.toInt() ?? 0;
    final ts = m['createdAt'];
    return Apunte(
      id: d.id,
      title: m['title'] ?? '',
      subject: m['subject'] ?? '',
      sede: m['sede'] ?? '',
      career: m['career'] ?? '',
      year: i('year'),
      type: m['type'] ?? 'Apunte',
      format: m['format'] ?? 'PDF',
      ownerId: m['ownerId'] ?? '',
      uploader: m['uploader'] ?? '',
      date: ts is Timestamp ? ts.toDate() : DateTime.now(),
      up: i('up'),
      down: i('down'),
      dl: i('dl'),
      nc: i('nc'),
      pages: i('pages') == 0 ? 1 : i('pages'),
      desc: m['desc'] ?? '',
      tags: List<String>.from(m['tags'] ?? const []),
      fileName: m['fileName'],
      chunks: i('chunks'),
      size: i('size'),
      ready: m['ready'] != false,
    );
  }
}

class Perfil {
  Perfil({
    required this.uid,
    required this.name,
    required this.email,
    required this.sede,
    required this.career,
    required this.year,
    required this.votes,
    required this.saved,
    required this.collections,
    required this.recent,
    required this.downloads,
  });

  final String uid, name, email, sede, career;
  final int year;
  final Map<String, int> votes; // idApunte -> 1 / -1
  final Map<String, String> saved; // idApunte -> idColección
  final List<Map<String, String>> collections; // {id, name}
  final List<String> recent;
  final List<Map<String, String>> downloads; // {id, d}

  factory Perfil.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    final cols = (m['collections'] as List? ?? const [])
        .map((e) => {'id': '${(e as Map)['id']}', 'name': '${e['name']}'})
        .toList();
    if (!cols.any((c) => c['id'] == 'gen')) cols.insert(0, {'id': 'gen', 'name': 'General'});
    return Perfil(
      uid: d.id,
      name: m['name'] ?? '',
      email: m['email'] ?? '',
      sede: m['sede'] ?? kSedes.first,
      career: m['career'] ?? '',
      year: (m['year'] as num?)?.toInt() ?? 1,
      votes: (m['votes'] as Map? ?? const {}).map((k, v) => MapEntry('$k', (v as num).toInt())),
      saved: (m['saved'] as Map? ?? const {}).map((k, v) => MapEntry('$k', '$v')),
      collections: cols,
      recent: List<String>.from(m['recent'] ?? const []),
      downloads: (m['downloads'] as List? ?? const [])
          .map((e) => {'id': '${(e as Map)['id']}', 'd': '${e['d']}'})
          .toList(),
    );
  }
}

class Aviso {
  Aviso(this.id, this.ic, this.t, this.ref, this.read, this.date);
  final String id, ic, t, ref;
  final bool read;
  final DateTime date;

  factory Aviso.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    final ts = m['createdAt'];
    return Aviso(d.id, m['ic'] ?? 'star', m['t'] ?? '', m['ref'] ?? '', m['read'] == true,
        ts is Timestamp ? ts.toDate() : DateTime.now());
  }
}

class Comentario {
  Comentario(this.id, this.uid, this.who, this.t, this.date);
  final String id, uid, who, t;
  final DateTime date;

  factory Comentario.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    final ts = m['createdAt'];
    return Comentario(d.id, m['uid'] ?? '', m['who'] ?? '', m['t'] ?? '', ts is Timestamp ? ts.toDate() : DateTime.now());
  }
}

class RankRow {
  RankRow(this.uid, this.name, this.sede);
  final String uid, name, sede;
  int posts = 0, pts = 0;
}

/* ============================== estado y Firebase ============================== */

class RepoStore extends ChangeNotifier {
  RepoStore() {
    _init();
  }

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // Los archivos se guardan en Firestore partidos en pedazos (el plan gratis
  // de Firebase no incluye Storage). Cada documento admite hasta 1 MiB.
  static const _chunkBytes = 900 * 1024;
  final _fileCache = <String, Uint8List>{};

  bool ready = false;
  bool onboarded = false;
  ThemeMode themeMode = ThemeMode.system;
  User? user;
  Perfil? perfil;
  List<Apunte> apuntes = [];
  List<Aviso> avisos = [];

  final _subs = <StreamSubscription>[];
  StreamSubscription? _authSub;

  CollectionReference<Map<String, dynamic>> get _mats => _db.collection('materials');
  DocumentReference<Map<String, dynamic>> _userRef(String uid) => _db.collection('users').doc(uid);

  Future<void> _init() async {
    try {
      final p = await SharedPreferences.getInstance();
      onboarded = p.getBool('repo_onboarded') ?? false;
      themeMode = ThemeMode.values[(p.getInt('repo_theme') ?? 0).clamp(0, 2)];
    } catch (_) {}
    _authSub = _auth.authStateChanges().listen(_onAuth);
  }

  void _onAuth(User? u) {
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();
    user = u;
    perfil = null;
    apuntes = [];
    avisos = [];
    if (u == null) {
      ready = true;
      notifyListeners();
      return;
    }
    _subs.add(_userRef(u.uid).snapshots().listen((d) {
      if (d.exists) perfil = Perfil.fromDoc(d);
      ready = true;
      notifyListeners();
    }, onError: (_) {
      ready = true;
      notifyListeners();
    }));
    _subs.add(_mats.orderBy('createdAt', descending: true).limit(500).snapshots().listen((q) {
      // Los apuntes a medio subir solo los ve quien los está subiendo.
      apuntes = q.docs.map(Apunte.fromDoc).where((a) => a.ready || a.ownerId == u.uid).toList();
      notifyListeners();
    }));
    _subs.add(_userRef(u.uid).collection('notifs').orderBy('createdAt', descending: true).limit(40).snapshots().listen((q) {
      avisos = q.docs.map(Aviso.fromDoc).toList();
      notifyListeners();
    }));
  }

  @override
  void dispose() {
    _authSub?.cancel();
    for (final s in _subs) {
      s.cancel();
    }
    super.dispose();
  }

  /* ---------- preferencias ---------- */
  Future<void> setOnboarded() async {
    onboarded = true;
    notifyListeners();
    try {
      (await SharedPreferences.getInstance()).setBool('repo_onboarded', true);
    } catch (_) {}
  }

  Future<void> setTheme(ThemeMode m) async {
    themeMode = m;
    notifyListeners();
    try {
      (await SharedPreferences.getInstance()).setInt('repo_theme', m.index);
    } catch (_) {}
  }

  /* ---------- cuenta ---------- */
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String sede,
    required String career,
    required int year,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
    final uid = cred.user!.uid;
    await _userRef(uid).set({
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'sede': sede,
      'career': career,
      'year': year,
      'votes': {},
      'saved': {},
      'collections': [
        {'id': 'gen', 'name': 'General'}
      ],
      'recent': [],
      'downloads': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _userRef(uid).collection('notifs').add({
      'ic': 'star',
      't': '¡Bienvenido/a al Repositorio UCA! Explorá, guardá y compartí material.',
      'ref': 'explore',
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> resetPassword(String email) => _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> logout() => _auth.signOut();

  Future<void> updateProfile({required String name, required String sede, required String career, required int year}) async {
    final uid = user!.uid;
    await _userRef(uid).update({'name': name.trim(), 'sede': sede, 'career': career, 'year': year});
    final mine = await _mats.where('ownerId', isEqualTo: uid).get();
    final b = _db.batch();
    for (final d in mine.docs) {
      b.update(d.reference, {'uploader': name.trim()});
    }
    await b.commit();
  }

  /* ---------- lecturas ---------- */
  Apunte? byId(String id) {
    for (final a in apuntes) {
      if (a.id == id) return a;
    }
    return null;
  }

  List<Apunte> get mine => apuntes.where((a) => a.ownerId == user?.uid).toList();
  int get myPts => mine.length * 10 + mine.fold<int>(0, (s, a) => s + a.up);
  int get unread => avisos.where((a) => !a.read).length;

  List<RankRow> ranking({String? sede}) {
    final g = <String, RankRow>{};
    for (final a in apuntes) {
      final r = g.putIfAbsent(a.ownerId, () => RankRow(a.ownerId, a.uploader, a.sede));
      r.posts++;
      r.pts += 10 + a.up;
    }
    if (user != null && perfil != null) {
      g.putIfAbsent(user!.uid, () => RankRow(user!.uid, perfil!.name, perfil!.sede));
    }
    final l = g.values.where((r) => sede == null || r.sede == sede).toList()..sort((a, b) => b.pts - a.pts);
    return l;
  }

  int ptsOf(String uid) => ranking().firstWhere((r) => r.uid == uid, orElse: () => RankRow(uid, '', '')).pts;

  Stream<List<Comentario>> comments(String id) => _mats
      .doc(id)
      .collection('comments')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((q) => q.docs.map(Comentario.fromDoc).toList());

  /* ---------- acciones ---------- */
  Future<void> _notify(String uid, String ic, String t, String ref) async {
    if (uid.isEmpty || uid == user?.uid) return;
    try {
      await _userRef(uid).collection('notifs').add({
        'ic': ic,
        't': t,
        'ref': ref,
        'read': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }

  Future<String> publish({
    required Uint8List bytes,
    required String fileName,
    required String title,
    required String sede,
    required String career,
    required int year,
    required String type,
    required String subject,
    required String desc,
    required List<String> tags,
  }) async {
    final uid = user!.uid;
    final ext = fileName.split('.').last.toLowerCase();
    final fmt = kExtFormat[ext];
    if (fmt == null) throw 'Ese formato no está permitido. Subí un PDF, Word, PowerPoint o imagen.';
    if (bytes.length > kMaxBytes) throw 'El archivo pesa más de 20 MB.';
    final doc = _mats.doc();
    final n = (bytes.length / _chunkBytes).ceil();
    // 1) el apunte se crea "no listo" para que nadie lo vea a medio subir
    await doc.set({
      'title': title.trim(),
      'subject': subject.trim(),
      'sede': sede,
      'career': career,
      'year': year,
      'type': type,
      'format': fmt,
      'ownerId': uid,
      'uploader': perfil?.name ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'up': 0,
      'down': 0,
      'dl': 0,
      'nc': 0,
      'pages': (bytes.length / 90000).round().clamp(1, 500),
      'desc': desc.trim().isEmpty ? 'Material compartido por un estudiante de la UCA.' : desc.trim(),
      'tags': tags.take(5).toList(),
      'fileName': fileName,
      'mime': kExtMime[ext],
      'size': bytes.length,
      'chunks': n,
      'ready': false,
    });
    try {
      // 2) los pedazos, de a 8 por tanda (cada escritura admite hasta ~10 MB)
      for (var start = 0; start < n; start += 8) {
        final b = _db.batch();
        for (var k = start; k < n && k < start + 8; k++) {
          final end = (k + 1) * _chunkBytes > bytes.length ? bytes.length : (k + 1) * _chunkBytes;
          b.set(doc.collection('chunks').doc(k.toString().padLeft(3, '0')), {
            'd': Blob(Uint8List.sublistView(bytes, k * _chunkBytes, end)),
          });
        }
        await b.commit();
      }
      // 3) listo: ahora aparece para todos
      await doc.update({'ready': true});
    } catch (e) {
      await _deleteChunks(doc.id, n);
      await doc.delete();
      rethrow;
    }
    _fileCache[doc.id] = bytes;
    return doc.id;
  }

  Future<void> _deleteChunks(String id, int n) async {
    for (var start = 0; start < n; start += 400) {
      final b = _db.batch();
      for (var k = start; k < n && k < start + 400; k++) {
        b.delete(_mats.doc(id).collection('chunks').doc(k.toString().padLeft(3, '0')));
      }
      await b.commit();
    }
  }

  /// Arma el archivo juntando sus pedazos.
  Future<Uint8List> fileBytes(Apunte a) async {
    final cached = _fileCache[a.id];
    if (cached != null) return cached;
    if (!a.hasFile) throw 'Este material no tiene archivo.';
    final q = await _mats.doc(a.id).collection('chunks').orderBy(FieldPath.documentId).get();
    final out = BytesBuilder(copy: false);
    for (final d in q.docs) {
      out.add((d.data()['d'] as Blob).bytes);
    }
    final bytes = out.takeBytes();
    if (q.docs.length != a.chunks) throw 'El archivo está incompleto. Probá de nuevo más tarde.';
    _fileCache[a.id] = bytes;
    return bytes;
  }

  /// Borra los comentarios del apunte (Firestore no borra subcolecciones solo).
  Future<void> _deleteComments(String id) async {
    final col = _mats.doc(id).collection('comments');
    while (true) {
      final q = await col.limit(400).get();
      if (q.docs.isEmpty) return;
      final b = _db.batch();
      for (final d in q.docs) {
        b.delete(d.reference);
      }
      await b.commit();
    }
  }

  Future<void> deleteMine(Apunte a) async {
    await _deleteComments(a.id);
    await _deleteChunks(a.id, a.chunks);
    await _mats.doc(a.id).delete();
    _fileCache.remove(a.id);
  }

  Future<void> vote(Apunte a, int v) async {
    final uid = user!.uid;
    if (a.ownerId == uid) throw 'No podés votar tu propio aporte.';
    final cur = perfil?.votes[a.id] ?? 0;
    final nv = cur == v ? 0 : v;
    var dUp = 0, dDown = 0;
    if (cur == 1) dUp--;
    if (cur == -1) dDown--;
    if (nv == 1) dUp++;
    if (nv == -1) dDown++;
    final upd = <String, dynamic>{};
    if (dUp != 0) upd['up'] = FieldValue.increment(dUp);
    if (dDown != 0) upd['down'] = FieldValue.increment(dDown);
    final b = _db.batch();
    if (upd.isNotEmpty) b.update(_mats.doc(a.id), upd);
    b.update(_userRef(uid), {'votes.${a.id}': nv == 0 ? FieldValue.delete() : nv});
    await b.commit();
    if (nv == 1) _notify(a.ownerId, 'star', 'Tu aporte "${a.title}" recibió un voto útil', 'doc/${a.id}');
  }

  Future<void> addComment(Apunte a, String t) async {
    final text = t.trim();
    if (text.isEmpty) return;
    final b = _db.batch();
    b.set(_mats.doc(a.id).collection('comments').doc(), {
      'uid': user!.uid,
      'who': perfil?.name ?? '',
      't': text.length > 280 ? text.substring(0, 280) : text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    b.update(_mats.doc(a.id), {'nc': FieldValue.increment(1)});
    await b.commit();
    _notify(a.ownerId, 'comment', '${perfil?.name ?? 'Alguien'} comentó en tu aporte "${a.title}"', 'comments/${a.id}');
  }

  /// Descarga: junta los pedazos y abre el "Guardar como" del celu o la compu.
  /// Devuelve false si la persona canceló.
  Future<bool> download(Apunte a) async {
    final bytes = await fileBytes(a);
    final name = a.fileName ?? '${a.title}.${a.format.toLowerCase()}';
    final ext = name.split('.').last.toLowerCase();
    final saved = await FilePicker.platform.saveFile(
      dialogTitle: 'Guardar apunte',
      fileName: name,
      type: FileType.custom,
      allowedExtensions: [ext],
      bytes: bytes,
    );
    // En la web el navegador descarga solo y saveFile devuelve null.
    if (saved == null && !kIsWeb) return false;
    try {
      await _mats.doc(a.id).update({'dl': FieldValue.increment(1)});
      final d = DateTime.now().toIso8601String().substring(0, 10);
      final list = [
        {'id': a.id, 'd': d},
        ...(perfil?.downloads ?? []).where((x) => x['id'] != a.id),
      ].take(200).toList();
      await _userRef(user!.uid).update({'downloads': list});
      if ((a.dl + 1) % 10 == 0) {
        _notify(a.ownerId, 'download', 'Tu aporte "${a.title}" ya se descargó ${a.dl + 1} veces', 'doc/${a.id}');
      }
    } catch (_) {}
    return true;
  }

  Future<void> report(Apunte a, String reason, String detail) => _db.collection('reports').add({
        'materialId': a.id,
        'by': user!.uid,
        'reason': reason,
        'detail': detail.length > 300 ? detail.substring(0, 300) : detail,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> saveTo(String id, String? colId) {
    return _userRef(user!.uid).update({'saved.$id': colId ?? FieldValue.delete()});
  }

  Future<String> newCollection(String name) async {
    final id = 'c${DateTime.now().millisecondsSinceEpoch}';
    final cols = [...?perfil?.collections, {'id': id, 'name': name.trim()}];
    await _userRef(user!.uid).update({'collections': cols});
    return id;
  }

  Future<void> deleteCollection(String id) async {
    if (id == 'gen') return;
    final cols = (perfil?.collections ?? []).where((c) => c['id'] != id).toList();
    final upd = <String, dynamic>{'collections': cols};
    perfil?.saved.forEach((k, v) {
      if (v == id) upd['saved.$k'] = 'gen';
    });
    await _userRef(user!.uid).update(upd);
  }

  Future<void> touchRecent(String id) async {
    final r = perfil?.recent ?? [];
    if (r.isNotEmpty && r.first == id) return;
    final list = [id, ...r.where((x) => x != id)].take(6).toList();
    try {
      await _userRef(user!.uid).update({'recent': list});
    } catch (_) {}
  }

  Future<void> clearDownloads() => _userRef(user!.uid).update({'downloads': []});

  Future<void> markRead(String? id) async {
    final col = _userRef(user!.uid).collection('notifs');
    final b = _db.batch();
    for (final a in avisos.where((a) => !a.read && (id == null || a.id == id))) {
      b.update(col.doc(a.id), {'read': true});
    }
    await b.commit();
  }
}

class RepoScope extends InheritedNotifier<RepoStore> {
  const RepoScope({super.key, required RepoStore store, required super.child}) : super(notifier: store);
  static RepoStore of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<RepoScope>()!.notifier!;
  static RepoStore read(BuildContext context) => context.getInheritedWidgetOfExactType<RepoScope>()!.notifier!;
}

/* ============================== ayudas ============================== */

String first(String n) => n.trim().isEmpty ? '' : n.trim().split(RegExp(r'\s+')).first;
String initials(String n) {
  final p = n.trim().split(RegExp(r'\s+')).where((x) => x.isNotEmpty).toList();
  if (p.isEmpty) return '?';
  return (p.first[0] + (p.length > 1 ? p.last[0] : '')).toUpperCase();
}

String fdate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
String shortSede(String s) => s.replaceFirst('Sede ', '');
String norm(String s) {
  const a = 'áéíóúüñÁÉÍÓÚÜÑ', b = 'aeiouunAEIOUUN';
  final sb = StringBuffer();
  for (final ch in s.split('')) {
    final i = a.indexOf(ch);
    sb.write(i >= 0 ? b[i] : ch);
  }
  return sb.toString().toLowerCase();
}

String authError(Object e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Ya hay una cuenta con ese correo. Probá ingresar.';
      case 'invalid-email':
        return 'Ingresá un correo válido.';
      case 'weak-password':
        return 'La contraseña tiene que tener al menos 6 caracteres.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Correo o contraseña incorrectos.';
      case 'too-many-requests':
        return 'Demasiados intentos. Esperá un momento y probá de nuevo.';
      case 'network-request-failed':
        return 'Sin conexión. Revisá internet y probá de nuevo.';
    }
    return e.message ?? 'No se pudo completar. Probá de nuevo.';
  }
  if (e is FirebaseException) return e.message ?? 'Error de conexión. Probá de nuevo.';
  return e.toString();
}

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
}

bool isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
Color surface(BuildContext c) => isDark(c) ? RC.darkSurface : Colors.white;
Color lineC(BuildContext c) => isDark(c) ? RC.darkLine : RC.line;
Color mutedC(BuildContext c) => isDark(c) ? const Color(0xFF9AA7CC) : RC.muted;

TextStyle h(double size, {Color? color, FontWeight w = FontWeight.w600}) =>
    GoogleFonts.poppins(fontSize: size, fontWeight: w, color: color);

Future<T?> push<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));

/* ============================== widget raíz ============================== */

class RepositorioUcaApp extends StatefulWidget {
  const RepositorioUcaApp({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<RepositorioUcaApp> createState() => _RepositorioUcaAppState();
}

class _RepositorioUcaAppState extends State<RepositorioUcaApp> {
  late final RepoStore store = RepoStore();

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RepoScope(
        store: store,
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Repositorio UCA',
            theme: _theme(Brightness.light),
            darkTheme: _theme(Brightness.dark),
            themeMode: store.themeMode,
            home: const _Gate(),
          ),
        ),
      ),
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    if (!s.ready) return const SplashScreen();
    if (s.user == null) return s.onboarded ? const LoginScreen() : const OnboardingScreen();
    if (s.perfil == null) return const SplashScreen();
    return const HomeShell();
  }
}

/* ============================== componentes ============================== */

class LogoBox extends StatelessWidget {
  const LogoBox({super.key, this.size = 44});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: RC.brand,
          borderRadius: BorderRadius.circular(size * .28),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(Icons.school_outlined, color: RC.amber, size: size * .55),
      );
}

class Avatar extends StatelessWidget {
  const Avatar(this.name, {super.key, this.size = 40});
  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: size / 2,
        backgroundColor: RC.brand,
        child: Text(initials(name),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: size * .36)),
      );
}

class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, this.amber = false, this.color});
  final String text;
  final bool amber;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? (amber ? const Color(0xFFB45309) : RC.action);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: amber ? const Color(0xFFFEF3C7) : c.withValues(alpha: isDark(context) ? .25 : .1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: amber ? const Color(0xFF92400E) : (isDark(context) ? Colors.white : c))),
    );
  }
}

class Box extends StatelessWidget {
  const Box({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.leftColor, this.onTap});
  final Widget child;
  final EdgeInsets padding;
  final Color? leftColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lineC(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: leftColor == null
            ? null
            : BoxDecoration(border: Border(left: BorderSide(color: leftColor!, width: 4))),
        padding: padding,
        child: child,
      ),
    );
    if (onTap == null) return card;
    return InkWell(borderRadius: BorderRadius.circular(16), onTap: onTap, child: card);
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow(this.items, {super.key});
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(
              child: Box(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                child: Column(children: [
                  Text(items[i].$1, style: h(18, w: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(items[i].$2, style: TextStyle(fontSize: 12, color: mutedC(context)), textAlign: TextAlign.center),
                ]),
              ),
            ),
          ]
        ],
      );
}

class Section extends StatelessWidget {
  const Section(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 22, bottom: 10),
        child: Row(children: [
          Expanded(child: Text(title, style: h(16))),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!, style: const TextStyle(fontWeight: FontWeight.w600))),
        ]),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.text, this.actions = const []});
  final IconData icon;
  final String title, text;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 12),
        child: Column(children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(color: RC.action.withValues(alpha: .1), shape: BoxShape.circle),
            child: Icon(icon, size: 34, color: RC.action),
          ),
          const SizedBox(height: 14),
          Text(title, style: h(17), textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(text, style: TextStyle(color: mutedC(context), height: 1.45), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          for (final a in actions) Padding(padding: const EdgeInsets.only(top: 8), child: SizedBox(width: double.infinity, child: a)),
        ]),
      );
}

class ApunteCard extends StatelessWidget {
  const ApunteCard(this.a, {super.key});
  final Apunte a;

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final saved = s.perfil?.saved.containsKey(a.id) ?? false;
    final color = kTypeColor[a.type] ?? RC.action;
    return Box(
      leftColor: color,
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
      onTap: () => push(context, DocScreen(a.id)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Pill('${a.type} en ${a.format}', color: color),
          const Spacer(),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: saved ? 'Quitar de guardados' : 'Guardar apunte',
            icon: Icon(saved ? Icons.bookmark : Icons.bookmark_outline, color: saved ? RC.amber : mutedC(context)),
            onPressed: () => s.saveTo(a.id, saved ? null : 'gen'),
          ),
        ]),
        Text(a.title, style: h(15.5)),
        const SizedBox(height: 2),
        Text(a.subject, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 2),
        Text('${shortSede(a.sede)}, ${a.career}, ${a.year}° año', style: TextStyle(color: mutedC(context), fontSize: 12.5)),
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.star_outline_rounded, size: 16, color: mutedC(context)),
          const SizedBox(width: 4),
          Expanded(child: Text('${a.pct}% útil, ${a.dl} descargas', style: TextStyle(color: mutedC(context), fontSize: 12.5))),
          Text('Ver apunte', style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(width: 6),
        ]),
      ]),
    );
  }
}

class ApunteList extends StatelessWidget {
  const ApunteList(this.list, {super.key});
  final List<Apunte> list;

  @override
  Widget build(BuildContext context) => Column(children: [
        for (final a in list) Padding(padding: const EdgeInsets.only(bottom: 10), child: ApunteCard(a)),
      ]);
}

/// Selector simple (campo + hoja con opciones). No usa DropdownButtonFormField
/// para no depender de la versión de Flutter que tenga FlutterFlow.
Widget dropdown<T>({
  required String label,
  required T? value,
  required List<T> items,
  required String Function(T) text,
  required ValueChanged<T?> onChanged,
  String? hint,
}) =>
    Builder(builder: (context) {
      final has = value != null && items.contains(value);
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: items.isEmpty
            ? null
            : () async {
                final picked = await showModalBottomSheet<T>(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  builder: (ctx) => SafeArea(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * .7),
                      child: ListView(shrinkWrap: true, children: [
                        Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 8), child: Text(label, style: h(17))),
                        for (final i in items)
                          ListTile(
                            title: Text(text(i)),
                            trailing: i == value ? const Icon(Icons.check, color: RC.action) : null,
                            onTap: () => Navigator.pop(ctx, i),
                          ),
                      ]),
                    ),
                  ),
                );
                if (picked != null) onChanged(picked);
              },
        child: InputDecorator(
          isEmpty: !has,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            suffixIcon: const Icon(Icons.expand_more),
            enabled: items.isNotEmpty || has,
          ),
          child: Text(has ? text(value as T) : '', overflow: TextOverflow.ellipsis),
        ),
      );
    });

/* ============================== acceso ============================== */

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [RC.brand, Color(0xFF0B1020)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const LogoBox(size: 76),
              const SizedBox(height: 18),
              Text('Repositorio UCA', style: h(26, color: Colors.white, w: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Material colaborativo entre estudiantes', style: TextStyle(color: Color(0xFFB8C7F5))),
              const SizedBox(height: 26),
              const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(color: RC.amber, strokeWidth: 2.6)),
            ]),
          ),
        ),
      );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pc = PageController();
  int i = 0;
  static const pages = [
    (Icons.search, 'Encontrá apuntes en segundos', 'Buscá por materia, carrera o tipo de material, y filtrá por sede y año de cursada.'),
    (Icons.upload_outlined, 'Compartí lo que sabés', 'Subí tus resúmenes, guías y exámenes para que otros estudien mejor.'),
    (Icons.star_outline_rounded, 'Votá y guardá lo mejor', 'Los votos destacan el material más útil. Guardalo en colecciones para encontrarlo rápido.'),
  ];

  void _done(bool register) {
    final s = RepoScope.read(context);
    s.setOnboarded();
    if (register) push(context, const RegisterScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Row(children: [
              Text('${i + 1} de 3', style: TextStyle(color: mutedC(context))),
              const Spacer(),
              TextButton(onPressed: () => _done(false), child: const Text('Saltar')),
            ]),
            Expanded(
              child: PageView(
                controller: _pc,
                onPageChanged: (v) => setState(() => i = v),
                children: [
                  for (final p in pages)
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(color: RC.brand, borderRadius: BorderRadius.circular(32)),
                        child: Icon(p.$1, size: 60, color: RC.amber),
                      ),
                      const SizedBox(height: 28),
                      Text(p.$2, style: h(24, w: FontWeight.w700), textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      Text(p.$3, style: TextStyle(color: mutedC(context), fontSize: 15, height: 1.45), textAlign: TextAlign.center),
                    ]),
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var k = 0; k < 3; k++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(3),
                  width: k == i ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(color: k == i ? RC.action : lineC(context), borderRadius: BorderRadius.circular(4)),
                ),
            ]),
            const SizedBox(height: 20),
            if (i < 2)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _pc.nextPage(duration: const Duration(milliseconds: 280), curve: Curves.easeOut),
                  child: const Text('Siguiente'),
                ),
              )
            else ...[
              SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _done(true), child: const Text('Crear mi cuenta'))),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => _done(false), child: const Text('Ya tengo cuenta'))),
            ],
          ]),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController(), pass = TextEditingController();
  bool show = false, busy = false;
  String? err;

  Future<void> _go() async {
    setState(() {
      busy = true;
      err = null;
    });
    try {
      await RepoScope.read(context).login(email.text, pass.text);
    } catch (e) {
      setState(() => err = authError(e));
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: EdgeInsets.zero, children: [
        Container(
          padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 40, 22, 30),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [RC.brand, RC.brand2]),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const LogoBox(size: 46),
            const SizedBox(height: 18),
            Text('Ingresá a tu cuenta', style: h(24, color: Colors.white, w: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Usá tu correo para entrar al repositorio.', style: TextStyle(color: Color(0xFFB8C7F5))),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: AutofillGroup(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(labelText: 'Correo', hintText: 'nombre@uca.edu.ar'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: pass,
                obscureText: !show,
                autofillHints: const [AutofillHints.password],
                onSubmitted: (_) => _go(),
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Mínimo 6 caracteres',
                  suffixIcon: TextButton(onPressed: () => setState(() => show = !show), child: Text(show ? 'Ocultar' : 'Mostrar')),
                ),
              ),
              if (err != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(err!, style: const TextStyle(color: RC.bad))),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: () => push(context, const ForgotScreen()), child: const Text('¿Olvidaste tu contraseña?')),
              ),
              FilledButton(
                onPressed: busy ? null : _go,
                child: busy
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
                    : const Text('Ingresar'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => toast(context, 'El ingreso con cuenta UCA va a estar disponible próximamente.'),
                icon: const Icon(Icons.school_outlined),
                label: const Text('Continuar con cuenta UCA'),
              ),
              const SizedBox(height: 14),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('¿No tenés cuenta?', style: TextStyle(color: mutedC(context))),
                TextButton(onPressed: () => push(context, const RegisterScreen()), child: const Text('Crear cuenta')),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController(), email = TextEditingController(), pass = TextEditingController();
  String? sede, career, err;
  int? year;
  bool terms = false, busy = false;

  Future<void> _go() async {
    String? e;
    if (name.text.trim().length < 2) {
      e = 'Escribí tu nombre y apellido.';
    } else if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(email.text.trim())) {
      e = 'Ingresá un correo válido.';
    } else if (pass.text.length < 6) {
      e = 'La contraseña tiene que tener al menos 6 caracteres.';
    } else if (sede == null || career == null || year == null) {
      e = 'Elegí tu sede, tu carrera y el año de cursada.';
    } else if (!terms) {
      e = 'Tenés que aceptar los términos para crear la cuenta.';
    }
    if (e != null) return setState(() => err = e);
    setState(() {
      busy = true;
      err = null;
    });
    try {
      await RepoScope.read(context).register(
          name: name.text, email: email.text, password: pass.text, sede: sede!, career: career!, year: year!);
      if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
    } catch (x) {
      setState(() => err = authError(x));
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'Nombre y apellido', hintText: 'Ej: Sofía Pérez')),
        const SizedBox(height: 14),
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Correo', hintText: 'nombre@uca.edu.ar', helperText: 'Si tenés correo institucional, usalo.'),
        ),
        const SizedBox(height: 14),
        TextField(controller: pass, obscureText: true, decoration: const InputDecoration(labelText: 'Contraseña', hintText: 'Mínimo 6 caracteres')),
        const SizedBox(height: 14),
        dropdown<String>(
          label: 'Sede',
          value: sede,
          items: kSedes,
          text: (s) => s,
          onChanged: (v) => setState(() {
            sede = v;
            career = null;
          }),
        ),
        const SizedBox(height: 14),
        dropdown<String>(
          label: 'Carrera',
          value: career,
          items: sede == null ? const [] : kAcad[sede]!,
          text: (s) => s,
          hint: sede == null ? 'Elegí primero la sede' : 'Elegí tu carrera',
          onChanged: (v) => setState(() => career = v),
        ),
        const SizedBox(height: 14),
        dropdown<int>(label: 'Año de cursada', value: year, items: const [1, 2, 3, 4, 5], text: (y) => '$y° año', onChanged: (v) => setState(() => year = v)),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          value: terms,
          onChanged: (v) => setState(() => terms = v ?? false),
          title: const Text('Acepto los términos y la política de privacidad, y me comprometo a subir solo material que pueda compartir.',
              style: TextStyle(fontSize: 13.5)),
        ),
        if (err != null) Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(err!, style: const TextStyle(color: RC.bad))),
        FilledButton(
          onPressed: busy ? null : _go,
          child: busy
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white))
              : const Text('Crear cuenta'),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('¿Ya tenés cuenta?', style: TextStyle(color: mutedC(context))),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Ingresar')),
        ]),
      ]),
    );
  }
}

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final email = TextEditingController();
  bool sent = false, busy = false;
  String? err;

  Future<void> _go() async {
    setState(() {
      busy = true;
      err = null;
    });
    try {
      await RepoScope.read(context).resetPassword(email.text);
      setState(() => sent = true);
    } catch (e) {
      setState(() => err = authError(e));
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        if (sent)
          EmptyState(
            icon: Icons.mark_email_read_outlined,
            title: 'Revisá tu correo',
            text: 'Si hay una cuenta con ${email.text.trim()}, te mandamos un link para crear una contraseña nueva. Mirá también en spam.',
            actions: [FilledButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Volver a ingresar'))],
          )
        else ...[
          Text('Te mandamos un link a tu correo para que crees una contraseña nueva.', style: TextStyle(color: mutedC(context), height: 1.45)),
          const SizedBox(height: 16),
          TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Correo')),
          if (err != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(err!, style: const TextStyle(color: RC.bad))),
          const SizedBox(height: 16),
          FilledButton(onPressed: busy ? null : _go, child: const Text('Enviar link')),
        ],
      ]),
    );
  }
}

/* ============================== navegación principal ============================== */

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> {
  int tab = 0;
  final explore = ExploreController();

  void goExplore({String? type, bool reset = false}) {
    if (reset) explore.reset();
    if (type != null) {
      explore.reset();
      explore.type = type;
    }
    explore.notify();
    setState(() => tab = 1);
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, Icons.home, 'Inicio'),
      (Icons.search, Icons.search, 'Explorar'),
      (Icons.bookmark_outline, Icons.bookmark, 'Guardados'),
      (Icons.person_outline, Icons.person, 'Perfil'),
    ];
    Widget item(int idx) {
      final on = tab == idx;
      final c = on ? RC.action : mutedC(context);
      return Expanded(
        child: InkWell(
          onTap: () => setState(() => tab = idx),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(on ? items[idx].$2 : items[idx].$1, color: c),
              const SizedBox(height: 2),
              Text(items[idx].$3, style: TextStyle(fontSize: 11, color: c, fontWeight: on ? FontWeight.w600 : FontWeight.w500)),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(index: tab, children: [
        HomeTab(shell: this),
        ExploreTab(controller: explore),
        const SavedTab(),
        const ProfileTab(),
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: surface(context), border: Border(top: BorderSide(color: lineC(context)))),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(children: [
              item(0),
              item(1),
              SizedBox(
                width: 72,
                child: Center(
                  child: Material(
                    color: RC.action,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => push(context, const UploadScreen()),
                      child: const SizedBox(width: 52, height: 52, child: Icon(Icons.add, color: Colors.white, size: 28)),
                    ),
                  ),
                ),
              ),
              item(2),
              item(3),
            ]),
          ),
        ),
      ),
    );
  }
}

/* ============================== inicio ============================== */

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.shell});
  final HomeShellState shell;

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final u = s.perfil!;
    final top = s.apuntes.where((a) => a.career == u.career).toList()..sort((a, b) => b.up - a.up);
    final recent = u.recent.map(s.byId).whereType<Apunte>().toList();
    final subj = <String, int>{};
    for (final a in s.apuntes) {
      subj[a.subject] = (subj[a.subject] ?? 0) + 1;
    }
    final subjects = subj.entries.toList()..sort((a, b) => b.value - a.value);
    final rank = s.ranking().where((r) => r.pts > 0).take(3).toList();

    return ListView(padding: EdgeInsets.zero, children: [
      Container(
        padding: EdgeInsets.fromLTRB(18, MediaQuery.of(context).padding.top + 14, 18, 22),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [RC.brand, RC.brand2]),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const LogoBox(size: 38),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Repositorio UCA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                Text('Material colaborativo', style: TextStyle(color: Color(0xFFB8C7F5), fontSize: 12)),
              ]),
            ),
            IconButton(
              onPressed: () => push(context, const NotifsScreen()),
              icon: Badge(
                isLabelVisible: s.unread > 0,
                label: Text('${s.unread}'),
                backgroundColor: RC.amber,
                child: const Icon(Icons.notifications_none, color: Colors.white),
              ),
            ),
          ]),
          const SizedBox(height: 18),
          Text('Hola, ${first(u.name)}', style: h(26, color: Colors.white, w: FontWeight.w700)),
          Text('${u.career}, ${shortSede(u.sede)}', style: const TextStyle(color: Color(0xFFB8C7F5))),
          const SizedBox(height: 14),
          InkWell(
            onTap: () => shell.goExplore(reset: true),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24)),
              child: const Row(children: [
                Icon(Icons.search, color: Color(0xFFB8C7F5), size: 20),
                SizedBox(width: 8),
                Text('Buscar apuntes, temas, parciales', style: TextStyle(color: Color(0xFFB8C7F5))),
              ]),
            ),
          ),
        ]),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          StatsRow([
            ('${s.apuntes.length}', 'materiales'),
            ('${s.mine.length}', 'tus aportes'),
            ('${u.saved.length}', 'guardados'),
          ]),
          const Section('Buscar por tipo'),
          Row(children: [
            for (final t in kTypes) ...[
              Expanded(
                child: Box(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onTap: () => shell.goExplore(type: t),
                  child: Column(children: [
                    Icon(kTypeIcon[t], color: kTypeColor[t]),
                    const SizedBox(height: 6),
                    Text(kTypePlural[t]!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Container(height: 3, margin: const EdgeInsets.symmetric(horizontal: 10), color: kTypeColor[t]),
                  ]),
                ),
              ),
              if (t != kTypes.last) const SizedBox(width: 8),
            ]
          ]),
          if (recent.isNotEmpty) ...[
            const Section('Seguí donde lo dejaste'),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recent.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (_, k) {
                  final a = recent[k];
                  return SizedBox(
                    width: 200,
                    child: Box(
                      leftColor: kTypeColor[a.type],
                      padding: const EdgeInsets.all(12),
                      onTap: () => push(context, DocScreen(a.id)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(a.type, style: TextStyle(fontSize: 11.5, color: mutedC(context))),
                        Text(a.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        Text(a.subject, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.5, color: mutedC(context))),
                      ]),
                    ),
                  );
                },
              ),
            ),
          ],
          Section('Lo más útil de tu carrera', action: 'Ver todo', onAction: () => shell.goExplore(reset: true)),
          if (top.isEmpty)
            Text('Todavía no hay material de tu carrera. Sé el primero en subir.', style: TextStyle(color: mutedC(context)))
          else
            ApunteList(top.take(3).toList()),
          if (subjects.isNotEmpty) ...[
            const Section('Materias con más material'),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final e in subjects.take(6))
                ActionChip(label: Text('${e.key} (${e.value})'), onPressed: () => push(context, SubjectScreen(e.key))),
            ]),
          ],
          Section('Quienes más aportan', action: 'Ver ranking', onAction: () => push(context, const RankingScreen())),
          if (rank.isEmpty)
            Text('Todavía nadie aportó. ¡Sé el primero!', style: TextStyle(color: mutedC(context)))
          else
            Box(
              padding: EdgeInsets.zero,
              child: Column(children: [
                for (var k = 0; k < rank.length; k++)
                  ListTile(
                    leading: Avatar(rank[k].name, size: 36),
                    title: Text('${k + 1}. ${rank[k].name}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${rank[k].posts} aportes'),
                    trailing: Pill('${rank[k].pts} pts', amber: true),
                    onTap: () => push(context, const RankingScreen()),
                  ),
              ]),
            ),
          const SizedBox(height: 18),
          Box(
            child: Row(children: [
              const Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('¿Tenés buen material?', style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(height: 2),
                  Text('Subilo y ayudá a tus compañeros.'),
                ]),
              ),
              FilledButton(onPressed: () => push(context, const UploadScreen()), child: const Text('Subir')),
            ]),
          ),
        ]),
      ),
    ]);
  }
}

/* ============================== explorar ============================== */

class ExploreController extends ChangeNotifier {
  String q = '', type = '', sede = '', career = '', format = '', sort = 'rel';
  int year = 0;

  void reset() {
    q = type = sede = career = format = '';
    sort = 'rel';
    year = 0;
  }

  void notify() => notifyListeners();

  int get active => [sede, career, format].where((x) => x.isNotEmpty).length + (year > 0 ? 1 : 0) + (sort != 'rel' ? 1 : 0);

  List<Apunte> apply(List<Apunte> all) {
    final nq = norm(q.trim());
    final l = all.where((m) {
      if (sede.isNotEmpty && m.sede != sede) return false;
      if (career.isNotEmpty && m.career != career) return false;
      if (year > 0 && m.year != year) return false;
      if (type.isNotEmpty && m.type != type) return false;
      if (format.isNotEmpty && m.format != format) return false;
      if (nq.isEmpty) return true;
      return norm([m.title, m.subject, m.career, m.type, m.tags.join(' '), m.uploader].join(' ')).contains(nq);
    }).toList();
    switch (sort) {
      case 'new':
        l.sort((a, b) => b.date.compareTo(a.date));
      case 'dl':
        l.sort((a, b) => b.dl - a.dl);
      default:
        l.sort((a, b) => b.up != a.up ? b.up - a.up : b.pct - a.pct);
    }
    return l;
  }
}

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key, required this.controller});
  final ExploreController controller;

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  late final qc = TextEditingController(text: widget.controller.q);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_sync);
  }

  void _sync() {
    if (qc.text != widget.controller.q) qc.text = widget.controller.q;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_sync);
    super.dispose();
  }

  void _filters() {
    final f = widget.controller;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(builder: (ctx, set) {
        void upd(VoidCallback fn) {
          fn();
          set(() {});
          f.notify();
        }

        Widget pills<T>(String label, List<T> vals, T cur, String Function(T) txt, void Function(T) on) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final v in vals) ChoiceChip(label: Text(txt(v)), selected: v == cur, onSelected: (_) => upd(() => on(v))),
                ]),
              ],
            );
        final count = f.apply(RepoScope.read(context).apuntes).length;
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('Filtros', style: h(18)),
              const SizedBox(height: 14),
              dropdown<String>(
                label: 'Sede',
                value: f.sede.isEmpty ? 'Todas' : f.sede,
                items: ['Todas', ...kSedes],
                text: (s) => s,
                onChanged: (v) => upd(() {
                  f.sede = v == 'Todas' || v == null ? '' : v;
                  f.career = '';
                }),
              ),
              const SizedBox(height: 12),
              dropdown<String>(
                label: 'Carrera',
                value: f.career.isEmpty ? 'Todas' : f.career,
                items: ['Todas', ...(f.sede.isEmpty ? kAllCareers : kAcad[f.sede]!)],
                text: (s) => s,
                onChanged: (v) => upd(() => f.career = v == 'Todas' || v == null ? '' : v),
              ),
              pills<int>('Año de cursada', [1, 2, 3, 4, 5], f.year, (y) => '$y° año', (y) => f.year = f.year == y ? 0 : y),
              pills<String>('Formato', kFormats, f.format, (x) => x, (x) => f.format = f.format == x ? '' : x),
              pills<String>('Ordenar por', ['rel', 'new', 'dl'], f.sort,
                  (x) => {'rel': 'Más útiles', 'new': 'Más recientes', 'dl': 'Más descargados'}[x]!, (x) => f.sort = x),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => upd(() {
                      final keep = f.q;
                      f.reset();
                      f.q = keep;
                    }),
                    child: const Text('Limpiar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: FilledButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Ver $count resultados'))),
              ]),
            ]),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final f = widget.controller;
    final list = f.apply(s.apuntes);
    const sortTxt = {'rel': 'más útiles', 'new': 'más recientes', 'dl': 'más descargados'};
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar'), automaticallyImplyLeading: false),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        Row(children: [
          Expanded(
            child: TextField(
              controller: qc,
              onChanged: (v) {
                f.q = v;
                setState(() {});
              },
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Buscar apuntes, temas, parciales'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.outlined(
            onPressed: _filters,
            icon: Badge(isLabelVisible: f.active > 0, label: Text('${f.active}'), child: const Icon(Icons.tune)),
          ),
        ]),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final t in ['', ...kTypes])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(t.isEmpty ? 'Todos' : kTypePlural[t]!),
                  selected: f.type == t,
                  onSelected: (_) => setState(() => f.type = t),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 8),
        Text('${list.length} resultado${list.length == 1 ? '' : 's'}, orden: ${sortTxt[f.sort]}', style: TextStyle(color: mutedC(context))),
        const SizedBox(height: 10),
        if (list.isEmpty)
          EmptyState(
            icon: Icons.search,
            title: 'No encontramos materiales',
            text: 'Probá con otras palabras o sacá algún filtro. También podés subir el material que te falta.',
            actions: [
              OutlinedButton(onPressed: () => setState(f.reset), child: const Text('Limpiar filtros')),
              FilledButton(onPressed: () => push(context, const UploadScreen()), child: const Text('Subir material')),
            ],
          )
        else
          ApunteList(list),
      ]),
    );
  }
}

class SubjectScreen extends StatefulWidget {
  const SubjectScreen(this.name, {super.key});
  final String name;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  String type = '';

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final all = s.apuntes.where((a) => a.subject == widget.name).toList();
    final list = all.where((a) => type.isEmpty || a.type == type).toList();
    final careers = all.map((a) => a.career).toSet().join(', ');
    final dl = all.fold<int>(0, (x, a) => x + a.dl);
    final pct = all.isEmpty ? 0 : (all.fold<int>(0, (x, a) => x + a.pct) / all.length).round();
    return Scaffold(
      appBar: AppBar(title: const Text('Materia')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(gradient: const LinearGradient(colors: [RC.brand, RC.brand2]), borderRadius: BorderRadius.circular(16)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.name, style: h(19, color: Colors.white)),
            const SizedBox(height: 6),
            Text(careers, style: const TextStyle(color: Color(0xFFB8C7F5))),
          ]),
        ),
        const SizedBox(height: 12),
        StatsRow([('${all.length}', 'materiales'), ('$dl', 'descargas'), ('$pct%', 'útil')]),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final t in ['', ...kTypes])
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(label: Text(t.isEmpty ? 'Todos' : kTypePlural[t]!), selected: type == t, onSelected: (_) => setState(() => type = t)),
              ),
          ]),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          EmptyState(
            icon: Icons.description_outlined,
            title: 'Todavía no hay ${type.isEmpty ? 'material' : kTypePlural[type]!.toLowerCase()}',
            text: 'Nadie subió ese tipo de material para esta materia.',
            actions: [FilledButton(onPressed: () => push(context, const UploadScreen()), child: const Text('Subir material'))],
          )
        else
          ApunteList(list),
      ]),
    );
  }
}

/* ============================== documento ============================== */

class DocScreen extends StatefulWidget {
  const DocScreen(this.id, {super.key});
  final String id;

  @override
  State<DocScreen> createState() => _DocScreenState();
}

class _DocScreenState extends State<DocScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => RepoScope.read(context).touchRecent(widget.id));
  }

  Future<void> _run(Future<void> Function() fn) async {
    try {
      await fn();
    } catch (e) {
      if (mounted) toast(context, e is String ? e : authError(e));
    }
  }

  void _saveSheet(Apunte a) {
    final s = RepoScope.read(context);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final cur = s.perfil?.saved[a.id];
        return SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Guardar en colección', style: h(17)),
            const SizedBox(height: 8),
            for (final c in s.perfil!.collections)
              ListTile(
                leading: const Icon(Icons.folder_outlined, color: RC.amber),
                title: Text(c['name']!),
                trailing: cur == c['id'] ? const Icon(Icons.check, color: RC.action) : null,
                onTap: () {
                  s.saveTo(a.id, c['id']);
                  Navigator.pop(ctx);
                  toast(context, 'Guardado en ${c['name']}');
                },
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Nueva colección'),
              onTap: () async {
                Navigator.pop(ctx);
                final name = await askText(context, 'Nueva colección', 'Ej: Parcial de Costos');
                if (name != null && name.trim().isNotEmpty) {
                  final id = await s.newCollection(name);
                  await s.saveTo(a.id, id);
                  if (mounted) toast(context, 'Guardado en $name');
                }
              },
            ),
            if (cur != null)
              ListTile(
                leading: const Icon(Icons.bookmark_remove_outlined, color: RC.bad),
                title: const Text('Quitar de guardados', style: TextStyle(color: RC.bad)),
                onTap: () {
                  s.saveTo(a.id, null);
                  Navigator.pop(ctx);
                },
              ),
            const SizedBox(height: 8),
          ]),
        );
      },
    );
  }

  void _report(Apunte a) {
    final s = RepoScope.read(context);
    const reasons = ['Contenido incorrecto', 'Archivo dañado o ilegible', 'No tiene permiso para compartirse', 'Otro motivo'];
    String reason = reasons.first;
    final detail = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, set) => Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('Reportar material', style: h(17)),
            const SizedBox(height: 8),
            for (final r in reasons)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(r == reason ? Icons.radio_button_checked : Icons.radio_button_off, color: RC.action),
                title: Text(r),
                onTap: () => set(() => reason = r),
              ),
            TextField(controller: detail, maxLines: 3, decoration: const InputDecoration(labelText: 'Detalle (opcional)')),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await _run(() => s.report(a, reason, detail.text));
                if (mounted) toast(context, 'Gracias. Vamos a revisar el material.');
              },
              child: const Text('Enviar reporte'),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final a = s.byId(widget.id);
    if (a == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(icon: Icons.search_off, title: 'No encontramos este material', text: 'Puede que lo hayan eliminado.'),
      );
    }
    final saved = s.perfil!.saved.containsKey(a.id);
    final v = s.perfil!.votes[a.id] ?? 0;
    final color = kTypeColor[a.type] ?? RC.action;
    final related = s.apuntes.where((x) => x.subject == a.subject && x.id != a.id).take(3).toList();
    final lv = levelOf(s.ptsOf(a.ownerId));

    return Scaffold(
      appBar: AppBar(title: Text(a.type), actions: [
        IconButton(
          tooltip: saved ? 'Cambiar colección' : 'Guardar en colección',
          icon: Icon(saved ? Icons.bookmark : Icons.bookmark_outline, color: saved ? RC.amber : null),
          onPressed: () => _saveSheet(a),
        ),
      ]),
      body: ListView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 24), children: [
        Box(
          leftColor: color,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 6, children: [Pill('${a.type} en ${a.format}', color: color), Pill('${a.year}° año', amber: true)]),
            const SizedBox(height: 8),
            Text(a.title, style: h(20, w: FontWeight.w700)),
            const SizedBox(height: 4),
            InkWell(
              onTap: () => push(context, SubjectScreen(a.subject)),
              child: Text(a.subject, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            ),
            Text('${a.sede}, ${a.career}', style: TextStyle(color: mutedC(context))),
          ]),
        ),
        const SizedBox(height: 12),
        StatsRow([('${a.pct}%', 'útil'), ('${a.dl}', 'descargas'), ('${a.pages}', 'páginas'), (fdate(a.date).substring(0, 5), '${a.date.year}')]),
        const SizedBox(height: 12),
        Box(
          child: Row(children: [
            Avatar(a.uploader),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.uploader, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('Subió este material el ${fdate(a.date)}', style: TextStyle(color: mutedC(context), fontSize: 12.5)),
              ]),
            ),
            Pill(lv.name, amber: true),
          ]),
        ),
        const SizedBox(height: 16),
        Text('Descripción', style: h(15)),
        const SizedBox(height: 6),
        Text(a.desc, style: TextStyle(color: mutedC(context), height: 1.5)),
        if (a.tags.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(spacing: 6, runSpacing: 6, children: [for (final t in a.tags) Pill(t)]),
        ],
        if (a.isImage && a.hasFile) ...[
          const SizedBox(height: 16),
          Text('Vista previa', style: h(15)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(height: 220, width: double.infinity, child: FileImageView(a, fit: BoxFit.cover)),
          ),
        ],
        const SizedBox(height: 16),
        Box(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const Text('¿Te sirvió este material?', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: v == 1
                    ? FilledButton.icon(onPressed: () => _run(() => s.vote(a, 1)), icon: const Icon(Icons.thumb_up_alt), label: Text('Útil (${a.up})'))
                    : OutlinedButton.icon(onPressed: () => _run(() => s.vote(a, 1)), icon: const Icon(Icons.thumb_up_alt_outlined), label: Text('Útil (${a.up})')),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: v == -1
                    ? FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: RC.bad),
                        onPressed: () => _run(() => s.vote(a, -1)),
                        icon: const Icon(Icons.thumb_down_alt),
                        label: Text('No útil (${a.down})'))
                    : OutlinedButton.icon(onPressed: () => _run(() => s.vote(a, -1)), icon: const Icon(Icons.thumb_down_alt_outlined), label: Text('No útil (${a.down})')),
              ),
            ]),
            const SizedBox(height: 8),
            Text('Podés cambiar tu voto cuando quieras. Cuenta uno solo por persona.', style: TextStyle(color: mutedC(context), fontSize: 12.5)),
          ]),
        ),
        const SizedBox(height: 12),
        Box(
          padding: EdgeInsets.zero,
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: RC.action),
              title: const Text('Comentarios', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${a.nc} comentario${a.nc == 1 ? '' : 's'}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, CommentsScreen(a.id)),
            ),
            Divider(height: 1, color: lineC(context)),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: RC.bad),
              title: const Text('Reportar material', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Contenido incorrecto, dañado o sin permiso'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _report(a),
            ),
          ]),
        ),
        if (related.isNotEmpty) ...[
          const Section('Más de esta materia'),
          ApunteList(related),
        ],
      ]),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(color: surface(context), border: Border(top: BorderSide(color: lineC(context)))),
          child: Row(children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => push(context, ViewerScreen(a.id)),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Ver documento'),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () => _run(() async {
                if (await s.download(a) && context.mounted) toast(context, 'Archivo descargado');
              }),
              icon: const Icon(Icons.download_outlined),
              label: const Text('Descargar'),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Muestra una imagen guardada en pedazos dentro de Firestore.
class FileImageView extends StatefulWidget {
  const FileImageView(this.a, {super.key, this.fit = BoxFit.contain});
  final Apunte a;
  final BoxFit fit;

  @override
  State<FileImageView> createState() => _FileImageViewState();
}

class _FileImageViewState extends State<FileImageView> {
  late final Future<Uint8List> _f = RepoScope.read(context).fileBytes(widget.a);

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
        future: _f,
        builder: (context, snap) {
          if (snap.hasData) return Image.memory(snap.data!, fit: widget.fit);
          if (snap.hasError) {
            return Center(child: Text('No se pudo cargar la imagen', style: TextStyle(color: mutedC(context))));
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
}

class ViewerScreen extends StatelessWidget {
  const ViewerScreen(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final a = s.byId(id);
    if (a == null) return const Scaffold(body: Center(child: Text('Material no encontrado')));
    Future<void> dl() async {
      try {
        if (await s.download(a) && context.mounted) toast(context, 'Archivo descargado');
      } catch (e) {
        if (context.mounted) toast(context, e is String ? e : authError(e));
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(a.title, overflow: TextOverflow.ellipsis)),
      body: a.isImage && a.hasFile
          ? InteractiveViewer(maxScale: 5, child: Center(child: FileImageView(a)))
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.description_outlined, size: 72, color: kTypeColor[a.type]),
                  const SizedBox(height: 14),
                  Text(a.fileName ?? a.title, style: h(17), textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Text('${a.format} · ${a.pages} página${a.pages == 1 ? '' : 's'} aprox.', style: TextStyle(color: mutedC(context))),
                  const SizedBox(height: 18),
                  Text('Descargalo y se abre con el visor de tu celular o de tu compu.',
                      textAlign: TextAlign.center, style: TextStyle(color: mutedC(context))),
                  const SizedBox(height: 18),
                  FilledButton.icon(onPressed: dl, icon: const Icon(Icons.download_outlined), label: const Text('Descargar archivo')),
                ]),
              ),
            ),
    );
  }
}

class CommentsScreen extends StatefulWidget {
  const CommentsScreen(this.id, {super.key});
  final String id;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final tc = TextEditingController();
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final a = s.byId(widget.id);
    if (a == null) return const Scaffold(body: Center(child: Text('Material no encontrado')));
    return Scaffold(
      appBar: AppBar(title: const Text('Comentarios')),
      body: StreamBuilder<List<Comentario>>(
        stream: s.comments(a.id),
        builder: (context, snap) {
          final l = snap.data ?? const [];
          return ListView(padding: const EdgeInsets.all(16), children: [
            Text(a.title, style: TextStyle(color: mutedC(context))),
            const SizedBox(height: 12),
            if (snap.connectionState == ConnectionState.waiting && l.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (l.isEmpty)
              const EmptyState(
                icon: Icons.chat_bubble_outline,
                title: 'Todavía no hay comentarios',
                text: 'Preguntá o aclará algo sobre este material. Ayuda a quien lo use después.',
              )
            else
              for (final c in l)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Box(
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Avatar(c.who, size: 36),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Expanded(child: Text(c.who, style: const TextStyle(fontWeight: FontWeight.w700))),
                            Text(fdate(c.date), style: TextStyle(color: mutedC(context), fontSize: 12)),
                          ]),
                          const SizedBox(height: 4),
                          Text(c.t),
                        ]),
                      ),
                    ]),
                  ),
                ),
          ]);
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + MediaQuery.of(context).viewInsets.bottom),
          child: Row(children: [
            Expanded(
              child: TextField(controller: tc, maxLength: 280, decoration: const InputDecoration(hintText: 'Escribí un comentario', counterText: '')),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: busy
                  ? null
                  : () async {
                      if (tc.text.trim().isEmpty) return;
                      setState(() => busy = true);
                      try {
                        await s.addComment(a, tc.text);
                        tc.clear();
                      } catch (e) {
                        if (context.mounted) toast(context, authError(e));
                      }
                      if (mounted) setState(() => busy = false);
                    },
              child: const Text('Enviar'),
            ),
          ]),
        ),
      ),
    );
  }
}

Future<String?> askText(BuildContext context, String title, String hint) {
  final c = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(controller: c, autofocus: true, decoration: InputDecoration(hintText: hint)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Crear')),
      ],
    ),
  );
}

Future<bool> confirm(BuildContext context, String title, String text, String ok, {bool danger = false}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
        FilledButton(
          style: danger ? FilledButton.styleFrom(backgroundColor: RC.bad) : null,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(ok),
        ),
      ],
    ),
  );
  return r ?? false;
}

/* ============================== subir ============================== */

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  int step = 1;
  PlatformFile? file;
  final title = TextEditingController(), subject = TextEditingController(), desc = TextEditingController(), tags = TextEditingController();
  String? sede, career, type, err;
  int? year;
  bool confirmOk = false, busy = false;
  String? doneId;

  @override
  void initState() {
    super.initState();
    final p = RepoScope.read(context).perfil;
    sede = p?.sede;
    career = p?.career;
    year = p?.year;
  }

  String _size(int b) => b > 1024 * 1024 ? '${(b / 1024 / 1024).toStringAsFixed(1)} MB' : '${(b / 1024).round()} KB';

  Future<void> _pick() async {
    final r = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: kExtFormat.keys.toList(),
      withData: true,
    );
    if (r == null || r.files.isEmpty) return;
    final f = r.files.single;
    if (f.size > kMaxBytes) return setState(() => err = 'El archivo pesa más de 20 MB.');
    setState(() {
      file = f;
      err = null;
      if (title.text.isEmpty) title.text = f.name.replaceAll(RegExp(r'\.[^.]+$'), '').replaceAll(RegExp(r'[_-]+'), ' ');
    });
  }

  void _next() {
    String? e;
    if (step == 1 && file == null) e = 'Elegí un archivo para continuar.';
    if (step == 2) {
      if (title.text.trim().length < 5) {
        e = 'El título tiene que tener al menos 5 letras.';
      } else if (sede == null || career == null || year == null || type == null) {
        e = 'Completá sede, carrera, año y tipo.';
      } else if (subject.text.trim().length < 2) {
        e = 'Escribí la materia.';
      }
    }
    if (e != null) return setState(() => err = e);
    setState(() {
      err = null;
      step++;
    });
  }

  Future<void> _publish() async {
    if (!confirmOk) return setState(() => err = 'Tenés que confirmar que podés compartir el material.');
    setState(() {
      busy = true;
      err = null;
    });
    try {
      final id = await RepoScope.read(context).publish(
        bytes: file!.bytes!,
        fileName: file!.name,
        title: title.text,
        sede: sede!,
        career: career!,
        year: year!,
        type: type!,
        subject: subject.text,
        desc: desc.text,
        tags: tags.text.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList(),
      );
      setState(() => doneId = id);
    } catch (e) {
      setState(() => err = e is String ? e : authError(e));
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    if (doneId != null) {
      return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          EmptyState(
            icon: Icons.check_circle_outline,
            title: '¡Material publicado!',
            text: 'Ya está disponible para todos. Compartilo con tus compañeros para que lo usen.',
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DocScreen(doneId!))),
                child: const Text('Ver mi aporte'),
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const UploadScreen())),
                child: const Text('Subir otro material'),
              ),
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Volver al inicio')),
            ],
          ),
        ]),
      );
    }
    final subjects = s.apuntes.map((a) => a.subject).toSet().toList();
    final ext = file?.name.split('.').last.toUpperCase() ?? 'PDF';
    return PopScope(
      canPop: step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => step--);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Subir material')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          Text('Paso $step de 3', style: TextStyle(color: mutedC(context))),
          const SizedBox(height: 6),
          Row(children: [
            for (var k = 1; k <= 3; k++) ...[
              Expanded(child: Container(height: 5, decoration: BoxDecoration(color: k <= step ? RC.action : lineC(context), borderRadius: BorderRadius.circular(3)))),
              if (k < 3) const SizedBox(width: 6),
            ]
          ]),
          const SizedBox(height: 16),
          if (step == 1) ...[
            InkWell(
              onTap: _pick,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 16),
                decoration: BoxDecoration(
                  color: surface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: RC.action.withValues(alpha: .5), width: 1.5),
                ),
                child: Column(children: [
                  const Icon(Icons.upload_outlined, size: 36, color: RC.action),
                  const SizedBox(height: 8),
                  const Text('Elegí un archivo', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('PDF, Word, PowerPoint o imagen. Hasta 20 MB.', style: TextStyle(color: mutedC(context))),
                ]),
              ),
            ),
            if (file != null) ...[
              const SizedBox(height: 12),
              Box(
                child: Row(children: [
                  const Icon(Icons.description_outlined, color: RC.action),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(file!.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('$ext, ${_size(file!.size)}', style: TextStyle(color: mutedC(context))),
                    ]),
                  ),
                  IconButton(onPressed: () => setState(() => file = null), icon: const Icon(Icons.close)),
                ]),
              ),
            ],
          ],
          if (step == 2) ...[
            TextField(controller: title, maxLength: 90, decoration: const InputDecoration(labelText: 'Título', hintText: 'Ej: Resumen parcial 2, unidades 3 y 4')),
            const SizedBox(height: 6),
            dropdown<String>(
              label: 'Sede',
              value: sede,
              items: kSedes,
              text: (x) => x,
              onChanged: (v) => setState(() {
                sede = v;
                career = null;
              }),
            ),
            const SizedBox(height: 12),
            dropdown<String>(
              label: 'Carrera',
              value: career,
              items: sede == null ? const [] : kAcad[sede]!,
              text: (x) => x,
              onChanged: (v) => setState(() => career = v),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: dropdown<int>(label: 'Año', value: year, items: const [1, 2, 3, 4, 5], text: (y) => '$y°', onChanged: (v) => setState(() => year = v))),
              const SizedBox(width: 10),
              Expanded(child: dropdown<String>(label: 'Tipo', value: type, items: kTypes, text: (x) => x, onChanged: (v) => setState(() => type = v))),
            ]),
            const SizedBox(height: 12),
            Autocomplete<String>(
              initialValue: TextEditingValue(text: subject.text),
              optionsBuilder: (v) => v.text.isEmpty ? const [] : subjects.where((x) => norm(x).contains(norm(v.text))),
              onSelected: (v) => subject.text = v,
              fieldViewBuilder: (ctx, c, fn, onSub) => TextField(
                controller: c,
                focusNode: fn,
                onChanged: (v) => subject.text = v,
                decoration: const InputDecoration(labelText: 'Materia', hintText: 'Ej: Desarrollo de Aplicaciones Web'),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: desc,
              maxLength: 300,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descripción (opcional)', hintText: 'Qué unidades incluye, de qué año es, si está resuelto'),
            ),
            const SizedBox(height: 6),
            TextField(controller: tags, decoration: const InputDecoration(labelText: 'Etiquetas (opcional)', hintText: 'Separadas por coma: sql, joins, parcial')),
          ],
          if (step == 3) ...[
            Box(
              leftColor: kTypeColor[type] ?? RC.action,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Pill('${type ?? 'Material'} en $ext', color: kTypeColor[type]),
                const SizedBox(height: 6),
                Text(title.text, style: h(17)),
                Text(subject.text, style: TextStyle(color: kTypeColor[type] ?? RC.action, fontWeight: FontWeight.w600)),
                Text('$sede, $career, $year° año', style: TextStyle(color: mutedC(context))),
                if (desc.text.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text(desc.text, style: TextStyle(color: mutedC(context)))),
                const SizedBox(height: 6),
                Text('Archivo: ${file?.name}', style: TextStyle(color: mutedC(context))),
              ]),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              value: confirmOk,
              onChanged: (v) => setState(() => confirmOk = v ?? false),
              title: const Text('Confirmo que el material es mío o que tengo permiso para compartirlo.'),
            ),
          ],
          if (err != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(err!, style: const TextStyle(color: RC.bad))),
          const SizedBox(height: 16),
          if (step < 3)
            FilledButton(onPressed: _next, child: Text(step == 1 ? 'Continuar' : 'Revisar publicación'))
          else ...[
            FilledButton(
              onPressed: busy ? null : _publish,
              child: busy
                  ? const Row(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white)),
                      SizedBox(width: 10),
                      Text('Subiendo…'),
                    ])
                  : const Text('Publicar material'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(onPressed: busy ? null : () => setState(() => step = 2), child: const Text('Volver a editar')),
          ],
        ]),
      ),
    );
  }
}

/* ============================== guardados ============================== */

class SavedTab extends StatelessWidget {
  const SavedTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final p = s.perfil!;
    final list = s.apuntes.where((a) => p.saved.containsKey(a.id)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Guardados'), automaticallyImplyLeading: false, actions: [
        IconButton(
          tooltip: 'Nueva colección',
          icon: const Icon(Icons.add),
          onPressed: () async {
            final n = await askText(context, 'Nueva colección', 'Ej: Finales');
            if (n != null && n.trim().isNotEmpty) await s.newCollection(n);
          },
        ),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (list.isEmpty && p.collections.length == 1)
          EmptyState(
            icon: Icons.bookmark_outline,
            title: 'Todavía no guardaste nada',
            text: 'Tocá el marcador en cualquier apunte para encontrarlo después.',
            actions: [FilledButton(onPressed: () => HomeShellScope.goExplore(context), child: const Text('Explorar apuntes'))],
          )
        else ...[
          Text('Colecciones', style: h(16)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: [
              for (final c in p.collections)
                Box(
                  onTap: () => push(context, CollectionScreen(c['id']!)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.folder_outlined, color: RC.amber, size: 26),
                    const Spacer(),
                    Text(c['name']!, style: const TextStyle(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                    Builder(builder: (_) {
                      final n = list.where((a) => p.saved[a.id] == c['id']).length;
                      return Text('$n guardado${n == 1 ? '' : 's'}', style: TextStyle(color: mutedC(context), fontSize: 12.5));
                    }),
                  ]),
                ),
            ],
          ),
          Section('Todos los guardados (${list.length})'),
          ApunteList(list),
        ],
      ]),
    );
  }
}

/// Permite que pantallas internas cambien de pestaña sin pasar el estado a mano.
class HomeShellScope {
  static void goExplore(BuildContext context) => context.findAncestorStateOfType<HomeShellState>()?.goExplore(reset: true);
}

class CollectionScreen extends StatelessWidget {
  const CollectionScreen(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final p = s.perfil!;
    final c = p.collections.where((x) => x['id'] == id).firstOrNull;
    if (c == null) return const Scaffold(body: Center(child: Text('Colección no encontrada')));
    final list = s.apuntes.where((a) => p.saved[a.id] == id).toList();
    return Scaffold(
      appBar: AppBar(title: Text(c['name']!), actions: [
        if (id != 'gen')
          IconButton(
            tooltip: 'Eliminar colección',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              if (await confirm(context, 'Eliminar colección', 'Los apuntes guardados pasan a "General".', 'Eliminar', danger: true)) {
                await s.deleteCollection(id);
                if (context.mounted) Navigator.pop(context);
              }
            },
          ),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (list.isEmpty)
          const EmptyState(icon: Icons.folder_outlined, title: 'Esta colección está vacía', text: 'Guardá apuntes desde el detalle y elegí esta colección.')
        else
          ApunteList(list),
      ]),
    );
  }
}

/* ============================== perfil ============================== */

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final u = s.perfil!;
    final mine = s.mine;
    final pts = s.myPts;
    final lv = levelOf(pts);
    final nx = kLevels.where((l) => l.min > pts).firstOrNull;
    final prog = nx == null ? 1.0 : (pts - lv.min) / (nx.min - lv.min);

    Widget row(IconData ic, String t, String sub, Widget page, {Widget? extra}) => ListTile(
          leading: Icon(ic, color: RC.action),
          title: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(sub),
          trailing: Row(mainAxisSize: MainAxisSize.min, children: [if (extra != null) extra, const Icon(Icons.chevron_right)]),
          onTap: () => push(context, page),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil'), automaticallyImplyLeading: false, actions: [
        IconButton(tooltip: 'Editar perfil', icon: const Icon(Icons.edit_outlined), onPressed: () => push(context, const EditProfileScreen())),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Box(
          child: Column(children: [
            Avatar(u.name, size: 72),
            const SizedBox(height: 10),
            Text(u.name, style: h(19)),
            Text(u.email, style: TextStyle(color: mutedC(context))),
            const SizedBox(height: 4),
            Text('${u.career}, ${shortSede(u.sede)}, ${u.year}° año', textAlign: TextAlign.center, style: TextStyle(color: mutedC(context))),
          ]),
        ),
        const SizedBox(height: 12),
        StatsRow([
          ('${mine.length}', 'aportes'),
          ('${mine.fold<int>(0, (x, a) => x + a.up)}', 'votos útiles'),
          ('${mine.fold<int>(0, (x, a) => x + a.dl)}', 'descargas'),
        ]),
        const SizedBox(height: 12),
        Box(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text('Nivel ${lv.name}', style: const TextStyle(fontWeight: FontWeight.w700))), Pill('$pts pts', amber: true)]),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(value: prog, minHeight: 8, color: RC.amber, backgroundColor: lineC(context)),
            ),
            const SizedBox(height: 8),
            Text(
              nx == null
                  ? 'Llegaste al nivel más alto.'
                  : 'Te faltan ${nx.min - pts} puntos para ser ${nx.name}. Cada aporte suma 10 y cada voto útil suma 1.',
              style: TextStyle(color: mutedC(context), fontSize: 13),
            ),
          ]),
        ),
        const SizedBox(height: 12),
        Box(
          padding: EdgeInsets.zero,
          child: Column(children: [
            row(Icons.upload_outlined, 'Mis aportes', '${mine.length} publicado${mine.length == 1 ? '' : 's'}', const MineScreen()),
            row(Icons.download_outlined, 'Descargas', '${u.downloads.length} en tu historial', const DownloadsScreen()),
            row(Icons.emoji_events_outlined, 'Ranking', 'Quiénes más aportan', const RankingScreen()),
            row(Icons.notifications_none, 'Notificaciones', 'Novedades de tus aportes', const NotifsScreen(),
                extra: s.unread > 0 ? Pill('${s.unread}', amber: true) : null),
            row(Icons.tune, 'Ajustes', 'Tema y cuenta', const SettingsScreen()),
            row(Icons.help_outline, 'Ayuda', 'Preguntas frecuentes', const HelpScreen()),
          ]),
        ),
      ]),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final p = RepoScope.read(context).perfil!;
  late final name = TextEditingController(text: p.name);
  late String? sede = p.sede, career = p.career;
  late int? year = p.year;
  String? err;
  bool busy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar perfil')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Center(child: Avatar(name.text, size: 72)),
        const SizedBox(height: 18),
        TextField(controller: name, onChanged: (_) => setState(() {}), decoration: const InputDecoration(labelText: 'Nombre y apellido')),
        const SizedBox(height: 14),
        TextField(
          controller: TextEditingController(text: p.email),
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Correo', helperText: 'El correo no se puede cambiar.'),
        ),
        const SizedBox(height: 14),
        dropdown<String>(
          label: 'Sede',
          value: sede,
          items: kSedes,
          text: (x) => x,
          onChanged: (v) => setState(() {
            sede = v;
            career = null;
          }),
        ),
        const SizedBox(height: 14),
        dropdown<String>(
          label: 'Carrera',
          value: career,
          items: sede == null ? const [] : kAcad[sede]!,
          text: (x) => x,
          hint: 'Elegí tu carrera',
          onChanged: (v) => setState(() => career = v),
        ),
        const SizedBox(height: 14),
        dropdown<int>(label: 'Año de cursada', value: year, items: const [1, 2, 3, 4, 5], text: (y) => '$y° año', onChanged: (v) => setState(() => year = v)),
        if (err != null) Padding(padding: const EdgeInsets.only(top: 10), child: Text(err!, style: const TextStyle(color: RC.bad))),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: busy
              ? null
              : () async {
                  if (name.text.trim().length < 2 || sede == null || career == null || year == null) {
                    return setState(() => err = 'Completá tu nombre, sede, carrera y año.');
                  }
                  setState(() => busy = true);
                  try {
                    await RepoScope.read(context).updateProfile(name: name.text, sede: sede!, career: career!, year: year!);
                    if (context.mounted) {
                      toast(context, 'Perfil actualizado');
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    setState(() => err = authError(e));
                  }
                  if (mounted) setState(() => busy = false);
                },
          child: const Text('Guardar cambios'),
        ),
        const SizedBox(height: 10),
        OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
      ]),
    );
  }
}

class MineScreen extends StatelessWidget {
  const MineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final mine = s.mine;
    return Scaffold(
      appBar: AppBar(title: const Text('Mis aportes'), actions: [
        IconButton(tooltip: 'Subir material', icon: const Icon(Icons.add), onPressed: () => push(context, const UploadScreen())),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (mine.isEmpty)
          EmptyState(
            icon: Icons.upload_outlined,
            title: 'Todavía no subiste nada',
            text: 'Tus resúmenes y guías pueden salvarle un parcial a alguien.',
            actions: [FilledButton(onPressed: () => push(context, const UploadScreen()), child: const Text('Subir mi primer material'))],
          )
        else ...[
          StatsRow([
            ('${mine.length}', 'aportes'),
            ('${mine.fold<int>(0, (x, a) => x + a.up)}', 'útiles'),
            ('${mine.fold<int>(0, (x, a) => x + a.dl)}', 'descargas'),
          ]),
          const SizedBox(height: 14),
          for (final a in mine) ...[
            ApunteCard(a),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: RC.bad),
                onPressed: () async {
                  if (await confirm(context, 'Eliminar aporte', 'Se borra "${a.title}" y su archivo. No se puede deshacer.', 'Eliminar', danger: true)) {
                    try {
                      await s.deleteMine(a);
                    } catch (e) {
                      if (context.mounted) toast(context, authError(e));
                    }
                  }
                },
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Eliminar'),
              ),
            ),
          ],
        ],
      ]),
    );
  }
}

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final l = s.perfil!.downloads.map((x) => (x, s.byId(x['id']!))).where((o) => o.$2 != null).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Descargas'), actions: [
        if (l.isNotEmpty) TextButton(onPressed: s.clearDownloads, child: const Text('Borrar')),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (l.isEmpty)
          EmptyState(
            icon: Icons.download_outlined,
            title: 'Sin descargas',
            text: 'Los materiales que descargues aparecen acá.',
            actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Volver'))],
          )
        else
          Box(
            padding: EdgeInsets.zero,
            child: Column(children: [
              for (final o in l)
                ListTile(
                  leading: Icon(Icons.description_outlined, color: kTypeColor[o.$2!.type]),
                  title: Text(o.$2!.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${o.$2!.type} en ${o.$2!.format}, descargado el ${o.$1['d']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => push(context, DocScreen(o.$2!.id)),
                ),
            ]),
          ),
      ]),
    );
  }
}

class NotifsScreen extends StatelessWidget {
  const NotifsScreen({super.key});

  static const icons = {
    'star': Icons.star_outline_rounded,
    'comment': Icons.chat_bubble_outline,
    'download': Icons.download_outlined,
  };

  void _open(BuildContext context, Aviso n) {
    final s = RepoScope.read(context);
    s.markRead(n.id);
    final parts = n.ref.split('/');
    if (parts.length == 2 && parts[0] == 'doc') push(context, DocScreen(parts[1]));
    if (parts.length == 2 && parts[0] == 'comments') push(context, CommentsScreen(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones'), actions: [
        if (s.unread > 0) TextButton(onPressed: () => s.markRead(null), child: const Text('Marcar leídas')),
      ]),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (s.avisos.isEmpty)
          const EmptyState(icon: Icons.notifications_none, title: 'No hay novedades', text: 'Te avisamos cuando alguien vote o comente tus aportes.')
        else
          Box(
            padding: EdgeInsets.zero,
            child: Column(children: [
              for (final n in s.avisos)
                ListTile(
                  leading: Icon(icons[n.ic] ?? Icons.star_outline_rounded, color: RC.action),
                  title: Text(n.t, style: TextStyle(fontWeight: n.read ? FontWeight.w500 : FontWeight.w700)),
                  subtitle: Text(fdate(n.date)),
                  trailing: n.read ? null : const CircleAvatar(radius: 5, backgroundColor: RC.action),
                  onTap: () => _open(context, n),
                ),
            ]),
          ),
      ]),
    );
  }
}

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  bool mySede = false;

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    final l = s.ranking(sede: mySede ? s.perfil!.sede : null);
    final top = l.take(3).toList(), rest = l.skip(3).toList();

    Widget pod(RankRow r, int i) => Expanded(
          child: Box(
            padding: EdgeInsets.fromLTRB(8, 14, 8, i == 0 ? 22 : 14),
            child: Column(children: [
              Avatar(r.name, size: i == 0 ? 50 : 42),
              const SizedBox(height: 6),
              Text(first(r.name), style: const TextStyle(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
              Text('${r.pts} pts', style: TextStyle(color: mutedC(context), fontSize: 12.5)),
              const SizedBox(height: 6),
              Pill('Puesto ${i + 1}', amber: true),
            ]),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SegmentedButton<bool>(
          segments: const [ButtonSegment(value: false, label: Text('Todas las sedes')), ButtonSegment(value: true, label: Text('Mi sede'))],
          selected: {mySede},
          onSelectionChanged: (v) => setState(() => mySede = v.first),
        ),
        const SizedBox(height: 16),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          if (top.length > 1) pod(top[1], 1) else const Spacer(),
          const SizedBox(width: 8),
          if (top.isNotEmpty) pod(top[0], 0) else const Spacer(),
          const SizedBox(width: 8),
          if (top.length > 2) pod(top[2], 2) else const Spacer(),
        ]),
        if (rest.isNotEmpty) ...[
          const SizedBox(height: 12),
          Box(
            padding: EdgeInsets.zero,
            child: Column(children: [
              for (var i = 0; i < rest.length; i++)
                Container(
                  color: rest[i].uid == s.user?.uid ? RC.action.withValues(alpha: .08) : null,
                  child: ListTile(
                    leading: SizedBox(
                      width: 70,
                      child: Row(children: [
                        SizedBox(width: 24, child: Text('${i + 4}', style: const TextStyle(fontWeight: FontWeight.w700))),
                        Avatar(rest[i].name, size: 36),
                      ]),
                    ),
                    title: Text('${rest[i].name}${rest[i].uid == s.user?.uid ? ' (vos)' : ''}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${rest[i].posts} aportes'),
                    trailing: Pill('${rest[i].pts} pts', amber: true),
                  ),
                ),
            ]),
          ),
        ],
        const SizedBox(height: 14),
        Text('Cada aporte suma 10 puntos y cada voto útil suma 1.', textAlign: TextAlign.center, style: TextStyle(color: mutedC(context))),
      ]),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = RepoScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Apariencia', style: h(16)),
        const SizedBox(height: 10),
        SegmentedButton<ThemeMode>(
          segments: const [
            ButtonSegment(value: ThemeMode.system, label: Text('Automático')),
            ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
            ButtonSegment(value: ThemeMode.dark, label: Text('Oscuro')),
          ],
          selected: {s.themeMode},
          onSelectionChanged: (v) => s.setTheme(v.first),
        ),
        const SizedBox(height: 22),
        Text('Cuenta', style: h(16)),
        const SizedBox(height: 10),
        Box(
          padding: EdgeInsets.zero,
          child: Column(children: [
            ListTile(
              leading: const Icon(Icons.person_outline, color: RC.action),
              title: const Text('Editar perfil'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, const EditProfileScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: RC.action),
              title: const Text('Ayuda'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => push(context, const HelpScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: RC.bad),
              title: const Text('Cerrar sesión', style: TextStyle(color: RC.bad, fontWeight: FontWeight.w600)),
              onTap: () async {
                if (await confirm(context, 'Cerrar sesión', '¿Querés salir de tu cuenta?', 'Salir', danger: true)) {
                  await s.logout();
                  if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
                }
              },
            ),
          ]),
        ),
        const SizedBox(height: 18),
        Text('Repositorio UCA', textAlign: TextAlign.center, style: TextStyle(color: mutedC(context))),
      ]),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const q = [
    ('¿Quién puede subir material?', 'Cualquier estudiante con cuenta. Tenés que confirmar que el material es tuyo o que tenés permiso para compartirlo.'),
    ('¿Cómo sé si un apunte es confiable?', 'Fijate el porcentaje de votos útiles, la fecha y los comentarios. Si algo está mal, usá "Reportar material".'),
    ('¿Puedo cambiar mi voto?', 'Sí. Cada persona tiene un solo voto por material y lo puede cambiar o sacar cuando quiera.'),
    ('¿Qué formatos puedo subir?', 'PDF, Word, PowerPoint e imágenes JPG o PNG, de hasta 20 MB.'),
    ('¿Cómo funcionan los puntos?', 'Cada aporte suma 10 puntos y cada voto útil que recibís suma 1. Los puntos definen tu nivel.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        for (final e in q)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Box(
              padding: EdgeInsets.zero,
              child: ExpansionTile(
                shape: const Border(),
                title: Text(e.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                children: [Text(e.$2, style: TextStyle(color: mutedC(context), height: 1.45))],
              ),
            ),
          ),
        const SizedBox(height: 6),
        Box(
          child: Row(children: [
            const Icon(Icons.mail_outline, color: RC.action),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('¿Seguís con dudas?', style: TextStyle(fontWeight: FontWeight.w700)),
                Text('Escribinos y te respondemos.'),
              ]),
            ),
            OutlinedButton(onPressed: () => launchUrl(Uri.parse('mailto:repositorio@uca.edu.ar')), child: const Text('Escribir')),
          ]),
        ),
      ]),
    );
  }
}

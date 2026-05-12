Membuat fitur notifikasi di Flutter (terutama untuk Android versi terbaru) memang membutuhkan beberapa penyesuaian di sisi *native* Android-nya.

Berdasarkan langkah-langkah yang sudah kita lewati sebelumnya, berikut adalah tutorial lengkap dan berurutan dari awal hingga akhir menggunakan format Kotlin DSL (`build.gradle.kts`).

---

### Langkah 1: Tambahkan Package

Buka terminal di *root* (folder utama) proyek Flutter Anda, lalu jalankan perintah ini untuk menginstal *package* secara otomatis:

```bash
flutter pub add flutter_local_notifications

```

Atau, Anda bisa menambahkannya secara manual di file 📁 `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^17.0.0 # Gunakan versi terbaru

```

### Langkah 2: Beri Izin di Android Manifest

Mulai Android 13 (API Level 33), aplikasi wajib meminta izin untuk memunculkan notifikasi.

Buka file 📁 `android/app/src/main/AndroidManifest.xml`, lalu tambahkan dua baris `uses-permission` ini tepat **di atas** tag `<application>`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.VIBRATE" />

    <application
        android:label="nama_aplikasi"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        ```

### Langkah 3: Setup Core Library Desugaring (Wajib untuk Java 8+)
Karena *package* versi terbaru menggunakan fitur Java 8, kita harus mengaktifkan *desugaring*. Buka file konfigurasi Gradle level aplikasi Anda di 📁 `android/app/build.gradle.kts`.

**A. Aktifkan Fitur Desugaring**
Cari blok `android { ... }` lalu di dalamnya cari blok `compileOptions`. Tambahkan pengaturan desugaring dengan **huruf C kapital**:
```kotlin
android {
    // ... pengaturan lain ...

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        
        // Tambahkan baris ini secara hati-hati (perhatikan huruf besarnya):
        isCoreLibraryDesugaringEnabled = true 
    }
}

```

**B. Tambahkan Dependency Desugaring**
Scroll ke baris paling bawah pada file `build.gradle.kts` tersebut (di luar blok `android`). Jika belum ada blok `dependencies`, buat sendiri:

```kotlin
// Letakkan ini di baris paling bawah file
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

```

### Langkah 4: Tulis Kode Dart (`main.dart`)

Sekarang saatnya menghubungkan *package* dengan antarmuka Flutter. Buka 📁 `lib/main.dart` dan *copy-paste* kode yang sudah stabil ini:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: SimpleNotifScreen()));
}

class SimpleNotifScreen extends StatefulWidget {
  const SimpleNotifScreen({super.key});

  @override
  State<SimpleNotifScreen> createState() => _SimpleNotifScreenState();
}

class _SimpleNotifScreenState extends State<SimpleNotifScreen> {
  // 1. Buat instance dari plugin
  final FlutterLocalNotificationsPlugin notifPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _inisialisasiNotifikasi();
  }

  // 2. Fungsi untuk inisialisasi awal
  void _inisialisasiNotifikasi() async {
    // Meminta izin untuk Android 13+
    notifPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Setup icon bawaan aplikasi
    await notifPlugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
  }

  // 3. Fungsi untuk memicu notifikasi muncul
  void _tampilkanNotifikasi() async {
    const androidDetails = AndroidNotificationDetails(
      'channel_utama', // ID Channel (bebas)
      'Notifikasi Utama', // Nama Channel yang muncul di setting HP
      importance: Importance.max,
      priority: Priority.high,
    );

    await notifPlugin.show(
      id: 0, 
      title: 'Notifikasi Berhasil!', 
      body: 'Setup project dari awal sampai akhir sukses.', 
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial Notifikasi')),
      body: Center(
        child: ElevatedButton(
          onPressed: _tampilkanNotifikasi,
          child: const Text('Tampilkan Notifikasi'),
        ),
      ),
    );
  }
}

```

### Langkah 5: Clean & Run

Karena kita mengubah file *native* Android (`build.gradle.kts` dan `AndroidManifest.xml`), *hot reload* atau *hot restart* biasa tidak akan mempan.

Matikan dulu aplikasi jika sedang berjalan (Stop), lalu jalankan urutan perintah ini di terminal:

```bash
flutter clean
flutter pub get
flutter run

```

Selesai! Jika langkah ini diikuti secara berurutan, masalah dependensi maupun error inisialisasi seharusnya tidak akan muncul lagi.

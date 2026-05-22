
# SET UP NOTIFICATION ANDROID 

---

### Langkah 1: Tambahkan Package

Buka terminal di *root* (folder utama) proyek Flutter Anda, lalu jalankan perintah ini untuk menginstal *package* secara otomatis:

```bash
flutter pub add flutter_local_notifications

```

Atau, Anda bisa menambahkannya secara manual di file `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_local_notifications: ^17.0.0 # Gunakan versi terbaru

```

### Langkah 2: Beri Izin di Android Manifest

Mulai Android 13 (API Level 33), aplikasi wajib meminta izin untuk memunculkan notifikasi.

Buka file `android/app/src/main/AndroidManifest.xml`, lalu tambahkan dua baris `uses-permission` ini tepat **di atas** tag `<application>`:

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
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

```
Enable juga library desugaringnya


```kotlin
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        //tambahkan line ini
        isCoreLibraryDesugaringEnabled = true
    }

```

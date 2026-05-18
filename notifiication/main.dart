import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ScreenNotification(),
    );
  }
}

class ScreenNotification extends StatefulWidget {
  const ScreenNotification({super.key});

  @override
  State<ScreenNotification> createState() => _ScreenNotificationState();
}

class _ScreenNotificationState extends State<ScreenNotification> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    await flutterLocalNotificationsPlugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channel_utama',
          'Channel Name',
          channelDescription: "ini adalah kanal untuk aplikasi flutter",
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: "halo",
      body: 'ini adalah contoh notifikasi',
      notificationDetails: const NotificationDetails(
        android: androidNotificationDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contoh Notifikasi')),
      body: Center(
        child: ElevatedButton(
          onPressed: _showNotification,
          child: const Text('Tampilkan Notifikasi'),
        ),
      ),
    );
  }
}

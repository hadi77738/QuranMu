import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // Request notification permission for Android 13+
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _isInitialized = true;
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? soundName,
  }) async {
    await init();

    AndroidNotificationDetails androidNotificationDetails;
    if (soundName != null && soundName.isNotEmpty && soundName != 'default') {
      androidNotificationDetails = AndroidNotificationDetails(
        'quranmu_adzan_$soundName',
        'Pengingat Adzan (${soundName.replaceAll('_', ' ').toUpperCase()})',
        channelDescription: 'Notifikasi jadwal masuk waktu sholat dengan kumandang adzan',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundName),
      );
    } else {
      androidNotificationDetails = const AndroidNotificationDetails(
        'quranmu_prayer_channel',
        'Pengingat Waktu Sholat',
        channelDescription: 'Notifikasi jadwal masuk waktu sholat & adzan',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );
    }

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }
}

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'prayer_service.dart';
import 'settings_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _platformAvailable = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Inisialisasi basis data Timezone secara dinamis
      tz.initializeTimeZones();
      final offset = DateTime.now().timeZoneOffset;
      String tzName = 'Asia/Jakarta';
      if (offset.inHours == 8) {
        tzName = 'Asia/Makassar';
      } else if (offset.inHours == 9) {
        tzName = 'Asia/Jayapura';
      } else {
        for (final loc in tz.timeZoneDatabase.locations.values) {
          if (loc.currentTimeZone.offset == offset) {
            tzName = loc.name;
            break;
          }
        }
      }
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (e) {
      debugPrint('Error initializing timezone in NotificationService: $e');
    }

    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
      );

      // Daftarkan channel notifikasi secara eksplisit (Android 8.0+)
      if (!kIsWeb && Platform.isAndroid) {
        await _createNotificationChannels();
      }
      _platformAvailable = true;
    } catch (e) {
      _platformAvailable = false;
      debugPrint('Notification platform not initialized (testing/unsupported): $e');
    }

    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    try {
      final androidImpl = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl == null) return;

      // 1. Channel standar (suara bawaan sistem)
      const defaultChannel = AndroidNotificationChannel(
        'quranmu_prayer_channel_v2',
        'Pengingat Waktu Sholat',
        description: 'Notifikasi jadwal masuk waktu sholat & adzan',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await androidImpl.createNotificationChannel(defaultChannel);

      // 2. Channels untuk masing-masing varian suara adzan
      final adzanSounds = [
        {'id': 'adzan_makkah', 'name': 'Adzan Makkah'},
        {'id': 'adzan_madinah', 'name': 'Adzan Madinah'},
        {'id': 'adzan_mesir', 'name': 'Adzan Mesir'},
      ];

      for (final item in adzanSounds) {
        final soundId = item['id']!;
        final soundLabel = item['name']!;
        final channel = AndroidNotificationChannel(
          'quranmu_adzan_${soundId}_v2',
          'Pengingat Adzan ($soundLabel)',
          description: 'Notifikasi jadwal masuk waktu sholat dengan kumandang $soundLabel',
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(soundId),
          audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
          enableVibration: true,
        );
        await androidImpl.createNotificationChannel(channel);
      }
    } catch (e) {
      debugPrint('Error creating notification channels: $e');
    }
  }

  /// Meminta izin notifikasi (Android 13+) dan exact alarm (Android 12+)
  Future<bool> requestPermission() async {
    await init();
    if (!_platformAvailable) return true;

    try {
      final androidImpl = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        final notifGranted = await androidImpl.requestNotificationsPermission();
        await androidImpl.requestExactAlarmsPermission();
        return notifGranted ?? false;
      }
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
    }
    return true;
  }

  /// Menampilkan notifikasi instan (misal untuk tombol 'Tes Notifikasi')
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? soundName,
  }) async {
    await init();
    if (!_platformAvailable) return;

    AndroidNotificationDetails androidNotificationDetails;
    if (soundName != null && soundName.isNotEmpty && soundName != 'default') {
      androidNotificationDetails = AndroidNotificationDetails(
        'quranmu_adzan_${soundName}_v2',
        'Pengingat Adzan (${soundName.replaceAll('_', ' ').toUpperCase()})',
        channelDescription: 'Notifikasi jadwal masuk waktu sholat dengan kumandang adzan',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundName),
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
      );
    } else {
      androidNotificationDetails = const AndroidNotificationDetails(
        'quranmu_prayer_channel_v2',
        'Pengingat Waktu Sholat',
        channelDescription: 'Notifikasi jadwal masuk waktu sholat & adzan',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
      );
    }

    final NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  /// Membatalkan seluruh notifikasi sholat terjadwal
  Future<void> cancelAllPrayerNotifications() async {
    await init();
    if (!_platformAvailable) return;

    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (_) {
      for (int day = 0; day < 7; day++) {
        for (int p = 1; p <= 5; p++) {
          try {
            await flutterLocalNotificationsPlugin.cancel(id: (day * 100) + (p * 10));
          } catch (_) {}
        }
      }
    }
  }

  /// Menjadwalkan pengingat sholat untuk beberapa hari ke depan (offline & otomatis)
  Future<void> schedulePrayerNotifications({
    required PrayerService prayerService,
    required double latitude,
    required double longitude,
    required String locationName,
    required AppSettings settings,
    int daysToSchedule = 3,
  }) async {
    await init();
    if (!_platformAvailable) return;

    if (!settings.enableAdzanNotification) {
      await cancelAllPrayerNotifications();
      return;
    }

    final now = DateTime.now();

    for (int day = 0; day < daysToSchedule; day++) {
      final targetDate = now.add(Duration(days: day));
      final times = prayerService.getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        date: targetDate,
      );

      final prayers = [
        {'name': 'Subuh', 'time': times.subuh, 'enabled': settings.alertSubuh, 'index': 1},
        {'name': 'Dzuhur', 'time': times.dzuhur, 'enabled': settings.alertDzuhur, 'index': 2},
        {'name': 'Ashar', 'time': times.ashar, 'enabled': settings.alertAshar, 'index': 3},
        {'name': 'Maghrib', 'time': times.maghrib, 'enabled': settings.alertMaghrib, 'index': 4},
        {'name': 'Isya', 'time': times.isya, 'enabled': settings.alertIsya, 'index': 5},
      ];

      for (final prayer in prayers) {
        final prayerName = prayer['name'] as String;
        final prayerTime = prayer['time'] as DateTime;
        final enabled = prayer['enabled'] as bool;
        final pIndex = prayer['index'] as int;
        final notifId = (day * 100) + (pIndex * 10);

        if (!enabled || prayerTime.isBefore(now)) {
          // Batalkan id jika waktu sudah berlalu atau dinonaktifkan
          try {
            await flutterLocalNotificationsPlugin.cancel(id: notifId);
          } catch (_) {}
          continue;
        }

        final tzScheduled = tz.TZDateTime.from(prayerTime, tz.local);

        AndroidNotificationDetails androidNotificationDetails;
        if (settings.adzanSound.isNotEmpty && settings.adzanSound != 'default') {
          androidNotificationDetails = AndroidNotificationDetails(
            'quranmu_adzan_${settings.adzanSound}_v2',
            'Pengingat Adzan (${settings.adzanSound.replaceAll('_', ' ').toUpperCase()})',
            channelDescription: 'Notifikasi jadwal masuk waktu sholat dengan kumandang adzan',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound(settings.adzanSound),
            audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
          );
        } else {
          androidNotificationDetails = const AndroidNotificationDetails(
            'quranmu_prayer_channel_v2',
            'Pengingat Waktu Sholat',
            channelDescription: 'Notifikasi jadwal masuk waktu sholat & adzan',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            icon: '@mipmap/ic_launcher',
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
          );
        }

        final details = NotificationDetails(android: androidNotificationDetails);

        try {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id: notifId,
            title: 'Waktu Sholat $prayerName Telah Tiba',
            body: 'Wilayah $locationName (${times.formatTime(prayerTime)}). Mari tunaikan sholat $prayerName.',
            scheduledDate: tzScheduled,
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          );
        } catch (_) {
          try {
            await flutterLocalNotificationsPlugin.zonedSchedule(
              id: notifId,
              title: 'Waktu Sholat $prayerName Telah Tiba',
              body: 'Wilayah $locationName (${times.formatTime(prayerTime)}). Mari tunaikan sholat $prayerName.',
              scheduledDate: tzScheduled,
              notificationDetails: details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            );
          } catch (err) {
            debugPrint('Failed to schedule notification for $prayerName: $err');
          }
        }
      }
    }
  }

  /// Menjadwalkan alarm uji coba (misal 5 detik kemudian)
  Future<void> scheduleTestAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? soundFile,
  }) async {
    await init();
    if (!_platformAvailable) return;
    final tzScheduled = tz.TZDateTime.from(scheduledTime, tz.local);
    AndroidNotificationDetails androidNotificationDetails;
    if (soundFile != null && soundFile.isNotEmpty && soundFile != 'default') {
      androidNotificationDetails = AndroidNotificationDetails(
        'quranmu_adzan_${soundFile}_v2',
        'Pengingat Adzan (${soundFile.replaceAll('_', ' ').toUpperCase()})',
        channelDescription: 'Notifikasi jadwal masuk waktu sholat dengan kumandang adzan',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(soundFile),
        audioAttributesUsage: AudioAttributesUsage.notificationRingtone,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
      );
    } else {
      androidNotificationDetails = const AndroidNotificationDetails(
        'quranmu_prayer_channel_v2',
        'Pengingat Waktu Sholat',
        channelDescription: 'Notifikasi jadwal masuk waktu sholat & adzan',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
      );
    }
    final details = NotificationDetails(android: androidNotificationDetails);
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzScheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tzScheduled,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }
}

// Provider untuk sinkronisasi otomatis jadwal notifikasi sholat
final prayerNotificationSyncProvider = Provider<void>((ref) {
  final settings = ref.watch(settingsProvider);
  final location = ref.watch(userLocationProvider);
  final prayerService = ref.watch(prayerServiceProvider);

  NotificationService().schedulePrayerNotifications(
    prayerService: prayerService,
    latitude: location.latitude,
    longitude: location.longitude,
    locationName: location.locationName,
    settings: settings,
  );
});

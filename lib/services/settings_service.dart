import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

enum AppThemeMode {
  light,
  dark,
  system;

  String get label {
    switch (this) {
      case AppThemeMode.light:
        return 'Terang';
      case AppThemeMode.dark:
        return 'Gelap';
      case AppThemeMode.system:
        return 'Sistem';
    }
  }
}

class AppSettings {
  final double arabicFontSize;
  final double translationFontSize;
  final String qariId; // '01' .. '05'
  final String qariName;
  final bool enableAdzanNotification;
  final bool alertSubuh;
  final bool alertDzuhur;
  final bool alertAshar;
  final bool alertMaghrib;
  final bool alertIsya;
  final String adzanSound; // 'adzan_makkah', 'adzan_madinah', 'adzan_mesir', 'default'
  final String adzanSoundName;
  final bool showMushafLines;
  final AppThemeMode themeMode;

  const AppSettings({
    this.arabicFontSize = 24.0,
    this.translationFontSize = 14.0,
    this.qariId = '05',
    this.qariName = 'Misyari Rasyid Al-Afasy',
    this.enableAdzanNotification = true,
    this.alertSubuh = true,
    this.alertDzuhur = true,
    this.alertAshar = true,
    this.alertMaghrib = true,
    this.alertIsya = true,
    this.adzanSound = 'adzan_makkah',
    this.adzanSoundName = 'Adzan Makkah (Merdu & Syahdu)',
    this.showMushafLines = true,
    this.themeMode = AppThemeMode.light,
  });

  AppSettings copyWith({
    double? arabicFontSize,
    double? translationFontSize,
    String? qariId,
    String? qariName,
    bool? enableAdzanNotification,
    bool? alertSubuh,
    bool? alertDzuhur,
    bool? alertAshar,
    bool? alertMaghrib,
    bool? alertIsya,
    String? adzanSound,
    String? adzanSoundName,
    bool? showMushafLines,
    AppThemeMode? themeMode,
  }) {
    return AppSettings(
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      qariId: qariId ?? this.qariId,
      qariName: qariName ?? this.qariName,
      enableAdzanNotification: enableAdzanNotification ?? this.enableAdzanNotification,
      alertSubuh: alertSubuh ?? this.alertSubuh,
      alertDzuhur: alertDzuhur ?? this.alertDzuhur,
      alertAshar: alertAshar ?? this.alertAshar,
      alertMaghrib: alertMaghrib ?? this.alertMaghrib,
      alertIsya: alertIsya ?? this.alertIsya,
      adzanSound: adzanSound ?? this.adzanSound,
      adzanSoundName: adzanSoundName ?? this.adzanSoundName,
      showMushafLines: showMushafLines ?? this.showMushafLines,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class SettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    _loadSettings();
    return const AppSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('setting_theme_mode');
    final loadedTheme = themeStr == 'dark'
        ? AppThemeMode.dark
        : themeStr == 'system'
            ? AppThemeMode.system
            : AppThemeMode.light;

    state = AppSettings(
      arabicFontSize: prefs.getDouble('setting_arabic_font') ?? 24.0,
      translationFontSize: prefs.getDouble('setting_translation_font') ?? 14.0,
      qariId: prefs.getString('setting_qari_id') ?? '05',
      qariName: prefs.getString('setting_qari_name') ?? 'Misyari Rasyid Al-Afasy',
      enableAdzanNotification: prefs.getBool('setting_notif_adzan') ?? true,
      alertSubuh: prefs.getBool('setting_notif_subuh') ?? true,
      alertDzuhur: prefs.getBool('setting_notif_dzuhur') ?? true,
      alertAshar: prefs.getBool('setting_notif_ashar') ?? true,
      alertMaghrib: prefs.getBool('setting_notif_maghrib') ?? true,
      alertIsya: prefs.getBool('setting_notif_isya') ?? true,
      adzanSound: prefs.getString('setting_adzan_sound') ?? 'adzan_makkah',
      adzanSoundName: prefs.getString('setting_adzan_sound_name') ?? 'Adzan Makkah (Merdu & Syahdu)',
      showMushafLines: prefs.getBool('setting_show_mushaf_lines') ?? true,
      themeMode: loadedTheme,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setting_theme_mode', mode.name);
    state = state.copyWith(themeMode: mode);
    _notifyWidgetThemeChanged();
  }

  void _notifyWidgetThemeChanged() {
    try {
      const MethodChannel('com.quranmu.pacman/widget')
          .invokeMethod('updateWidgetTheme');
    } catch (_) {}
  }

  Future<void> setMushafLines(bool show) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setting_show_mushaf_lines', show);
    state = state.copyWith(showMushafLines: show);
  }

  Future<void> setAdzanSound(String sound, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setting_adzan_sound', sound);
    await prefs.setString('setting_adzan_sound_name', name);
    state = state.copyWith(adzanSound: sound, adzanSoundName: name);
  }

  Future<void> setArabicFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('setting_arabic_font', size);
    state = state.copyWith(arabicFontSize: size);
  }

  Future<void> setTranslationFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('setting_translation_font', size);
    state = state.copyWith(translationFontSize: size);
  }

  Future<void> setQari(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('setting_qari_id', id);
    await prefs.setString('setting_qari_name', name);
    state = state.copyWith(qariId: id, qariName: name);
  }

  Future<void> toggleAdzanNotification(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('setting_notif_adzan', enabled);
    state = state.copyWith(enableAdzanNotification: enabled);
  }

  Future<void> togglePrayerAlert(String prayerName, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    switch (prayerName) {
      case 'Subuh':
        await prefs.setBool('setting_notif_subuh', enabled);
        state = state.copyWith(alertSubuh: enabled);
        break;
      case 'Dzuhur':
        await prefs.setBool('setting_notif_dzuhur', enabled);
        state = state.copyWith(alertDzuhur: enabled);
        break;
      case 'Ashar':
        await prefs.setBool('setting_notif_ashar', enabled);
        state = state.copyWith(alertAshar: enabled);
        break;
      case 'Maghrib':
        await prefs.setBool('setting_notif_maghrib', enabled);
        state = state.copyWith(alertMaghrib: enabled);
        break;
      case 'Isya':
        await prefs.setBool('setting_notif_isya', enabled);
        state = state.copyWith(alertIsya: enabled);
        break;
    }
  }

  Future<void> scheduleTestAlarm({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? soundFile,
  }) async {
    await NotificationService().scheduleTestAlarm(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      soundFile: soundFile,
    );
  }
}

final settingsProvider =
    NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

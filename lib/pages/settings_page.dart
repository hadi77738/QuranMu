import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';
import '../theme/app_theme.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          children: [
            // SEKSI 1: TAMPILAN BACA AL-QUR'AN
            _buildSectionHeader(context, icon: Icons.menu_book_rounded, title: 'Tampilan Baca Al-Qur\'an'),
            const SizedBox(height: 10),
            _buildCard(
              children: [
                // Slider Ukuran Font Arab
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ukuran Font Arab',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        '${settings.arabicFontSize.toInt()} pt',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: settings.arabicFontSize,
                  min: 18.0,
                  max: 36.0,
                  divisions: 9,
                  activeColor: AppColors.primary,
                  onChanged: (val) => notifier.setArabicFontSize(val),
                ),
                // Live Preview Teks Arab
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorderLight),
                  ),
                  child: Center(
                    child: Text(
                      'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      style: TextStyle(
                        fontSize: settings.arabicFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1B2A26),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.cardBorderLight),

                // Slider Ukuran Font Terjemahan
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ukuran Font Terjemahan',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        '${settings.translationFontSize.toInt()} pt',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: settings.translationFontSize,
                  min: 12.0,
                  max: 20.0,
                  divisions: 8,
                  activeColor: AppColors.primary,
                  onChanged: (val) => notifier.setTranslationFontSize(val),
                ),
                // Live Preview Terjemahan
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorderLight),
                  ),
                  child: Text(
                    'Dengan nama Allah Yang Maha Pengasih, Maha Penyayang.',
                    style: TextStyle(
                      fontSize: settings.translationFontSize,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.cardBorderLight),

                // Pilihan Qari Murottal
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Qari Murottal Default',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F8F7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorderLight),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: settings.qariId,
                            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                            items: const [
                              DropdownMenuItem(
                                value: '05',
                                child: Text('Misyari Rasyid Al-Afasy'),
                              ),
                              DropdownMenuItem(
                                value: '01',
                                child: Text('Abdullah Al-Juhany'),
                              ),
                              DropdownMenuItem(
                                value: '02',
                                child: Text('Abdul Muhsin Al-Qasim'),
                              ),
                              DropdownMenuItem(
                                value: '03',
                                child: Text('Abdurrahman As-Sudais'),
                              ),
                              DropdownMenuItem(
                                value: '04',
                                child: Text('Ibrahim Al-Dossari'),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                String name = 'Misyari Rasyid Al-Afasy';
                                if (val == '01') name = 'Abdullah Al-Juhany';
                                if (val == '02') name = 'Abdul Muhsin Al-Qasim';
                                if (val == '03') name = 'Abdurrahman As-Sudais';
                                if (val == '04') name = 'Ibrahim Al-Dossari';
                                notifier.setQari(val, name);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // SEKSI 2: PENGINGAT WAKTU SHOLAT & ADZAN
            _buildSectionHeader(context, icon: Icons.notifications_active_rounded, title: 'Notifikasi Jadwal Sholat'),
            const SizedBox(height: 10),
            _buildCard(
              children: [
                SwitchListTile.adaptive(
                  title: const Text(
                    'Pengingat Waktu Sholat',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  subtitle: const Text('Bunyikan notifikasi saat waktu sholat tiba'),
                  value: settings.enableAdzanNotification,
                  activeTrackColor: AppColors.primary,
                  onChanged: (val) => notifier.toggleAdzanNotification(val),
                ),
                if (settings.enableAdzanNotification) ...[
                  const Divider(height: 1, color: AppColors.cardBorderLight),
                  // PILIHAN NADA / GAYA ADZAN
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pilihan Nada / Gaya Adzan',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Pilih suara kumandang adzan saat waktu sholat tiba',
                                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                            // Tombol Pratinjau Suara
                            IconButton.filledTonal(
                              tooltip: 'Dengarkan Suara Adzan',
                              icon: Icon(
                                ref.watch(audioPlayerProvider).isPlaying &&
                                        ref.watch(audioPlayerProvider).currentTitle == settings.adzanSoundName
                                    ? Icons.stop_rounded
                                    : Icons.play_arrow_rounded,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                final audioState = ref.read(audioPlayerProvider);
                                if (audioState.isPlaying && audioState.currentTitle == settings.adzanSoundName) {
                                  ref.read(audioPlayerProvider.notifier).stop();
                                } else {
                                  if (settings.adzanSound != 'default') {
                                    ref.read(audioPlayerProvider.notifier).playAudio(
                                          'assets/audio/${settings.adzanSound}.mp3',
                                          title: settings.adzanSoundName,
                                          subtitle: 'Pratinjau Suara Adzan',
                                        );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Nada default menggunakan ringtone bawaan perangkat.')),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.cardBorderLight),
                            color: const Color(0xFFF9FBFA),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: settings.adzanSound,
                              items: const [
                                DropdownMenuItem(
                                  value: 'adzan_makkah',
                                  child: Row(
                                    children: [
                                      Icon(Icons.mosque_rounded, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('Adzan Makkah (Merdu & Syahdu)'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'adzan_madinah',
                                  child: Row(
                                    children: [
                                      Icon(Icons.mosque_outlined, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('Adzan Madinah (Khusyuk)'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'adzan_mesir',
                                  child: Row(
                                    children: [
                                      Icon(Icons.spatial_audio_rounded, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('Adzan Mesir / Cairo (Klasik)'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'default',
                                  child: Row(
                                    children: [
                                      Icon(Icons.notifications_rounded, size: 18, color: AppColors.textSecondary),
                                      SizedBox(width: 8),
                                      Text('Suara Bawaan Sistem HP'),
                                    ],
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  String name = 'Adzan Makkah (Merdu & Syahdu)';
                                  if (val == 'adzan_madinah') name = 'Adzan Madinah (Khusyuk)';
                                  if (val == 'adzan_mesir') name = 'Adzan Mesir / Cairo (Klasik)';
                                  if (val == 'default') name = 'Suara Bawaan Sistem HP';
                                  notifier.setAdzanSound(val, name);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.cardBorderLight),
                  _buildPrayerCheckTile(
                    title: 'Subuh',
                    value: settings.alertSubuh,
                    onChanged: (val) => notifier.togglePrayerAlert('Subuh', val),
                  ),
                  _buildPrayerCheckTile(
                    title: 'Dzuhur',
                    value: settings.alertDzuhur,
                    onChanged: (val) => notifier.togglePrayerAlert('Dzuhur', val),
                  ),
                  _buildPrayerCheckTile(
                    title: 'Ashar',
                    value: settings.alertAshar,
                    onChanged: (val) => notifier.togglePrayerAlert('Ashar', val),
                  ),
                  _buildPrayerCheckTile(
                    title: 'Maghrib',
                    value: settings.alertMaghrib,
                    onChanged: (val) => notifier.togglePrayerAlert('Maghrib', val),
                  ),
                  _buildPrayerCheckTile(
                    title: 'Isya',
                    value: settings.alertIsya,
                    onChanged: (val) => notifier.togglePrayerAlert('Isya', val),
                  ),
                  const Divider(height: 1, color: AppColors.cardBorderLight),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.volume_up_rounded, size: 20),
                      label: const Text('Tes Notifikasi Adzan Sekarang'),
                      onPressed: () async {
                        await NotificationService().showNotification(
                          id: 999,
                          title: 'Waktu Sholat Telah Tiba',
                          body: 'Panggilan adzan (${settings.adzanSoundName}) telah berkumandang. Mari tunaikan sholat.',
                          soundName: settings.adzanSound,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Notifikasi tes berhasil dikirim dengan suara ${settings.adzanSoundName}!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // SEKSI 3: TENTANG APLIKASI
            _buildSectionHeader(context, icon: Icons.info_outline_rounded, title: 'Tentang Aplikasi'),
            const SizedBox(height: 10),
            _buildCard(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_stories_rounded, color: AppColors.primary, size: 20),
                  ),
                  title: const Text('QuranMu', style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text('Aplikasi Al-Qur\'an & Teman Ibadah Harian'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('v1.0.0', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                  ),
                ),
                const Divider(height: 1, color: AppColors.cardBorderLight),
                const ListTile(
                  leading: Icon(Icons.offline_bolt_rounded, color: AppColors.secondary),
                  title: Text('Mode Offline-First', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('Data Al-Qur\'an, hisab jadwal sholat, dan doa tersimpan di perangkat'),
                ),
                const Divider(height: 1, color: AppColors.cardBorderLight),
                const ListTile(
                  leading: Icon(Icons.verified_user_outlined, color: AppColors.primary),
                  title: Text('Standar Data Kemenag RI', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('Teks Mushaf Standar Indonesia, Terjemahan & Tafsir Resmi Kemenag RI'),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _buildPrayerCheckTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile.adaptive(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      value: value,
      activeColor: AppColors.primary,
      dense: true,
      onChanged: (val) => onChanged(val ?? true),
    );
  }
}

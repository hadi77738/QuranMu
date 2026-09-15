import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/daily_verses_data.dart';
import '../services/prayer_service.dart';
import '../services/quran_service.dart';
import '../services/audio_service.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().requestPermission();
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // Sinkronkan notifikasi jadwal sholat otomatis saat settings/lokasi diperbarui
    ref.watch(prayerNotificationSyncProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header Salam & Notifikasi
              _buildHeader(context),
              const SizedBox(height: 20),

              // 2. Banner Kartu Jadwal Sholat Utama (Gradient Emerald & Gold)
              _buildPrayerHeroCard(context),
              const SizedBox(height: 24),

              // 3. Section Terakhir Dibaca (Quick Resume Banner)
              _buildLastReadCard(context),
              const SizedBox(height: 24),

              // 4. Menu Fitur Cepat (Symmetrical 4-Grid Menu)
              _buildQuickAccessGrid(context),
              const SizedBox(height: 24),

              // 5. Kartu Ayat Hari Ini
              _buildAyatHariIniCard(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Assalamu\'alaikum',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'QuranMu',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.text(context),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tidak ada notifikasi baru'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerHeroCard(BuildContext context) {
    final prayerAsync = ref.watch(dynamicPrayerTimesProvider);

    return prayerAsync.when(
      loading: () => _buildPrayerHeroCardPlaceholder(context),
      error: (err, stack) => _buildPrayerHeroCardPlaceholder(context),
      data: (data) => _buildPrayerHeroCardContent(context, data),
    );
  }

  Widget _buildPrayerHeroCardPlaceholder(BuildContext context) {
    final defaultData = ref.read(prayerServiceProvider).getPrayerTimes();
    return _buildPrayerHeroCardContent(context, defaultData);
  }

  Widget _buildPrayerHeroCardContent(BuildContext context, PrayerTimeData data) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF095A46),
            Color(0xFF074535),
            Color(0xFF043327),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF095A46).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Row 1: Lokasi & Tanggal Hijriyah
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Memperbarui lokasi GPS...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  await ref.read(userLocationProvider.notifier).refreshLocation();
                  if (context.mounted) {
                    final newLoc = ref.read(userLocationProvider).locationName;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lokasi diperbarui: $newLoc'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.my_location_rounded, color: AppColors.secondary, size: 14),
                      const SizedBox(width: 5),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 160),
                        child: Text(
                          data.locationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                '12 Rabiul Awal 1448 H',
                style: TextStyle(
                  color: Color(0xFFE2F3ED),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Row 2: Countdown Sholat Real-Time
          Text(
            'Menuju Waktu ${data.nextPrayerName}',
            style: const TextStyle(
              color: Color(0xFFBCE3D6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDuration(data.timeRemaining),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),

          // Row 3: 5 Waktu Sholat Symmetrical Capsule Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _buildPrayerPill('Subuh', data.formatTime(data.subuh), data.nextPrayerName == 'Subuh'),
                _buildPrayerPill('Dzuhur', data.formatTime(data.dzuhur), data.nextPrayerName == 'Dzuhur'),
                _buildPrayerPill('Ashar', data.formatTime(data.ashar), data.nextPrayerName == 'Ashar'),
                _buildPrayerPill('Maghrib', data.formatTime(data.maghrib), data.nextPrayerName == 'Maghrib'),
                _buildPrayerPill('Isya', data.formatTime(data.isya), data.nextPrayerName == 'Isya'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerPill(String name, String time, bool isNext) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isNext ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isNext
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                color: isNext ? AppColors.onSecondary : const Color(0xFFBCE3D6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
                color: isNext ? AppColors.onSecondary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastReadCard(BuildContext context) {
    final lastRead = ref.watch(lastReadProvider);
    final surahName = lastRead?.surahNamaLatin ?? 'Al-Fatihah';
    final ayatNomor = lastRead?.ayatNomor ?? 1;
    final targetSurah = lastRead?.surahNomor ?? 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.isDark(context) ? const Color(0xFF0D4738) : AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.bookmark_rounded,
              color: AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terakhir Dibaca',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.subText(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Surah $surahName : Ayat $ayatNomor',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text(context),
                  ),
                ),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () => context.push('/quran/$targetSurah'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lanjut', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    final items = [
      {
        'icon': Icons.explore_rounded,
        'title': 'Arah Kiblat',
        'color': const Color(0xFF095A46),
        'bg': const Color(0xFFE2F3ED),
      },
      {
        'icon': Icons.menu_book_rounded,
        'title': 'Al-Qur\'an',
        'color': const Color(0xFFB57C1E),
        'bg': const Color(0xFFFFF3D6),
      },
      {
        'icon': Icons.headphones_rounded,
        'title': 'Murottal',
        'color': const Color(0xFF2E6B9E),
        'bg': const Color(0xFFE1EFFB),
      },
      {
        'icon': Icons.favorite_rounded,
        'title': 'Doa Harian',
        'color': const Color(0xFF9E3A5A),
        'bg': const Color(0xFFFCE4EC),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitur Pilihan',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.text(context),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _buildQuickItem(
                  context,
                  icon: item['icon'] as IconData,
                  title: item['title'] as String,
                  color: item['color'] as Color,
                  bg: item['bg'] as Color,
                  onTap: () {
                    if (item['title'] == 'Al-Qur\'an') {
                      context.go('/quran');
                    } else if (item['title'] == 'Arah Kiblat') {
                      context.push('/qibla');
                    } else if (item['title'] == 'Doa Harian') {
                      context.push('/doa');
                    } else if (item['title'] == 'Murottal') {
                      _showMurottalModal(context);
                    }
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showMurottalModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final settings = ref.watch(settingsProvider);
        final surahsAsync = ref.watch(surahListProvider);

        return Container(
          height: MediaQuery.of(context).size.height * 0.72,
          decoration: BoxDecoration(
            color: AppColors.surface(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle Drag
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Murottal Al-Qur\'an Pilihan',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
                        ),
                        Text(
                          'Qari: ${settings.qariName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: AppColors.cardBorder(context)),
              Expanded(
                child: surahsAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (err, _) => Center(
                    child: Text('Gagal memuat: $err'),
                  ),
                  data: (surahs) {
                    final popularIds = [1, 18, 36, 55, 56, 67, 112, 113, 114];
                    final popularSurahs = surahs.where((s) => popularIds.contains(s.nomor)).toList();

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: popularSurahs.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.cardBorder(context)),
                      itemBuilder: (c, idx) {
                        final s = popularSurahs[idx];
                        final audioUrl = s.audioFull?[settings.qariId] ?? s.audioFull?['05'] ?? s.audioFull?['01'];

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          leading: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${s.nomor}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          title: Text(
                            s.namaLatin,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          subtitle: Text(
                            '${s.arti} • ${s.jumlahAyat} Ayat',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.play_circle_fill_rounded,
                              color: AppColors.primary,
                              size: 32,
                            ),
                            tooltip: 'Putar Surah',
                            onPressed: () {
                              if (audioUrl != null) {
                                ref.read(audioPlayerProvider.notifier).playAudio(
                                      audioUrl,
                                      title: 'Surah ${s.namaLatin}',
                                      subtitle: settings.qariName,
                                    );
                                Navigator.pop(ctx);
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Footer: Tombol ke Seluruh Al-Qur'an
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.library_books_rounded, size: 18),
                    label: const Text('Buka Semua 114 Surah di Al-Qur\'an'),
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.go('/quran');
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.text(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAyatHariIniCard(BuildContext context) {
    final dailyVerse = getDailyVerse();
    final periodLabel = getDailyVersePeriodLabel();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Kartu Ayat & Rotasi 8 Jam
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ayat Pilihan',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.text(context),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.schedule_rounded, size: 11, color: AppColors.primary),
                          const SizedBox(width: 3),
                          Text(
                            periodLabel,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  context.push('/quran/${dailyVerse.surahNomor}');
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        dailyVerse.reference,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Teks Arab Ayat
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.isDark(context) ? const Color(0xFF0F1A17) : const Color(0xFFFAFCFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder(context)),
            ),
            child: Text(
              dailyVerse.teksArab,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 23,
                fontWeight: FontWeight.w600,
                height: 2.2,
                color: AppColors.arabic(context),
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 12),

          // Transliterasi Latin
          Text(
            dailyVerse.teksLatin,
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Terjemahan Bahasa Indonesia
          Text(
            '"${dailyVerse.terjemahan}"',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.subText(context),
            ),
          ),
          const SizedBox(height: 14),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6F3),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Tema: ${dailyVerse.tema}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0D6E55),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.textSecondary),
                    tooltip: 'Salin Ayat',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      final text = '${dailyVerse.teksArab}\n\n"${dailyVerse.terjemahan}" (${dailyVerse.reference})';
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ayat berhasil disalin ke clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border_rounded, size: 20, color: AppColors.secondary),
                    tooltip: 'Simpan Bacaan',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      ref.read(lastReadProvider.notifier).saveLastRead(
                            surahNomor: dailyVerse.surahNomor,
                            surahNamaLatin: dailyVerse.surahNama,
                            ayatNomor: dailyVerse.ayatNomor,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ditandai terakhir dibaca: ${dailyVerse.reference}'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

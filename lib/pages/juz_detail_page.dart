import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/ayat.dart';
import '../models/surah_detail.dart';
import '../models/tafsir_ayat.dart';
import '../models/juz.dart';
import '../services/quran_service.dart';
import '../services/audio_service.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';
import '../components/mushaf_ruled_text.dart';

class JuzDetailPage extends ConsumerStatefulWidget {
  final int juzNomor;

  const JuzDetailPage({super.key, required this.juzNomor});

  @override
  ConsumerState<JuzDetailPage> createState() => _JuzDetailPageState();
}

class _JuzDetailPageState extends ConsumerState<JuzDetailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLandscape = false;

  void _toggleOrientation() {
    setState(() {
      _isLandscape = !_isLandscape;
      if (_isLandscape) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  void _playAyatAudio(SurahDetail surah, Ayat ayat, AppSettings settings) {
    final url = ayat.audio?[settings.qariId] ?? ayat.audio?['05'] ?? ayat.audio?['01'];
    if (url != null) {
      ref.read(audioPlayerProvider.notifier).playAudio(
            url,
            title: '${surah.namaLatin} : Ayat ${ayat.nomorAyat}',
            subtitle: settings.qariName,
          );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.volume_up_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Memutar ${surah.namaLatin} : Ayat ${ayat.nomorAyat} (${settings.qariName})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String _cleanArabicText(String text) {
    return text.replaceAll('\u08D6', '').replaceAll('ࣖ', '').replaceAll('\u06DD', '');
  }

  String _toArabicNumber(int n) {
    const digits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    return n.toString().split('').map((e) => digits[int.parse(e)]).join('');
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final juzAsync = ref.watch(juzDetailProvider(widget.juzNomor));
    final readingMode = ref.watch(readingModeProvider);
    final audioState = ref.watch(audioPlayerProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: juzAsync.when(
          loading: () => Text('Juz ${widget.juzNomor}...'),
          error: (err, stack) => Text('Juz ${widget.juzNomor}'),
          data: (juzDetail) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Juz ${juzDetail.juz.nomor}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              Text(
                '${juzDetail.juz.rangeDescription} • ${juzDetail.totalAyat} Ayat',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        actions: [
          // Switch Mode Lanskap / Potret
          IconButton(
            tooltip: _isLandscape ? 'Mode Potret' : 'Mode Lanskap',
            icon: Icon(
              _isLandscape
                  ? Icons.stay_current_portrait_rounded
                  : Icons.stay_current_landscape_rounded,
              color: AppColors.primary,
            ),
            onPressed: _toggleOrientation,
          ),
          // Switch Mode Baca
          IconButton(
            tooltip: readingMode == ReadingMode.translation
                ? 'Ganti ke Mode Mushaf'
                : 'Ganti ke Mode Terjemahan',
            icon: Icon(
              readingMode == ReadingMode.translation
                  ? Icons.menu_book_rounded
                  : Icons.format_align_left_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              ref.read(readingModeProvider.notifier).toggleMode();
            },
          ),
        ],
      ),
      body: juzAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Memuat ayat-ayat Juz ${widget.juzNomor}...',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.textMuted),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat Juz ${widget.juzNomor}: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Coba Lagi'),
                  onPressed: () {
                    ref.invalidate(juzDetailProvider(widget.juzNomor));
                  },
                )
              ],
            ),
          ),
        ),
        data: (juzDetail) {
          return readingMode == ReadingMode.translation
              ? _buildTranslationMode(juzDetail, settings)
              : _buildMushafMode(juzDetail, settings, audioState);
        },
      ),
    );
  }

  // ==========================================
  // MODE 1: AYAT + TERJEMAHAN
  // ==========================================
  Widget _buildTranslationMode(JuzDetail juzDetail, AppSettings settings) {
    final items = <Widget>[];

    // 1. Header Banner Juz
    items.add(_buildJuzHeaderCard(juzDetail.juz, juzDetail.totalAyat));

    // 2. Tampilkan setiap Surah di dalam Juz
    for (final section in juzDetail.sections) {
      // Surah Header atau Lanjutan Badge
      if (section.isStartOfSurah) {
        items.add(_buildSurahHeaderCard(section));
        if (section.surah.nomor != 1 && section.surah.nomor != 9) {
          items.add(_buildBismillahCard());
        }
      } else {
        items.add(_buildContinuationHeader(section));
      }

      // List Ayat-Ayat dalam section ini
      for (final ayat in section.ayatList) {
        items.add(_buildAyatCard(section.surah, ayat, settings));
      }
    }

    // 3. Navigasi Juz Sebelumnya / Selanjutnya
    items.add(_buildJuzNavigationFooter(juzDetail.juz.nomor));

    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 32),
      itemCount: items.length,
      itemBuilder: (context, index) => items[index],
    );
  }

  Widget _buildJuzHeaderCard(Juz juz, int totalAyat) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D6E55), Color(0xFF044836)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D6E55).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Nama Arab Juz
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.5)),
            ),
            child: Text(
              juz.namaArabic,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD54F),
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(width: 14),
          // Deskripsi Rentang
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Juz ${juz.nomor}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  juz.rangeDescription,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Total $totalAyat Ayat',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFD54F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahHeaderCard(JuzSection section) {
    final surah = section.surah;
    final isPartial = section.ayatList.length < surah.jumlahAyat;
    final rangeText = isPartial
        ? 'Ayat ${section.ayatList.first.nomorAyat} - ${section.ayatList.last.nomorAyat} (dari ${surah.jumlahAyat} Ayat)'
        : '${surah.jumlahAyat} Ayat';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: (AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.isDark(context) ? const Color(0xFF0D4738) : AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: (AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary).withValues(alpha: 0.4)),
            ),
            alignment: Alignment.center,
            child: Text(
              surah.nomor.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Surah ${surah.namaLatin}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.text(context),
                  ),
                ),
                Text(
                  '${surah.arti} • $rangeText',
                  style: TextStyle(fontSize: 11, color: AppColors.subText(context)),
                ),
              ],
            ),
          ),
          Text(
            surah.nama,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildContinuationHeader(JuzSection section) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bookmark_added_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Lanjutan Surah ${section.surah.namaLatin} (Mulai Ayat ${section.ayatList.first.nomorAyat})',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          Text(
            section.surah.nama,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildBismillahCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7EE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), width: 1.5),
      ),
      child: const Center(
        child: Text(
          'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D6E55),
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildAyatCard(SurahDetail surah, Ayat ayat, AppSettings settings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.015),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar: nomor ayat & aksi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.isDark(context) ? const Color(0xFF0F1A17) : AppColors.backgroundLight.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                // Nomor Surah & Ayat
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.isDark(context) ? const Color(0xFF0D4738) : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: (AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary).withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    '${surah.nomor}:${ayat.nomorAyat}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primaryDark,
                    ),
                  ),
                ),
                const Spacer(),
                // Audio
                IconButton(
                  icon: const Icon(Icons.play_circle_outline_rounded, size: 20),
                  tooltip: 'Putar Audio Ayat',
                  color: AppColors.primary,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _playAyatAudio(surah, ayat, settings),
                ),
                // Tafsir
                IconButton(
                  icon: const Icon(Icons.menu_book_outlined, size: 20),
                  tooltip: 'Tafsir Kemenag',
                  color: AppColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _showTafsirBottomSheet(context, surah.nomor, surah.namaLatin, ayat.nomorAyat),
                ),
                // Copy
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: 'Salin Teks',
                  color: AppColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                      text: '${ayat.teksArab}\n\n"${ayat.teksIndonesia}" (QS. ${surah.namaLatin}: ${ayat.nomorAyat})',
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ayat berhasil disalin ke clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                // Bookmark
                IconButton(
                  icon: const Icon(Icons.bookmark_border_rounded, size: 20),
                  tooltip: 'Tandai Terakhir Dibaca',
                  color: AppColors.textSecondary,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    ref.read(lastReadProvider.notifier).saveLastRead(
                          surahNomor: surah.nomor,
                          surahNamaLatin: surah.namaLatin,
                          ayatNomor: ayat.nomorAyat,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ditandai terakhir dibaca: ${surah.namaLatin} Ayat ${ayat.nomorAyat}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Teks Ayat Arab
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _playAyatAudio(surah, ayat, settings),
              child: Text(
                _cleanArabicText(ayat.teksArab),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: settings.arabicFontSize,
                  fontWeight: FontWeight.bold,
                  height: 2.2,
                  color: AppColors.arabic(context),
                ),
              ),
            ),
          ),

          // Transliterasi Latin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              ayat.teksLatin,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: AppColors.isDark(context) ? const Color(0xFF34D399) : AppColors.primary,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Terjemahan Indonesia
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 14.0),
            child: Text(
              ayat.teksIndonesia,
              style: TextStyle(
                fontSize: settings.translationFontSize,
                color: AppColors.text(context),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODE 2: MUSHAF STANDAR INDONESIA
  // ==========================================
  Widget _buildMushafMode(JuzDetail juzDetail, AppSettings settings, dynamic audioState) {
    return Container(
      color: const Color(0xFFFDFBF5),
      child: ListView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        children: [
          // Bingkai Ganda Luar & Dalam Mushaf Standar Indonesia
          Container(
            decoration: BoxDecoration(
              color: AppColors.isDark(context) ? const Color(0xFF111D19) : const Color(0xFFFCF9F0),
              border: Border.all(color: const Color(0xFFC89737), width: 2.5),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: AppColors.isDark(context) ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.isDark(context) ? const Color(0xFF10B981) : const Color(0xFF0D6E55), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              child: Column(
                children: [
                  // Banner Pembuka Juz
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D6E55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC89737), width: 1.5),
                    ),
                    child: Text(
                      'Juz ${juzDetail.juz.nomor} • ${juzDetail.juz.namaArabic}',
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  // Aliran Surah-Surah dalam Juz
                  for (final section in juzDetail.sections) ...[
                    // Kepala Surah
                    if (section.isStartOfSurah) ...[
                      _buildMushafSurahHeader(section),
                      if (section.surah.nomor != 1 && section.surah.nomor != 9)
                        _buildMushafBismillah(),
                    ] else ...[
                      _buildMushafContinuationDivider(section),
                    ],

                    // Teks Bergaris per Surah
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      child: MushafRuledText(
                        showLines: settings.showMushafLines,
                        lineColor: AppColors.mushafLine(context),
                        child: RichText(
                          textAlign: TextAlign.justify,
                          textDirection: TextDirection.rtl,
                          text: TextSpan(
                            children: section.ayatList.expand((ayat) {
                              final isCurrentPlaying = audioState.isPlaying &&
                                  audioState.currentTitle == '${section.surah.namaLatin} : Ayat ${ayat.nomorAyat}';
                              return [
                                TextSpan(
                                  text: '${_cleanArabicText(ayat.teksArab)} ',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => _playAyatAudio(section.surah, ayat, settings),
                                  style: TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: settings.arabicFontSize,
                                    fontWeight: isCurrentPlaying ? FontWeight.bold : FontWeight.w600,
                                    height: 2.35,
                                    color: isCurrentPlaying
                                        ? (AppColors.isDark(context) ? const Color(0xFF34D399) : const Color(0xFF0D6E55))
                                        : AppColors.arabic(context),
                                    backgroundColor: isCurrentPlaying ? const Color(0x3300BFA5) : null,
                                  ),
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: GestureDetector(
                                    onTap: () => _playAyatAudio(section.surah, ayat, settings),
                                    onLongPress: () => _showAyatOptionModal(context, section.surah, ayat),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isCurrentPlaying
                                            ? (AppColors.isDark(context) ? const Color(0xFF0D4738) : const Color(0xFFE0F2F1))
                                            : (AppColors.isDark(context) ? const Color(0xFF1E2822) : const Color(0xFFFAF6EB)),
                                        border: Border.all(
                                          color: isCurrentPlaying
                                              ? (AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary)
                                              : (AppColors.isDark(context) ? const Color(0xFFFFD54F) : const Color(0xFFC89737)),
                                          width: isCurrentPlaying ? 2.0 : 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        _toArabicNumber(ayat.nomorAyat),
                                        style: TextStyle(
                                          fontFamily: 'Amiri',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: isCurrentPlaying
                                              ? (AppColors.isDark(context) ? const Color(0xFF10B981) : AppColors.primary)
                                              : (AppColors.isDark(context) ? const Color(0xFFFFD54F) : const Color(0xFF0D6E55)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: '  '),
                              ];
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Footer Kaki Mushaf
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF7EE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFC89737).withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Juz ${juzDetail.juz.nomor}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8C6D23),
                          ),
                        ),
                        const Text(
                          'Mushaf Standar Indonesia',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF0D6E55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D6E55),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Ayat Pojok',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navigasi Footer
          _buildJuzNavigationFooter(juzDetail.juz.nomor),
        ],
      ),
    );
  }

  Widget _buildMushafSurahHeader(JuzSection section) {
    final surah = section.surah;
    final isPartial = section.ayatList.length < surah.jumlahAyat;
    final rangeText = isPartial
        ? 'AYAT ${section.ayatList.first.nomorAyat}-${section.ayatList.last.nomorAyat}'
        : '${surah.jumlahAyat} AYAT';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D6E55),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC89737), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${surah.tempatTurun.toUpperCase()} • $rangeText',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFD54F),
                  ),
                ),
                Text(
                  'سُوْرَةُ ${surah.nama}',
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Text(
                  'SURAH KE-${surah.nomor}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFD54F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMushafContinuationDivider(JuzSection section) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.isDark(context) ? const Color(0xFF182823) : const Color(0xFFFAF7EE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC89737).withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lanjutan Surah ${section.surah.namaLatin}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.isDark(context) ? const Color(0xFF10B981) : const Color(0xFF0D6E55),
            ),
          ),
          Text(
            'Mulai Ayat ${section.ayatList.first.nomorAyat}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8C6D23),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMushafBismillah() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.isDark(context) ? const Color(0xFF182823) : const Color(0xFFFAF7EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC89737).withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Text(
          'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.isDark(context) ? const Color(0xFF10B981) : const Color(0xFF0D6E55),
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildJuzNavigationFooter(int juzNomor) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 20, left: 16, right: 16),
      child: Row(
        children: [
          if (juzNomor > 1)
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text('Juz ${juzNomor - 1}'),
                onPressed: () {
                  context.pushReplacement('/juz/${juzNomor - 1}');
                },
              ),
            )
          else
            const Spacer(),
          const SizedBox(width: 12),
          if (juzNomor < 30)
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text('Juz ${juzNomor + 1}'),
                onPressed: () {
                  context.pushReplacement('/juz/${juzNomor + 1}');
                },
              ),
            )
          else
            const Spacer(),
        ],
      ),
    );
  }

  void _showAyatOptionModal(BuildContext context, SurahDetail surah, Ayat ayat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    Text(
                      'Surah ${surah.namaLatin} : Ayat ${ayat.nomorAyat}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.play_circle_outline_rounded, color: AppColors.primary),
                title: const Text('Putar Audio Ayat'),
                onTap: () {
                  Navigator.pop(ctx);
                  final settings = ref.read(settingsProvider);
                  _playAyatAudio(surah, ayat, settings);
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_book_outlined, color: AppColors.primary),
                title: const Text('Buka Tafsir Kemenag'),
                onTap: () {
                  Navigator.pop(ctx);
                  _showTafsirBottomSheet(context, surah.nomor, surah.namaLatin, ayat.nomorAyat);
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_outline_rounded, color: AppColors.primary),
                title: const Text('Tandai Terakhir Dibaca'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(lastReadProvider.notifier).saveLastRead(
                        surahNomor: surah.nomor,
                        surahNamaLatin: surah.namaLatin,
                        ayatNomor: ayat.nomorAyat,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ditandai terakhir dibaca: ${surah.namaLatin} Ayat ${ayat.nomorAyat}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTafsirBottomSheet(BuildContext context, int surahNomor, String surahNamaLatin, int ayatNomor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final tafsirAsync = ref.watch(surahTafsirProvider(surahNomor));

            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.4,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tafsir Kemenag RI',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'Surah $surahNamaLatin : Ayat $ayatNomor',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Expanded(
                        child: tafsirAsync.when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                          error: (err, stack) => Center(
                            child: Text('Gagal memuat tafsir: $err'),
                          ),
                          data: (tafsirList) {
                            final tafsir = tafsirList.firstWhere(
                              (t) => t.ayat == ayatNomor,
                              orElse: () => TafsirAyat(ayat: ayatNomor, teks: 'Tafsir tidak tersedia.'),
                            );

                            return SingleChildScrollView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                tafsir.teks,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.7,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

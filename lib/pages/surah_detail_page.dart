import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ayat.dart';
import '../models/surah_detail.dart';
import '../models/tafsir_ayat.dart';
import '../services/quran_service.dart';
import '../services/audio_service.dart';
import '../services/settings_service.dart';
import '../theme/app_theme.dart';

class SurahDetailPage extends ConsumerStatefulWidget {
  final int surahNomor;

  const SurahDetailPage({super.key, required this.surahNomor});

  @override
  ConsumerState<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends ConsumerState<SurahDetailPage> {
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
    final surahAsync = ref.watch(surahDetailProvider(widget.surahNomor));
    final readingMode = ref.watch(readingModeProvider);
    final audioState = ref.watch(audioPlayerProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: surahAsync.when(
          loading: () => const Text('Memuat...'),
          error: (err, stack) => const Text('Al-Qur\'an'),
          data: (surah) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah.namaLatin,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
              ),
              Text(
                '${surah.arti} • ${surah.jumlahAyat} Ayat',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
          // Audio Murottal Surah
          surahAsync.maybeWhen(
            data: (surah) {
              final audioUrl = surah.audioFull?[settings.qariId] ?? surah.audioFull?['05'] ?? surah.audioFull?['01'];
              if (audioUrl == null) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Putar Murottal Surah (${settings.qariName})',
                icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                onPressed: () {
                  ref.read(audioPlayerProvider.notifier).playAudio(
                        audioUrl,
                        title: 'Surah ${surah.namaLatin}',
                        subtitle: settings.qariName,
                      );
                },
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Stack(
        children: [
          surahAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
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
                      'Gagal memuat surah: $err',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Coba Lagi'),
                      onPressed: () {
                        ref.invalidate(surahDetailProvider(widget.surahNomor));
                      },
                    )
                  ],
                ),
              ),
            ),
            data: (surah) {
              return readingMode == ReadingMode.translation
                  ? _buildTranslationMode(surah, settings)
                  : _buildMushafMode(surah, settings, audioState);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBismillahHeader(int surahNomor) {
    if (surahNomor == 1 || surahNomor == 9) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF7EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), width: 1.5),
      ),
      child: const Center(
        child: Text(
          'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D6E55),
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  // MODE 1: Ayat + Terjemahan
  Widget _buildTranslationMode(SurahDetail surah, AppSettings settings) {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: surah.ayatList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildBismillahHeader(surah.nomor);
        }

        final ayat = surah.ayatList[index - 1];
        return _buildAyatCard(surah, ayat, settings);
      },
    );
  }

  Widget _buildAyatCard(SurahDetail surah, Ayat ayat, AppSettings settings) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toolbar Ayat (Nomor + Aksi Cepat)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAF8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nomor Ayat Pill
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${ayat.nomorAyat}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // Tombol Aksi
                Row(
                  children: [
                    // Play Ayat
                    if (ayat.audio?[settings.qariId] != null || ayat.audio?['05'] != null || ayat.audio?['01'] != null)
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline_rounded, size: 20, color: AppColors.primary),
                        tooltip: 'Putar Ayat (${settings.qariName})',
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          final url = ayat.audio?[settings.qariId] ?? ayat.audio?['05'] ?? ayat.audio?['01']!;
                          ref.read(audioPlayerProvider.notifier).playAudio(
                                url!,
                                title: '${surah.namaLatin} : Ayat ${ayat.nomorAyat}',
                                subtitle: settings.qariName,
                              );
                        },
                      ),

                    // Tafsir
                    IconButton(
                      icon: const Icon(Icons.menu_book_outlined, size: 20, color: AppColors.textSecondary),
                      tooltip: 'Tafsir Ayat',
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        _showTafsirBottomSheet(context, surah.nomor, surah.namaLatin, ayat.nomorAyat);
                      },
                    ),

                    // Salin Ayat
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.textSecondary),
                      tooltip: 'Salin Ayat',
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        final textToCopy = '${ayat.teksArab}\n\n"${ayat.teksIndonesia}" (QS. ${surah.namaLatin}: ${ayat.nomorAyat})';
                        Clipboard.setData(ClipboardData(text: textToCopy));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Ayat ${ayat.nomorAyat} berhasil disalin!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),

                    // Tandai Terakhir Baca
                    IconButton(
                      icon: const Icon(Icons.bookmark_border_rounded, size: 20, color: AppColors.secondary),
                      tooltip: 'Tandai Terakhir Baca',
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
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Teks Arab Ayat (Dinamis dari Pengaturan)
          Text(
            _cleanArabicText(ayat.teksArab),
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: settings.arabicFontSize,
              fontWeight: FontWeight.w600,
              height: 2.2,
              color: const Color(0xFF1B2A26),
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),

          // Transliterasi Latin
          Text(
            ayat.teksLatin,
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: AppColors.primary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),

          // Terjemahan Bahasa Indonesia (Dinamis dari Pengaturan)
          Text(
            ayat.teksIndonesia,
            style: TextStyle(
              fontSize: settings.translationFontSize,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // MODE 2: Mushaf Standar Indonesia (Bergaris, Ornamen Ganda, Ayat Pojok & Kaligrafi Amiri)
  Widget _buildMushafMode(SurahDetail surah, AppSettings settings, AudioState audioState) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: _isLandscape ? 32.0 : 16.0,
        vertical: 16.0,
      ),
      child: Column(
        children: [
          // Frame Utama Mushaf Standar Indonesia (Bingkai Ganda Emas & Zamrud)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFDFBF5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC89737), width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(4.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF0D6E55), width: 1.2),
              ),
              child: Column(
                children: [
                  // 1. Ornamen Kepala Surah (Khas Mushaf Indonesia)
                  Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F8F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC89737), width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah.namaLatin,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: Color(0xFF0D6E55),
                              ),
                            ),
                            Text(
                              '${surah.tempatTurun.toUpperCase()} • ${surah.jumlahAyat} AYAT',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8C6D23),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        // Nama Surah Kaligrafi Arab
                        Text(
                          surah.nama,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D6E55),
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),

                  // 2. Ornamen Bismillah
                  if (surah.nomor != 1 && surah.nomor != 9)
                    Container(
                      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF7EE),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFC89737).withValues(alpha: 0.4)),
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
                    ),

                  // 3. Teks Al-Qur'an Bergaris (Mushaf Bergaris Standar Indonesia)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                    child: CustomPaint(
                      painter: MushafRuledLinesPainter(
                        lineHeight: settings.arabicFontSize * 2.35,
                        lineColor: const Color(0xFFE6DDC8),
                      ),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                          children: surah.ayatList.expand((ayat) {
                            final isCurrentPlaying = audioState.isPlaying &&
                                audioState.currentTitle == '${surah.namaLatin} : Ayat ${ayat.nomorAyat}';
                            return [
                              TextSpan(
                                text: '${_cleanArabicText(ayat.teksArab)} ',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => _playAyatAudio(surah, ayat, settings),
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: settings.arabicFontSize,
                                  fontWeight: isCurrentPlaying ? FontWeight.bold : FontWeight.w600,
                                  height: 2.35,
                                  color: isCurrentPlaying ? const Color(0xFF0D6E55) : const Color(0xFF1B2A26),
                                  backgroundColor: isCurrentPlaying ? const Color(0x3300BFA5) : null,
                                ),
                              ),
                              // Medali Penanda Ayat Khas Mushaf Indonesia
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: GestureDetector(
                                  onTap: () {
                                    _playAyatAudio(surah, ayat, settings);
                                  },
                                  onLongPress: () {
                                    _showAyatOptionModal(context, surah, ayat);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCurrentPlaying ? const Color(0xFFE0F2F1) : const Color(0xFFFAF6EB),
                                      border: Border.all(
                                        color: isCurrentPlaying ? AppColors.primary : const Color(0xFFC89737),
                                        width: isCurrentPlaying ? 2.0 : 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isCurrentPlaying ? AppColors.primary : const Color(0xFFC89737))
                                              .withValues(alpha: 0.25),
                                          blurRadius: isCurrentPlaying ? 4 : 2,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      _toArabicNumber(ayat.nomorAyat),
                                      style: TextStyle(
                                        fontFamily: 'Amiri',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isCurrentPlaying ? AppColors.primary : const Color(0xFF0D6E55),
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

                  // 4. Baris Ayat Pojok & Footer Mushaf Indonesia
                  Container(
                    margin: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF7EE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFC89737).withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Keterangan Kiri
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, size: 14, color: Color(0xFFC89737)),
                            const SizedBox(width: 4),
                            Text(
                              'Surah ke-${surah.nomor}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF8C6D23),
                              ),
                            ),
                          ],
                        ),
                        // Label Tengah
                        const Text(
                          'Mushaf Standar Indonesia',
                          style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF0D6E55),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Penanda Ayat Pojok Kanan
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
        ],
      ),
    );
  }

  // Modal Opsi saat Ayat di Mushaf di-klik
  void _showAyatOptionModal(BuildContext context, SurahDetail surah, Ayat ayat) {
    final settings = ref.read(settingsProvider);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Surah ${surah.namaLatin} : Ayat ${ayat.nomorAyat}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                ayat.teksIndonesia,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary),
                    label: const Text('Putar Audio'),
                    onPressed: () {
                      Navigator.pop(context);
                      _playAyatAudio(surah, ayat, settings);
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.menu_book_rounded, color: AppColors.primary),
                    label: const Text('Buka Tafsir'),
                    onPressed: () {
                      Navigator.pop(context);
                      _showTafsirBottomSheet(context, surah.nomor, surah.namaLatin, ayat.nomorAyat);
                    },
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.bookmark_rounded, color: AppColors.secondary),
                    label: const Text('Tandai Baca'),
                    onPressed: () {
                      ref.read(lastReadProvider.notifier).saveLastRead(
                            surahNomor: surah.nomor,
                            surahNamaLatin: surah.namaLatin,
                            ayatNomor: ayat.nomorAyat,
                          );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ditandai terakhir dibaca ayat ${ayat.nomorAyat}')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // BottomSheet Tafsir Kemenag RI
  void _showTafsirBottomSheet(
    BuildContext context,
    int surahNomor,
    String surahNamaLatin,
    int ayatNomor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                      // Drag handle
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

class MushafRuledLinesPainter extends CustomPainter {
  final double lineHeight;
  final Color lineColor;

  MushafRuledLinesPainter({
    required this.lineHeight,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Gambar garis-garis penuntun horizontal (Mushaf Bergaris Standar Indonesia)
    for (double y = lineHeight; y < size.height; y += lineHeight) {
      canvas.drawLine(Offset(6, y), Offset(size.width - 6, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant MushafRuledLinesPainter oldDelegate) =>
      oldDelegate.lineHeight != lineHeight || oldDelegate.lineColor != lineColor;
}

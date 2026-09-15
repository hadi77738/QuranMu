import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/surah.dart';
import '../models/surah_detail.dart';
import '../models/tafsir_ayat.dart';
import '../models/ayat.dart';
import '../models/juz.dart';
import '../data/juz_data.dart';

enum ReadingMode {
  translation, // Mode Ayat + Terjemahan
  mushaf,      // Mode Mushaf Arab Murni
}

class QuranService {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  List<Surah>? _cachedSurahs;
  final Map<int, SurahDetail> _cachedDetails = {};
  final Map<int, List<TafsirAyat>> _cachedTafsirs = {};

  Future<List<Surah>> getAllSurah() async {
    if (_cachedSurahs != null && _cachedSurahs!.isNotEmpty) {
      return _cachedSurahs!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/json/surah_list.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> surahJsonList = data['data'] as List<dynamic>;

      _cachedSurahs = surahJsonList
          .map((item) => Surah.fromJson(item as Map<String, dynamic>))
          .toList();

      return _cachedSurahs!;
    } catch (e) {
      return [];
    }
  }

  Future<Surah?> getSurahByNomor(int nomor) async {
    final list = await getAllSurah();
    try {
      return list.firstWhere((s) => s.nomor == nomor);
    } catch (_) {
      return null;
    }
  }

  Future<SurahDetail> getSurahDetail(int nomor) async {
    if (_cachedDetails.containsKey(nomor)) {
      return _cachedDetails[nomor]!;
    }

    // 1. Coba baca dari bundle asset (surah yang dipre-bundle)
    try {
      final assetString = await rootBundle.loadString('assets/json/surah/$nomor.json');
      final Map<String, dynamic> json = jsonDecode(assetString);
      final detail = SurahDetail.fromJson(json['data'] as Map<String, dynamic>);
      _cachedDetails[nomor] = detail;
      return detail;
    } catch (_) {
      // Tidak ada di bundle aset, lanjut ke cache disk lokal
    }

    // 2. Coba baca dari cache file perangkat lokal
    File? cacheFile;
    try {
      final dir = await getApplicationDocumentsDirectory();
      cacheFile = File('${dir.path}/quran_surah_$nomor.json');
      if (await cacheFile.exists()) {
        final content = await cacheFile.readAsString();
        final Map<String, dynamic> json = jsonDecode(content);
        final detail = SurahDetail.fromJson(json['data'] as Map<String, dynamic>);
        _cachedDetails[nomor] = detail;
        return detail;
      }
    } catch (_) {
      // Gagal baca cache lokal
    }

    // 3. Ambil dari remote API dan simpan ke file lokal untuk offline
    try {
      final response = await _dio.get('https://equran.id/api/v2/surat/$nomor');
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data is String
            ? jsonDecode(response.data as String)
            : response.data as Map<String, dynamic>;

        final detail = SurahDetail.fromJson(responseData['data'] as Map<String, dynamic>);
        _cachedDetails[nomor] = detail;

        // Simpan ke disk secara async agar berikutnya offline-ready
        if (cacheFile != null) {
          cacheFile.writeAsString(jsonEncode(responseData)).catchError((_) => cacheFile!);
        }

        return detail;
      }
    } catch (e) {
      throw Exception('Gagal memuat Surah $nomor: Pastikan perangkat terhubung ke internet.');
    }

    throw Exception('Data surah tidak ditemukan');
  }

  Future<List<TafsirAyat>> getSurahTafsir(int nomor) async {
    if (_cachedTafsirs.containsKey(nomor)) {
      return _cachedTafsirs[nomor]!;
    }

    // Cek cache lokal
    File? cacheFile;
    try {
      final dir = await getApplicationDocumentsDirectory();
      cacheFile = File('${dir.path}/quran_tafsir_$nomor.json');
      if (await cacheFile.exists()) {
        final content = await cacheFile.readAsString();
        final Map<String, dynamic> json = jsonDecode(content);
        final rawTafsir = json['data']['tafsir'] as List<dynamic>;
        final tafsirList = rawTafsir
            .map((item) => TafsirAyat.fromJson(item as Map<String, dynamic>))
            .toList();
        _cachedTafsirs[nomor] = tafsirList;
        return tafsirList;
      }
    } catch (_) {}

    // Fetch dari API
    try {
      final response = await _dio.get('https://equran.id/api/v2/tafsir/$nomor');
      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data is String
            ? jsonDecode(response.data as String)
            : response.data as Map<String, dynamic>;

        final rawTafsir = responseData['data']['tafsir'] as List<dynamic>;
        final tafsirList = rawTafsir
            .map((item) => TafsirAyat.fromJson(item as Map<String, dynamic>))
            .toList();

        _cachedTafsirs[nomor] = tafsirList;
        if (cacheFile != null) {
          cacheFile.writeAsString(jsonEncode(responseData)).catchError((_) => cacheFile!);
        }
        return tafsirList;
      }
    } catch (e) {
      throw Exception('Gagal memuat tafsir surah $nomor');
    }

    return [];
  }

  Future<JuzDetail> getJuzDetail(int juzNomor) async {
    final juz = allJuzList.firstWhere(
      (j) => j.nomor == juzNomor,
      orElse: () => allJuzList.first,
    );

    final surahFutures = <Future<SurahDetail>>[];
    for (int surahNum = juz.startSurahNomor; surahNum <= juz.endSurahNomor; surahNum++) {
      surahFutures.add(getSurahDetail(surahNum));
    }
    final surahDetails = await Future.wait(surahFutures);

    final List<JuzSection> sections = [];
    for (int i = 0; i < surahDetails.length; i++) {
      final surahDetail = surahDetails[i];
      final surahNum = juz.startSurahNomor + i;

      int fromAyat = 1;
      int toAyat = surahDetail.jumlahAyat;
      bool isStartOfSurah = true;
      bool isEndOfSurah = true;

      if (surahNum == juz.startSurahNomor) {
        fromAyat = juz.startAyat;
        if (fromAyat > 1) {
          isStartOfSurah = false;
        }
      }

      if (surahNum == juz.endSurahNomor) {
        toAyat = juz.endAyat;
        if (toAyat < surahDetail.jumlahAyat) {
          isEndOfSurah = false;
        }
      }

      final filtered = surahDetail.ayatList
          .where((a) => a.nomorAyat >= fromAyat && a.nomorAyat <= toAyat)
          .toList();

      if (filtered.isNotEmpty) {
        sections.add(JuzSection(
          surah: surahDetail,
          ayatList: filtered,
          isStartOfSurah: isStartOfSurah,
          isEndOfSurah: isEndOfSurah,
        ));
      }
    }

    return JuzDetail(juz: juz, sections: sections);
  }
}

class JuzSection {
  final SurahDetail surah;
  final List<Ayat> ayatList;
  final bool isStartOfSurah;
  final bool isEndOfSurah;

  const JuzSection({
    required this.surah,
    required this.ayatList,
    required this.isStartOfSurah,
    required this.isEndOfSurah,
  });
}

class JuzDetail {
  final Juz juz;
  final List<JuzSection> sections;

  const JuzDetail({
    required this.juz,
    required this.sections,
  });

  int get totalAyat => sections.fold<int>(0, (sum, sec) => sum + sec.ayatList.length);
}

// Service Provider
final quranServiceProvider = Provider<QuranService>((ref) {
  return QuranService();
});

// FutureProvider untuk memuat seluruh 114 Surah
final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final service = ref.watch(quranServiceProvider);
  return service.getAllSurah();
});

// FutureProvider Family untuk Detail Surah
final surahDetailProvider =
    FutureProvider.family<SurahDetail, int>((ref, nomor) async {
  final service = ref.watch(quranServiceProvider);
  return service.getSurahDetail(nomor);
});

// FutureProvider Family untuk Tafsir Surah
final surahTafsirProvider =
    FutureProvider.family<List<TafsirAyat>, int>((ref, nomor) async {
  final service = ref.watch(quranServiceProvider);
  return service.getSurahTafsir(nomor);
});

// FutureProvider Family untuk Detail Juz (memuat seluruh surah & ayat dalam Juz)
final juzDetailProvider =
    FutureProvider.family<JuzDetail, int>((ref, juzNomor) async {
  final service = ref.watch(quranServiceProvider);
  return service.getJuzDetail(juzNomor);
});

// Notifier Mode Baca (Terjemahan vs Mushaf Murni)
class ReadingModeNotifier extends Notifier<ReadingMode> {
  @override
  ReadingMode build() => ReadingMode.translation;

  void toggleMode() {
    state = state == ReadingMode.translation
        ? ReadingMode.mushaf
        : ReadingMode.translation;
  }

  void setMode(ReadingMode mode) => state = mode;
}

final readingModeProvider =
    NotifierProvider<ReadingModeNotifier, ReadingMode>(ReadingModeNotifier.new);

// NotifierProvider pencarian surah
class SurahSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

final surahSearchQueryProvider =
    NotifierProvider<SurahSearchNotifier, String>(SurahSearchNotifier.new);

// Provider daftar surah yang telah terfilter sesuai query pencarian
final filteredSurahListProvider = Provider<AsyncValue<List<Surah>>>((ref) {
  final query = ref.watch(surahSearchQueryProvider).trim().toLowerCase();
  final asyncSurahs = ref.watch(surahListProvider);

  return asyncSurahs.whenData((surahs) {
    if (query.isEmpty) return surahs;
    return surahs.where((surah) {
      final matchNomor = surah.nomor.toString() == query;
      final matchLatin = surah.namaLatin.toLowerCase().contains(query);
      final matchArti = surah.arti.toLowerCase().contains(query);
      final matchTempat = surah.tempatTurun.toLowerCase().contains(query);
      return matchNomor || matchLatin || matchArti || matchTempat;
    }).toList();
  });
});

// Notifier Terakhir Dibaca (Last Read) dengan penyimpanan SharedPreferences
class LastReadState {
  final int surahNomor;
  final String surahNamaLatin;
  final int ayatNomor;

  const LastReadState({
    required this.surahNomor,
    required this.surahNamaLatin,
    required this.ayatNomor,
  });
}

class LastReadNotifier extends Notifier<LastReadState?> {
  @override
  LastReadState? build() {
    _loadFromPrefs();
    return null;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final no = prefs.getInt('last_read_surah');
    final name = prefs.getString('last_read_name');
    final ayat = prefs.getInt('last_read_ayat');

    if (no != null && name != null && ayat != null) {
      state = LastReadState(surahNomor: no, surahNamaLatin: name, ayatNomor: ayat);
    }
  }

  Future<void> saveLastRead({
    required int surahNomor,
    required String surahNamaLatin,
    required int ayatNomor,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_read_surah', surahNomor);
    await prefs.setString('last_read_name', surahNamaLatin);
    await prefs.setInt('last_read_ayat', ayatNomor);

    state = LastReadState(
      surahNomor: surahNomor,
      surahNamaLatin: surahNamaLatin,
      ayatNomor: ayatNomor,
    );
  }
}

final lastReadProvider =
    NotifierProvider<LastReadNotifier, LastReadState?>(LastReadNotifier.new);

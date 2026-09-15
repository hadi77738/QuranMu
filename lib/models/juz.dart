class Juz {
  final int nomor;
  final String namaArabic;
  final String startSurah;
  final int startSurahNomor;
  final int startAyat;
  final String endSurah;
  final int endSurahNomor;
  final int endAyat;

  const Juz({
    required this.nomor,
    required this.namaArabic,
    required this.startSurah,
    required this.startSurahNomor,
    required this.startAyat,
    required this.endSurah,
    required this.endSurahNomor,
    required this.endAyat,
  });

  String get rangeDescription => '$startSurah: $startAyat - $endSurah: $endAyat';
}

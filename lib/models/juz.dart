class Juz {
  final int nomor;
  final String namaArabic;
  final String startSurah;
  final int startAyat;
  final String endSurah;
  final int endAyat;

  const Juz({
    required this.nomor,
    required this.namaArabic,
    required this.startSurah,
    required this.startAyat,
    required this.endSurah,
    required this.endAyat,
  });

  String get rangeDescription => '$startSurah: $startAyat - $endSurah: $endAyat';
}

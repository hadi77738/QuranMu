class TafsirAyat {
  final int ayat;
  final String teks;

  const TafsirAyat({
    required this.ayat,
    required this.teks,
  });

  factory TafsirAyat.fromJson(Map<String, dynamic> json) {
    return TafsirAyat(
      ayat: json['ayat'] as int? ?? 1,
      teks: json['teks'] as String? ?? '',
    );
  }
}

class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;
  final Map<String, String>? audio;

  const Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
    this.audio,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    Map<String, String>? audioMap;
    if (json['audio'] != null && json['audio'] is Map) {
      audioMap = (json['audio'] as Map).map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }

    return Ayat(
      nomorAyat: json['nomorAyat'] as int? ?? 1,
      teksArab: json['teksArab'] as String? ?? '',
      teksLatin: json['teksLatin'] as String? ?? '',
      teksIndonesia: json['teksIndonesia'] as String? ?? '',
      audio: audioMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomorAyat': nomorAyat,
      'teksArab': teksArab,
      'teksLatin': teksLatin,
      'teksIndonesia': teksIndonesia,
      'audio': audio,
    };
  }
}

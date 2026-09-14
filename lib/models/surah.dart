class Surah {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String>? audioFull;

  const Surah({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    this.audioFull,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    Map<String, String>? audioMap;
    if (json['audioFull'] != null && json['audioFull'] is Map) {
      audioMap = (json['audioFull'] as Map).map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }

    return Surah(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String? ?? '',
      namaLatin: json['namaLatin'] as String? ?? '',
      jumlahAyat: json['jumlahAyat'] as int? ?? 0,
      tempatTurun: json['tempatTurun'] as String? ?? 'Mekah',
      arti: json['arti'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      audioFull: audioMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomor': nomor,
      'nama': nama,
      'namaLatin': namaLatin,
      'jumlahAyat': jumlahAyat,
      'tempatTurun': tempatTurun,
      'arti': arti,
      'deskripsi': deskripsi,
      'audioFull': audioFull,
    };
  }
}

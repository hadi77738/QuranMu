import 'ayat.dart';

class SurahDetail {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final Map<String, String>? audioFull;
  final List<Ayat> ayatList;
  final dynamic suratSebelumnya;
  final dynamic suratSelanjutnya;

  const SurahDetail({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    this.audioFull,
    required this.ayatList,
    this.suratSebelumnya,
    this.suratSelanjutnya,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    Map<String, String>? audioMap;
    if (json['audioFull'] != null && json['audioFull'] is Map) {
      audioMap = (json['audioFull'] as Map).map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    }

    final rawAyat = json['ayat'] as List<dynamic>? ?? [];
    final ayats = rawAyat
        .map((item) => Ayat.fromJson(item as Map<String, dynamic>))
        .toList();

    return SurahDetail(
      nomor: json['nomor'] as int,
      nama: json['nama'] as String? ?? '',
      namaLatin: json['namaLatin'] as String? ?? '',
      jumlahAyat: json['jumlahAyat'] as int? ?? 0,
      tempatTurun: json['tempatTurun'] as String? ?? 'Mekah',
      arti: json['arti'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      audioFull: audioMap,
      ayatList: ayats,
      suratSebelumnya: json['suratSebelumnya'],
      suratSelanjutnya: json['suratSelanjutnya'],
    );
  }
}

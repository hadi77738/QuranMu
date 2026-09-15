class DoaItem {
  final int id;
  final String judul;
  final String kategori;
  final String teksArab;
  final String teksLatin;
  final String arti;
  final String riwayat;
  final int? count;
  final int? urutan;

  const DoaItem({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.teksArab,
    required this.teksLatin,
    required this.arti,
    required this.riwayat,
    this.count,
    this.urutan,
  });
}

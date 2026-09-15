import 'package:flutter_test/flutter_test.dart';
import 'package:quranmu/services/quran_service.dart';

void main() {
  test('Test getJuzDetail(1) has both Al-Fatihah and Al-Baqarah', () async {
    final service = QuranService();
    final detail = await service.getJuzDetail(1);

    expect(detail.juz.nomor, 1);
    expect(detail.sections.length, 2);

    // Section 1: Al-Fatihah 1-7
    expect(detail.sections[0].surah.nomor, 1);
    expect(detail.sections[0].ayatList.first.nomorAyat, 1);
    expect(detail.sections[0].ayatList.last.nomorAyat, 7);
    expect(detail.sections[0].ayatList.length, 7);

    // Section 2: Al-Baqarah 1-141
    expect(detail.sections[1].surah.nomor, 2);
    expect(detail.sections[1].ayatList.first.nomorAyat, 1);
    expect(detail.sections[1].ayatList.last.nomorAyat, 141);
    expect(detail.sections[1].ayatList.length, 141);

    expect(detail.totalAyat, 148);
  });

  test('Test getJuzDetail(2) starts mid-surah at Al-Baqarah 142', () async {
    final service = QuranService();
    final detail = await service.getJuzDetail(2);

    expect(detail.juz.nomor, 2);
    expect(detail.sections.length, 1);
    expect(detail.sections[0].surah.nomor, 2);
    expect(detail.sections[0].ayatList.first.nomorAyat, 142);
    expect(detail.sections[0].ayatList.last.nomorAyat, 252);
    expect(detail.sections[0].isStartOfSurah, false);
    expect(detail.sections[0].isEndOfSurah, false);
  });
}

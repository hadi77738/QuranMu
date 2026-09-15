import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quranmu/main.dart';
import 'package:quranmu/pages/quran_page.dart';
import 'package:quranmu/pages/surah_detail_page.dart';
import 'package:quranmu/pages/qibla_page.dart';
import 'package:quranmu/pages/settings_page.dart';
import 'package:quranmu/pages/doa_page.dart';
import 'package:quranmu/pages/tahlil_page.dart';
import 'package:quranmu/pages/juz_detail_page.dart';
import 'package:quranmu/data/juz_data.dart';
import 'package:quranmu/data/doa_data.dart';
import 'package:quranmu/services/prayer_service.dart';

void main() {
  testWidgets('QuranMu app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: QuranMuApp(),
      ),
    );

    expect(find.text('QuranMu'), findsOneWidget);
  });

  testWidgets('QuranPage displays Surah and Juz tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: QuranPage(),
        ),
      ),
    );

    expect(find.text('Al-Qur\'an'), findsOneWidget);
    expect(find.text('Surah (114)'), findsOneWidget);
    expect(find.text('Juz (30)'), findsOneWidget);
  });

  testWidgets('SurahDetailPage renders for Al-Fatihah', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SurahDetailPage(surahNomor: 1),
        ),
      ),
    );

    // Initial pump shows loader or title
    await tester.pump();
    expect(find.byType(SurahDetailPage), findsOneWidget);
  });

  test('PrayerService calculates astronomical times and Qibla bearing', () {
    final now = DateTime(2026, 9, 14, 12, 0);
    // Jakarta coordinates
    final service = PrayerService();
    final data = service.getPrayerTimes(
      date: now,
      latitude: -6.2088,
      longitude: 106.8456,
      locationName: 'Jakarta',
    );

    expect(data.locationName, 'Jakarta');
    expect(data.subuh.hour, 4);
    expect(data.dzuhur.hour, 11);
    expect(data.ashar.hour, 15);
    expect(data.maghrib.hour, 17);
    expect(data.isya.hour, 19);

    final qibla = service.calculateQibla(-6.2088, 106.8456);
    // Qibla bearing from Jakarta is approx 295°
    expect(qibla, greaterThan(290));
    expect(qibla, lessThan(300));
  });

  testWidgets('QiblaPage renders compass dial and calibration status', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: QiblaPage(),
        ),
      ),
    );

    expect(find.text('Arah Kiblat'), findsOneWidget);
    expect(find.text('Sudut Derajat Kiblat Ka\'bah'), findsOneWidget);
  });

  testWidgets('SettingsPage renders font sliders and notification controls', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );

    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Tampilan Baca Al-Qur\'an'), findsOneWidget);
    expect(find.text('Ukuran Font Arab'), findsOneWidget);
    expect(find.text('Ukuran Font Terjemahan'), findsOneWidget);
    expect(find.text('Qari Murottal Default'), findsOneWidget);

    // Scroll ke bawah untuk melihat seksi notifikasi & adzan
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Pilihan Nada / Gaya Adzan'), findsOneWidget);
    expect(find.text('Adzan Makkah (Merdu & Syahdu)'), findsOneWidget);
  });

  testWidgets('DoaPage renders prayer categories and search bar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DoaPage(),
        ),
      ),
    );

    expect(find.text('Doa & Dzikir Harian'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Semua'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Harian'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Ibadah'), findsOneWidget);
    expect(find.text('Doa Bangun Tidur'), findsOneWidget);
  });

  testWidgets('SurahDetailPage renders orientation toggle button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SurahDetailPage(surahNomor: 1),
        ),
      ),
    );

    await tester.pump();
    expect(find.byTooltip('Mode Lanskap'), findsOneWidget);
    expect(find.byTooltip('Ganti ke Mode Mushaf'), findsOneWidget);
  });

  testWidgets('JuzDetailPage renders for Juz 1', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: JuzDetailPage(juzNomor: 1),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(JuzDetailPage), findsOneWidget);
  });

  test('All 30 Juz coverage and surah range integrity', () {
    expect(allJuzList.length, 30);
    expect(allJuzList.first.startSurahNomor, 1);
    expect(allJuzList.first.startAyat, 1);
    expect(allJuzList.last.endSurahNomor, 114);
    expect(allJuzList.last.endAyat, 6);

    for (int i = 0; i < allJuzList.length; i++) {
      final juz = allJuzList[i];
      expect(juz.nomor, i + 1);
      expect(juz.startSurahNomor, lessThanOrEqualTo(juz.endSurahNomor));
      expect(juz.startAyat, greaterThanOrEqualTo(1));
      expect(juz.endAyat, greaterThanOrEqualTo(1));
    }
  });

  test('Doa Setelah Sholat and 17 Tahlil items integrity', () {
    final doaSholat = DoaData.doaSetelahSholat;
    expect(doaSholat.judul, 'Doa Setelah Selesai Sholat Fardhu');
    expect(doaSholat.kategori, 'Setelah Sholat');
    expect(doaSholat.teksArab, contains('اَلْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِيْنَ'));

    final listTahlil = DoaData.listTahlil;
    expect(listTahlil.length, 17);
    expect(listTahlil.first.urutan, 1);
    expect(listTahlil.first.judul, contains('Tawasul'));
    expect(listTahlil.last.urutan, 17);
    expect(listTahlil.last.judul, contains('Penutup'));

    // Check Doa Arwah is at #16
    final doaArwah = listTahlil[15];
    expect(doaArwah.urutan, 16);
    expect(doaArwah.judul, contains('Doa Tahlil'));
    expect(doaArwah.teksArab, contains('ثُمَّ إِلَى أَرْوَاحِ جَمِيْعِ أَهْلِ الْقُبُوْرِ'));
  });

  testWidgets('TahlilPage renders and operates digital tasbih counter', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TahlilPage(),
      ),
    );

    expect(find.text('Susunan Bacaan Tahlil'), findsOneWidget);
    expect(find.text('Urutan 1 dari 17'), findsOneWidget);
    expect(find.text('1. Pengantar Al-Fatihah (Tawasul)'), findsOneWidget);

    // Tap next to step 2 (Al-Fatihah)
    await tester.tap(find.text('Langkah Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Urutan 2 dari 17'), findsOneWidget);

    // Tap next to step 3 (Al-Ikhlas 3x)
    await tester.tap(find.text('Langkah Lanjut'));
    await tester.pumpAndSettle();
    expect(find.text('Urutan 3 dari 17'), findsOneWidget);
    expect(find.text('Dibaca 3x'), findsWidgets);

    // Digital tasbih counter button exists
    expect(find.text('Ketuk Penghitung: 0 / 3'), findsOneWidget);
    await tester.tap(find.text('Ketuk Penghitung: 0 / 3'));
    await tester.pumpAndSettle();
    expect(find.text('Ketuk Penghitung: 1 / 3'), findsOneWidget);
  });
}



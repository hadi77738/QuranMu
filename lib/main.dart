import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/main_layout.dart';
import 'pages/home_page.dart';
import 'pages/quran_page.dart';
import 'pages/settings_page.dart';
import 'pages/surah_detail_page.dart';
import 'pages/qibla_page.dart';
import 'pages/doa_page.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    await NotificationService().init();
  } catch (_) {
    // Graceful fallback if platform notifications are unsupported (e.g. desktop/test)
  }

  runApp(
    const ProviderScope(
      child: QuranMuApp(),
    ),
  );
}

// Konfigurasi GoRouter
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/quran',
          builder: (context, state) => const QuranPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = int.tryParse(state.pathParameters['id'] ?? '1') ?? 1;
                return SurahDetailPage(surahNomor: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/qibla',
          builder: (context, state) => const QiblaPage(),
        ),
        GoRoute(
          path: '/doa',
          builder: (context, state) => const DoaPage(),
        ),
      ],
    ),
  ],
);

class QuranMuApp extends StatelessWidget {
  const QuranMuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QuranMu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Default light, nanti bisa dikontrol lewat Riverpod settings
      routerConfig: _router,
    );
  }
}

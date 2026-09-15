import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

import '../components/mini_audio_player.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final bool isSubPage = location.startsWith('/quran/') || location.startsWith('/juz/') || location == '/qibla' || location == '/doa';
    final bool isMainTab = location == '/quran' || location == '/settings';
    final selectedIndex = _calculateSelectedIndex(context);

    return PopScope(
      canPop: !isMainTab,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isMainTab) {
          context.go('/');
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: isSubPage
            ? const SafeArea(
                top: false,
                child: MiniAudioPlayer(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniAudioPlayer(),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: AppColors.cardBorderLight, width: 1),
                      ),
                    ),
                    child: NavigationBar(
                      selectedIndex: selectedIndex,
                      onDestinationSelected: (int index) => _onItemTapped(index, context),
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home_rounded),
                          label: 'Beranda',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.menu_book_outlined),
                          selectedIcon: Icon(Icons.menu_book_rounded),
                          label: 'Al-Qur\'an',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings_rounded),
                          label: 'Pengaturan',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/quran')) {
      return 1;
    }
    if (location.startsWith('/settings')) {
      return 2;
    }
    return 0; // Default to Home
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/quran');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }
}

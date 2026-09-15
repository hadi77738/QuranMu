import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Emerald & Gold)
  static const Color primary = Color(0xFF095A46);
  static const Color primaryDark = Color(0xFF053B2E);
  static const Color primaryLight = Color(0xFF138064);
  static const Color primaryContainer = Color(0xFFE2F3ED);
  static const Color onPrimaryContainer = Color(0xFF033529);

  static const Color secondary = Color(0xFFD69E3D);
  static const Color secondaryLight = Color(0xFFFFF3D6);
  static const Color onSecondary = Color(0xFF3B2A05);

  // Background & Surface Colors
  static const Color backgroundLight = Color(0xFFF6F8F7);
  static const Color surfaceLight = Colors.white;
  static const Color cardBorderLight = Color(0xFFE7ECE9);

  static const Color backgroundDark = Color(0xFF0B1412);
  static const Color surfaceDark = Color(0xFF13201C);
  static const Color cardBorderDark = Color(0xFF1E322C);

  // Text colors (Light)
  static const Color textPrimaryLight = Color(0xFF1B2A26);
  static const Color textSecondaryLight = Color(0xFF5E736C);
  static const Color textMutedLight = Color(0xFF8FA39D);

  // Text colors (Dark)
  static const Color textPrimaryDark = Color(0xFFECEFF1);
  static const Color textSecondaryDark = Color(0xFF90A4AE);
  static const Color textMutedDark = Color(0xFF607D8B);

  // Backward compatibility constants (default light values)
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textMuted = textMutedLight;

  // Ruled line in mushaf mode
  static const Color mushafLineLight = Color(0xFFE6DDC8);
  static const Color mushafLineDark = Color(0xFF223832);

  // Arabic text
  static const Color arabicTextLight = Color(0xFF1B2A26);
  static const Color arabicTextDark = Color(0xFFECEFF1);

  // Dynamic Theme Helpers
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color surface(BuildContext context) =>
      isDark(context) ? surfaceDark : surfaceLight;

  static Color background(BuildContext context) =>
      isDark(context) ? backgroundDark : backgroundLight;

  static Color cardBorder(BuildContext context) =>
      isDark(context) ? cardBorderDark : cardBorderLight;

  static Color text(BuildContext context) =>
      isDark(context) ? textPrimaryDark : textPrimaryLight;

  static Color subText(BuildContext context) =>
      isDark(context) ? textSecondaryDark : textSecondaryLight;

  static Color mutedText(BuildContext context) =>
      isDark(context) ? textMutedDark : textMutedLight;

  static Color mushafLine(BuildContext context) =>
      isDark(context) ? mushafLineDark : mushafLineLight;

  static Color arabic(BuildContext context) =>
      isDark(context) ? arabicTextDark : arabicTextLight;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryLight,
        surface: AppColors.surfaceLight,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerColor: AppColors.cardBorderLight,
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorderLight,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primaryContainer,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 24);
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: const Color(0xFF10B981),
        onPrimary: const Color(0xFF052E22),
        primaryContainer: const Color(0xFF0D4738),
        onPrimaryContainer: const Color(0xFFA7F3D0),
        secondary: const Color(0xFFFFD54F),
        secondaryContainer: const Color(0xFF4A3800),
        onSecondaryContainer: const Color(0xFFFFECB3),
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: const Color(0xFF1E322C),
        outline: const Color(0xFF2E4B42),
        outlineVariant: AppColors.cardBorderDark,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: Color(0xFF10B981)),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerColor: AppColors.cardBorderDark,
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorderDark,
        thickness: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        indicatorColor: const Color(0xFF0D4738),
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF10B981),
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMutedDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF10B981), size: 24);
          }
          return const IconThemeData(color: AppColors.textMutedDark, size: 24);
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

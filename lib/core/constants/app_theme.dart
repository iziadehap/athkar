import 'package:flutter/material.dart';

class AppTheme {
  // ============ COLORS ============
  // Surface Colors
  static const Color surface = Color(0xFF0C1324);
  static const Color surfaceDim = Color(0xFF0C1324);
  static const Color surfaceBright = Color(0xFF33394C);
  static const Color surfaceContainerLowest = Color(0xFF070D1F);
  static const Color surfaceContainerLow = Color(0xFF151B2D);
  static const Color surfaceContainer = Color(0xFF191F31);
  static const Color surfaceContainerHigh = Color(0xFF23293C);
  static const Color surfaceContainerHighest = Color(0xFF2E3447);

  // On-Surface Colors
  static const Color onSurface = Color(0xFFDCE1FB);
  static const Color onSurfaceVariant = Color(0xFFBFC9C3);
  static const Color inverseSurface = Color(0xFFDCE1FB);
  static const Color inverseOnSurface = Color(0xFF2A3043);

  // Outline Colors
  static const Color outline = Color(0xFF89938D);
  static const Color outlineVariant = Color(0xFF404944);
  static const Color surfaceTint = Color(0xFF95D3BA);

  // Primary Colors (Emerald)
  static const Color primary = Color(0xFF95D3BA);
  static const Color onPrimary = Color(0xFF003829);
  static const Color primaryContainer = Color(0xFF064E3B);
  static const Color onPrimaryContainer = Color(0xFF80BEA6);
  static const Color inversePrimary = Color(0xFF2B6954);

  // Primary Fixed Colors
  static const Color primaryFixed = Color(0xFFB0F0D6);
  static const Color primaryFixedDim = Color(0xFF95D3BA);
  static const Color onPrimaryFixed = Color(0xFF002117);
  static const Color onPrimaryFixedVariant = Color(0xFF0B513D);

  // Secondary Colors (Sand Beige)
  static const Color secondary = Color(0xFFC8C8B0);
  static const Color onSecondary = Color(0xFF303221);
  static const Color secondaryContainer = Color(0xFF494A38);
  static const Color onSecondaryContainer = Color(0xFFB9BAA3);

  // Secondary Fixed Colors
  static const Color secondaryFixed = Color(0xFFE4E4CC);
  static const Color secondaryFixedDim = Color(0xFFC8C8B0);
  static const Color onSecondaryFixed = Color(0xFF1B1D0E);
  static const Color onSecondaryFixedVariant = Color(0xFF474836);

  // Tertiary Colors (Gold)
  static const Color tertiary = Color(0xFFE9C349);
  static const Color onTertiary = Color(0xFF3C2F00);
  static const Color tertiaryContainer = Color(0xFFCCA72F);
  static const Color onTertiaryContainer = Color(0xFF4E3D00);

  // Tertiary Fixed Colors
  static const Color tertiaryFixed = Color(0xFFFFE088);
  static const Color tertiaryFixedDim = Color(0xFFE9C349);
  static const Color onTertiaryFixed = Color(0xFF241A00);
  static const Color onTertiaryFixedVariant = Color(0xFF574500);

  // Error Colors
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // Background Colors
  static const Color background = Color(0xFF0C1324);
  static const Color onBackground = Color(0xFFDCE1FB);
  static const Color surfaceVariant = Color(0xFF2E3447);

  // ============ GLASSMORPHISM HELPERS ============
  static Color get glassBackground =>
      surfaceContainerLow.withValues(alpha: 0.4);
  static const Color glassBorder = Color(0x1AF5F5DC); // Sand Beige at 10%
  static const Color glowColor = Color(0x33064E3B); // Primary container at 20%

  // ============ TYPOGRAPHY ============
  // Arabic Typography
  // static const String fontAmiri = 'Amiri';
  // static const String fontNotoNaskhArabic = 'Noto Naskh Arabic';
  // static const String fontInter = 'Inter';

  // Text Styles
  static const TextStyle displayArabic = TextStyle(
    // fontFamily: fontAmiri,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 64 / 48, // 1.333
    color: onSurface,
  );

  static TextStyle headlineLg = const TextStyle(
    // fontFamily: fontInter,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32, // 1.25
    letterSpacing: -0.02,
    color: onSurface,
  );

  static TextStyle headlineLgMobile = const TextStyle(
    // fontFamily: fontInter,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24, // 1.333
    color: onSurface,
  );

  static TextStyle titleMd = const TextStyle(
    // fontFamily: fontInter,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 28 / 18, // 1.556
    color: onSurface,
  );

  static TextStyle bodyLg = const TextStyle(
    // fontFamily: fontInter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16, // 1.5
    color: onSurface,
  );

  static TextStyle bodyArabic = const TextStyle(
    // fontFamily: fontNotoNaskhArabic,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 36 / 22, // 1.636
    color: onSurface,
  );

  static TextStyle labelSm = const TextStyle(
    // fontFamily: fontInter,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12, // 1.333
    letterSpacing: 0.05,
    color: onSurface,
  );

  // ============ SPACING ============
  static const double spacingBase = 8;
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  static const double containerPadding = 24;
  static const double gutter = 16;
  static const double touchTargetMin = 56;
  static const double sectionGap = 48;

  // ============ ROUNDED ============
  static const double roundedSm = 4; // 0.25rem
  static const double roundedDefault = 8; // 0.5rem
  static const double roundedMd = 12; // 0.75rem
  static const double roundedLg = 16; // 1rem
  static const double roundedXl = 24; // 1.5rem
  static const double roundedFull = 9999;

  // ============ ELEVATION & DEPTH ============
  static BoxDecoration get glassContainer => BoxDecoration(
        color: glassBackground,
        borderRadius: BorderRadius.circular(roundedLg),
        border: Border.all(color: glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get glassContainerWithBlur => BoxDecoration(
        color: glassBackground,
        borderRadius: BorderRadius.circular(roundedLg),
        border: Border.all(color: glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get primaryGlow => BoxDecoration(
        color: glowColor,
        borderRadius: BorderRadius.circular(roundedFull),
      );

  // ============ THEME DATA ============
  static ThemeData get lightThemeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F0),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2B6954),
        onPrimary: Colors.white,
        primaryContainer: Color(0xFFB0F0D6),
        secondary: Color(0xFF494A38),
        surface: Color(0xFFF5F5F0),
        onSurface: Color(0xFF1A1F2E),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: inverseSurface,
        // inverseOnSurface: inverseOnSurface,
      ),

      // Typography
      textTheme: TextTheme(
        displayLarge: displayArabic,
        headlineLarge: headlineLg,
        headlineMedium: headlineLgMobile,
        titleMedium: titleMd,
        bodyLarge: bodyLg,
        bodyMedium: bodyArabic,
        labelSmall: labelSm,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLow,
        border: UnderlineInputBorder(
          borderSide: const BorderSide(color: secondary),
          borderRadius: BorderRadius.circular(roundedSm),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: onSurfaceVariant),
          borderRadius: BorderRadius.circular(roundedSm),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: primary, width: 2),
          borderRadius: BorderRadius.circular(roundedSm),
        ),
        labelStyle: const TextStyle(color: onSurfaceVariant),
        hintStyle: const TextStyle(color: onSurfaceVariant),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundedDefault),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          minimumSize: const Size(0, touchTargetMin),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          side: const BorderSide(color: outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(roundedDefault),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          minimumSize: const Size(0, touchTargetMin),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(touchTargetMin, touchTargetMin),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: onSurface),
        titleTextStyle: headlineLgMobile,
      ),
    );
  }

  // ============ UTILITY EXTENSIONS ============
  // Extension for easy access to theme colors in BuildContext
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  static Color getSurfaceVariantColor(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }
}

// ============ THEME EXTENSION FOR EASIER ACCESS ============
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;

  // Custom colors from our design system
  Color get surfaceLow => AppTheme.surfaceContainerLow;
  Color get surfaceHigh => AppTheme.surfaceContainerHigh;
  Color get primaryColor => AppTheme.primary;
  Color get secondaryColor => AppTheme.secondary;
  Color get tertiaryColor => AppTheme.tertiary;
  Color get onSurfaceColor => AppTheme.onSurface;
  Color get onSurfaceVariantColor => AppTheme.onSurfaceVariant;

  // Spacing shortcuts
  double get spacingXs => AppTheme.spacingXs;
  double get spacingSm => AppTheme.spacingSm;
  double get spacingMd => AppTheme.spacingMd;
  double get spacingLg => AppTheme.spacingLg;
  double get spacingXl => AppTheme.spacingXl;
  double get spacingXxl => AppTheme.spacingXxl;
}

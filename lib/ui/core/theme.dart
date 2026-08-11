import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class CreaturelyColors {
  static const Color vitalTeal = Color(0xFF087E78);
  static const Color deepTeal = Color(0xFF075D59);
  static const Color teal600 = Color(0xFF096B66);
  static const Color freshMint = Color(0xFF77D6CE);
  static const Color softMint = Color(0xFFCFEDEA);

  static const Color heartCoral = Color(0xFFF26B5B);
  static const Color blush = Color(0xFFFFF1ED);

  static const Color softInk = Color(0xFF19302F);
  static const Color quietSlate = Color(0xFF5D706F);
  static const Color mistBorder = Color(0xFFD7E3E1);
  static const Color cloudCanvas = Color(0xFFF7FBFA);
  static const Color white = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF237A4B);
  static const Color warning = Color(0xFF8A5A00);
  static const Color error = Color(0xFFB64145);
  static const Color information = Color(0xFF2E6FA3);

  static const Color darkBackground = Color(0xFF102523);
  static const Color darkSurface = Color(0xFF17312F);
  static const Color darkOnPrimary = Color(0xFF0B2D2A);
  static const Color darkText = Color(0xFFEAF4F2);
  static const Color darkMutedText = Color(0xFFB8CAC7);
  static const Color darkBorder = Color(0xFF607A76);
  static const Color darkAccent = Color(0xFFFF9B8B);
  static const Color darkOnAccent = Color(0xFF3D1210);
}

abstract final class CreaturelySpacing {
  static const double xSmall = 4;
  static const double small = 8;
  static const double medium = 16;
  static const double large = 24;
  static const double xLarge = 32;
  static const double maxContentWidth = 960;
  static const double maxFormWidth = 680;
  static const double minTouchTarget = 48;
}

abstract final class CreaturelyRadii {
  static const double small = 8;
  static const double standard = 14;
  static const double feature = 24;
}

class CreaturelyTheme {
  const CreaturelyTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = isDark ? _darkScheme : _lightScheme;
    final typography = Typography.material2021(
      platform: defaultTargetPlatform,
      colorScheme: scheme,
    );
    final baseTextTheme = isDark ? typography.white : typography.black;
    final textTheme = baseTextTheme
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface)
        .copyWith(
          displayLarge: baseTextTheme.displayLarge?.copyWith(
            color: scheme.onSurface,
            fontSize: 40,
            height: 1.15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
          headlineLarge: baseTextTheme.headlineLarge?.copyWith(
            color: scheme.onSurface,
            fontSize: 32,
            height: 1.2,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
          headlineMedium: baseTextTheme.headlineMedium?.copyWith(
            color: scheme.onSurface,
            fontSize: 24,
            height: 1.25,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleLarge: baseTextTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
            fontSize: 20,
            height: 1.3,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: baseTextTheme.titleMedium?.copyWith(
            color: scheme.onSurface,
            fontSize: 16,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: baseTextTheme.bodyLarge?.copyWith(
            color: scheme.onSurface,
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: baseTextTheme.bodyMedium?.copyWith(
            color: scheme.onSurface,
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: baseTextTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
            fontSize: 12,
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
          labelLarge: baseTextTheme.labelLarge?.copyWith(
            color: scheme.onSurface,
            fontSize: 14,
            height: 1.4,
            fontWeight: FontWeight.w600,
          ),
        );
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      shadowColor: scheme.shadow,
      scaffoldBackgroundColor: isDark
          ? CreaturelyColors.darkBackground
          : CreaturelyColors.cloudCanvas,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        color: isDark ? CreaturelyColors.darkSurface : CreaturelyColors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: scheme.shadow,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? CreaturelyColors.darkSurface : CreaturelyColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          elevation: 1,
          shadowColor: scheme.shadow,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: controlShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(color: scheme.outlineVariant, width: 1.2),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: controlShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, CreaturelySpacing.minTouchTarget),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: controlShape,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            CreaturelySpacing.minTouchTarget,
            CreaturelySpacing.minTouchTarget,
          ),
          shape: controlShape,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: isDark ? CreaturelyColors.darkSurface : CreaturelyColors.white,
        indicatorColor: scheme.primaryContainer,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CreaturelyRadii.standard),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isDark ? CreaturelyColors.darkSurface : CreaturelyColors.white,
        indicatorColor: scheme.primaryContainer,
        useIndicator: true,
        minWidth: 88,
        labelType: NavigationRailLabelType.all,
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      listTileTheme: ListTileThemeData(iconColor: scheme.onSurfaceVariant),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? CreaturelyColors.darkSurface : CreaturelyColors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CreaturelyRadii.feature)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? CreaturelyColors.darkSurface : CreaturelyColors.white,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(CreaturelyRadii.feature)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 3,
        highlightElevation: 1,
        shape: controlShape,
      ),
      snackBarTheme: SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: controlShape),
      visualDensity: VisualDensity.standard,
    );
  }

  static final ColorScheme _lightScheme =
      ColorScheme.fromSeed(
        seedColor: CreaturelyColors.vitalTeal,
        brightness: Brightness.light,
        contrastLevel: 0.15,
      ).copyWith(
        primary: CreaturelyColors.vitalTeal,
        onPrimary: CreaturelyColors.white,
        primaryContainer: CreaturelyColors.softMint,
        onPrimaryContainer: CreaturelyColors.softInk,
        secondary: CreaturelyColors.heartCoral,
        onSecondary: CreaturelyColors.softInk,
        secondaryContainer: CreaturelyColors.blush,
        onSecondaryContainer: CreaturelyColors.softInk,
        tertiary: CreaturelyColors.information,
        onTertiary: CreaturelyColors.white,
        tertiaryContainer: CreaturelyColors.softMint,
        onTertiaryContainer: CreaturelyColors.softInk,
        error: CreaturelyColors.error,
        onError: CreaturelyColors.white,
        errorContainer: CreaturelyColors.blush,
        onErrorContainer: CreaturelyColors.error,
        surface: CreaturelyColors.cloudCanvas,
        onSurface: CreaturelyColors.softInk,
        surfaceContainerLowest: CreaturelyColors.white,
        surfaceContainerLow: CreaturelyColors.white,
        surfaceContainer: CreaturelyColors.cloudCanvas,
        surfaceContainerHigh: CreaturelyColors.softMint,
        surfaceContainerHighest: CreaturelyColors.softMint,
        onSurfaceVariant: CreaturelyColors.quietSlate,
        outline: CreaturelyColors.quietSlate,
        outlineVariant: CreaturelyColors.mistBorder,
        shadow: CreaturelyColors.softInk.withValues(alpha: 0.18),
        scrim: Colors.black.withValues(alpha: 0.48),
        inverseSurface: CreaturelyColors.softInk,
        onInverseSurface: CreaturelyColors.darkText,
        inversePrimary: CreaturelyColors.freshMint,
        surfaceTint: CreaturelyColors.vitalTeal,
      );

  static final ColorScheme _darkScheme =
      ColorScheme.fromSeed(
        seedColor: CreaturelyColors.freshMint,
        brightness: Brightness.dark,
        contrastLevel: 0.15,
      ).copyWith(
        primary: CreaturelyColors.freshMint,
        onPrimary: CreaturelyColors.darkOnPrimary,
        primaryContainer: CreaturelyColors.teal600,
        onPrimaryContainer: CreaturelyColors.darkText,
        secondary: CreaturelyColors.darkAccent,
        onSecondary: CreaturelyColors.darkOnAccent,
        secondaryContainer: CreaturelyColors.deepTeal,
        onSecondaryContainer: CreaturelyColors.darkText,
        tertiary: CreaturelyColors.information,
        onTertiary: CreaturelyColors.white,
        tertiaryContainer: CreaturelyColors.deepTeal,
        onTertiaryContainer: CreaturelyColors.darkText,
        error: CreaturelyColors.error,
        onError: CreaturelyColors.white,
        errorContainer: CreaturelyColors.softInk,
        onErrorContainer: CreaturelyColors.darkText,
        surface: CreaturelyColors.darkBackground,
        onSurface: CreaturelyColors.darkText,
        surfaceContainerLowest: CreaturelyColors.darkBackground,
        surfaceContainerLow: CreaturelyColors.darkSurface,
        surfaceContainer: CreaturelyColors.darkSurface,
        surfaceContainerHigh: CreaturelyColors.deepTeal,
        surfaceContainerHighest: CreaturelyColors.deepTeal,
        onSurfaceVariant: CreaturelyColors.darkMutedText,
        outline: CreaturelyColors.darkBorder,
        outlineVariant: CreaturelyColors.darkBorder.withValues(alpha: 0.58),
        shadow: Colors.black.withValues(alpha: 0.52),
        scrim: Colors.black.withValues(alpha: 0.72),
        inverseSurface: CreaturelyColors.darkText,
        onInverseSurface: CreaturelyColors.softInk,
        inversePrimary: CreaturelyColors.vitalTeal,
        surfaceTint: CreaturelyColors.freshMint,
      );
}

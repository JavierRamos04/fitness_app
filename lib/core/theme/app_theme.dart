import 'package:flutter/material.dart';

/// Identidad visual de la app: carbón con matiz verde y un lima eléctrico como
/// acento. Todos los colores y estilos base viven aquí; las pantallas deben
/// tomarlos del tema (`Theme.of(context)`) y no usar valores sueltos.
///
/// Tipografía: Barlow (texto) y Barlow Condensed (títulos y cifras), incluidas
/// como archivos en `assets/fonts`, así que funcionan sin internet.
class AppTheme {
  const AppTheme._();

  /// Familia para texto corrido, etiquetas y botones.
  static const String bodyFont = 'Barlow';

  /// Familia condensada para títulos y cifras destacadas.
  static const String displayFont = 'BarlowCondensed';

  /// Lima de acción: relleno de botones, selección y elementos activos.
  /// Es el mismo en ambos temas; siempre lleva texto oscuro encima.
  static const Color lime = Color(0xFF7CF542);

  /// Texto e iconos sobre [lime].
  static const Color onLime = Color(0xFF0B1607);

  static ThemeData lightTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: lime,
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFF2B7510),
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFDDF4C9),
      onPrimaryContainer: const Color(0xFF1A4208),
      secondary: const Color(0xFF4F6A3F),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE4EBDC),
      onSecondaryContainer: const Color(0xFF1E2A18),
      tertiary: const Color(0xFF80560F),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFFBE7B9),
      onTertiaryContainer: const Color(0xFF3B2800),
      error: const Color(0xFFB3303A),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFDADB),
      onErrorContainer: const Color(0xFF410006),
      surface: const Color(0xFFF2F5EE),
      onSurface: const Color(0xFF141A12),
      onSurfaceVariant: const Color(0xFF4A5645),
      surfaceDim: const Color(0xFFE2E8DB),
      surfaceBright: const Color(0xFFFFFFFF),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFF8FAF5),
      surfaceContainer: const Color(0xFFEDF2E7),
      surfaceContainerHigh: const Color(0xFFE4EBDC),
      surfaceContainerHighest: const Color(0xFFD9E3D0),
      outline: const Color(0xFF5E6A58),
      outlineVariant: const Color(0xFFD3DDC9),
      inverseSurface: const Color(0xFF1E2A1B),
      onInverseSurface: const Color(0xFFEAF2E2),
      inversePrimary: lime,
      surfaceTint: Colors.transparent,
    );

    return _build(
      scheme,
      cardColor: scheme.surfaceContainerLowest,
      snackColor: scheme.inverseSurface,
      snackTextColor: scheme.onInverseSurface,
    );
  }

  static ThemeData darkTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: lime,
      brightness: Brightness.dark,
    ).copyWith(
      primary: lime,
      onPrimary: onLime,
      primaryContainer: const Color(0xFF20381A),
      onPrimaryContainer: const Color(0xFFA5F77A),
      secondary: const Color(0xFFB6C7A9),
      onSecondary: const Color(0xFF10190C),
      secondaryContainer: const Color(0xFF2A3328),
      onSecondaryContainer: const Color(0xFFE3EEDA),
      tertiary: const Color(0xFFF4C66A),
      onTertiary: const Color(0xFF2B1F00),
      tertiaryContainer: const Color(0xFF3A2E0E),
      onTertiaryContainer: const Color(0xFFFFE3A3),
      error: const Color(0xFFFF7A80),
      onError: const Color(0xFF3A0508),
      errorContainer: const Color(0xFF4A1519),
      onErrorContainer: const Color(0xFFFFD9DB),
      surface: const Color(0xFF0A0D09),
      onSurface: const Color(0xFFF1F5EC),
      onSurfaceVariant: const Color(0xFFAAB5A2),
      surfaceDim: const Color(0xFF080A07),
      surfaceBright: const Color(0xFF2A3328),
      surfaceContainerLowest: const Color(0xFF070906),
      surfaceContainerLow: const Color(0xFF121711),
      surfaceContainer: const Color(0xFF1A2119),
      surfaceContainerHigh: const Color(0xFF222A20),
      surfaceContainerHighest: const Color(0xFF2A3328),
      outline: const Color(0xFF8A9582),
      outlineVariant: const Color(0xFF313B2E),
      inverseSurface: const Color(0xFFE8F0E0),
      onInverseSurface: const Color(0xFF141A12),
      inversePrimary: const Color(0xFF2B7510),
      surfaceTint: Colors.transparent,
    );

    return _build(
      scheme,
      cardColor: scheme.surfaceContainer,
      snackColor: scheme.surfaceContainerHighest,
      snackTextColor: scheme.onSurface,
    );
  }

  static ThemeData _build(
    ColorScheme scheme, {
    required Color cardColor,
    required Color snackColor,
    required Color snackTextColor,
  }) {
    final base = ThemeData(
      brightness: scheme.brightness,
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: bodyFont,
    );

    final text = base.textTheme;

    // Títulos y cifras en la familia condensada; el resto en Barlow.
    TextStyle? display(TextStyle? style, double size) {
      return style?.copyWith(
        fontFamily: displayFont,
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        height: 1.1,
      );
    }

    TextStyle? body(
      TextStyle? style,
      double size, {
      FontWeight weight = FontWeight.w400,
    }) {
      return style?.copyWith(
        fontFamily: bodyFont,
        fontSize: size,
        fontWeight: weight,
        letterSpacing: 0,
      );
    }

    final textTheme = text.copyWith(
      displayLarge: display(text.displayLarge, 56),
      displayMedium: display(text.displayMedium, 46),
      displaySmall: display(text.displaySmall, 38),
      headlineLarge: display(text.headlineLarge, 36),
      headlineMedium: display(text.headlineMedium, 32),
      headlineSmall: display(text.headlineSmall, 28),
      titleLarge: display(text.titleLarge, 26),
      titleMedium: body(text.titleMedium, 18, weight: FontWeight.w600),
      titleSmall: body(text.titleSmall, 15, weight: FontWeight.w600),
      bodyLarge: body(text.bodyLarge, 17),
      bodyMedium: body(text.bodyMedium, 15.5),
      bodySmall: body(text.bodySmall, 13.5),
      labelLarge: body(text.labelLarge, 15, weight: FontWeight.w600),
      labelMedium: body(text.labelMedium, 13, weight: FontWeight.w600),
      labelSmall: body(text.labelSmall, 12, weight: FontWeight.w600),
    );

    RoundedRectangleBorder rounded(double radius) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      );
    }

    const buttonText = TextStyle(
      fontFamily: bodyFont,
      fontSize: 16.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    );

    OutlineInputBorder inputBorder(Color color, [double width = 0]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: width == 0
            ? BorderSide.none
            : BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      brightness: scheme.brightness,
      colorScheme: scheme,
      useMaterial3: true,
      fontFamily: bodyFont,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          color: scheme.onSurface,
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: rounded(20),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lime,
          foregroundColor: onLime,
          disabledBackgroundColor: scheme.surfaceContainerHigh,
          disabledForegroundColor:
              scheme.onSurfaceVariant.withValues(alpha: 0.5),
          minimumSize: const Size(64, 52),
          shape: rounded(16),
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
          minimumSize: const Size(64, 52),
          shape: rounded(16),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(48, 44),
          shape: rounded(12),
          textStyle: buttonText.copyWith(fontSize: 15.5),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: lime,
        foregroundColor: onLime,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: rounded(18),
        extendedTextStyle: buttonText,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: inputBorder(scheme.outline),
        enabledBorder: inputBorder(scheme.outline),
        focusedBorder: inputBorder(scheme.primary, 1.6),
        errorBorder: inputBorder(scheme.error, 1.2),
        focusedErrorBorder: inputBorder(scheme.error, 1.6),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.outline),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primaryContainer,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        checkmarkColor: scheme.primary,
        labelStyle: TextStyle(
          fontFamily: bodyFont,
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: rounded(24),
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          color: scheme.onSurface,
          fontSize: 26,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(
          fontFamily: bodyFont,
          color: scheme.onSurface,
          fontSize: 15.5,
          height: 1.35,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        modalBackgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: snackColor,
        contentTextStyle: TextStyle(
          fontFamily: bodyFont,
          color: snackTextColor,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        shape: rounded(14),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        linearMinHeight: 8,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? onLime
              : scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? lime
              : scheme.surfaceContainerHighest;
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: rounded(16),
        collapsedShape: rounded(16),
        iconColor: scheme.primary,
        collapsedIconColor: scheme.onSurfaceVariant,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        shape: rounded(14),
        textStyle: TextStyle(
          fontFamily: bodyFont,
          color: scheme.onSurface,
          fontSize: 15.5,
        ),
      ),
    );
  }
}

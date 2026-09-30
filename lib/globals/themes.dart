import 'package:flutter/material.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Inter',
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0F8A5F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD1F4E3),
    onPrimaryContainer: Color(0xFF003822),
    secondary: Color(0xFF4A5D6E),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFDCE4EC),
    onSecondaryContainer: Color(0xFF111D27),
    tertiary: Color(0xFFBA6900),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDDB8),
    onTertiaryContainer: Color(0xFF2B1700),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF6F8FA),
    onSurface: Color(0xFF181C20),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF1F4F6),
    surfaceContainer: Color(0xFFEBEFF2),
    surfaceContainerHigh: Color(0xFFE5E9ED),
    surfaceContainerHighest: Color(0xFFDFE3E7),
    onSurfaceVariant: Color(0xFF4C5862),
    outline: Color(0xFFCCD4DC),
    outlineVariant: Color(0xFFE1E6EB),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF2D3135),
    onInverseSurface: Color(0xFFEFF1F5),
    inversePrimary: Color(0xFF67DBA2),
  ),
  scaffoldBackgroundColor: const Color(0xFFF6F8FA),
  cardTheme: CardThemeData(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFE1E6EB), width: 1),
    ),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF181C20),
    centerTitle: false,
  ),
  textTheme: const TextTheme(),
);

@NowaGenerated()
final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(),
  textTheme: const TextTheme(),
);

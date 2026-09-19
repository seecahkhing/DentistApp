import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final class AppTheme {
  static const Color teal = Color(0xFF0F766E);
  static const Color cream = Color(0xFFF7F6F3);
  static const Color ink = Color(0xFF1C1B19);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
      surface: cream,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: cream,
      appBarTheme: const AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ink,
          letterSpacing: -0.4,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: teal, width: 1.5),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}

String formatMoney(double? value) {
  if (value == null) return '—';
  return NumberFormat.simpleCurrency().format(value);
}

String formatDate(DateTime value) => DateFormat.yMMMEd().format(value);

String formatTime(DateTime value) => DateFormat.jm().format(value);

String formatDateTime(DateTime value) =>
    DateFormat.yMMMd().add_jm().format(value);

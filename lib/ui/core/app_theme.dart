import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/models/booking.dart';

final class AppTheme {
  static const Color teal = Color(0xFF0D9488);
  static const Color tealDark = Color(0xFF0F766E);
  static const Color surface = Color(0xFFFAFAF9);
  static const Color ink = Color(0xFF18181B);
  static const Color muted = Color(0xFF71717A);
  static const Color cancelled = Color(0xFFDC2626);
  static const Color cancelledSurface = Color(0xFFFEF2F2);

  static Color accentForStatus(BookingStatus status) {
    return switch (status) {
      BookingStatus.cancelled => cancelled,
      BookingStatus.completed => const Color(0xFF64748B),
      BookingStatus.confirmed => teal,
      BookingStatus.scheduled => const Color(0xFF0369A1),
    };
  }

  static ({Color background, Color foreground}) chipColorsForStatus(
    BookingStatus status,
  ) {
    final accent = accentForStatus(status);
    return (
      background: accent.withValues(alpha: 0.12),
      foreground: accent,
    );
  }

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: teal,
      brightness: Brightness.light,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: ink,
          letterSpacing: -0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.black.withValues(alpha: 0.06),
        space: 1,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: teal,
        foregroundColor: Colors.white,
        elevation: 0,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

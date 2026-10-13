import 'package:flutter/material.dart';

/// Centralised colour palette for the whole app.
///
/// Using `static const` values keeps every colour reference `const`-compatible,
/// which lets the compiler reuse widget instances instead of rebuilding them.
abstract final class AppColors {
  static const Color primary = Color(0xFF6C4CF1);
  static const Color primaryDark = Color(0xFF4A2FD1);
  static const Color primaryLight = Color(0xFFE9E3FF);

  static const Color accent = Color(0xFFFF6584);
  static const Color accentLight = Color(0xFFFFE7EC);

  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFFFB020);
  static const Color star = Color(0xFFFFC107);

  static const Color background = Color(0xFFF6F6FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF0F0F7);

  static const Color textPrimary = Color(0xFF1E1B39);
  static const Color textSecondary = Color(0xFF8A8AA3);
  static const Color divider = Color(0xFFEDEDF3);

  static const Color shadow = Color(0x14000000);
}

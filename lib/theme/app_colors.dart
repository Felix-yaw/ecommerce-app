import 'package:flutter/material.dart';

/// Luxury, Dribbble-inspired modern design system tokens.
///
/// Combines high-contrast editorial typography, deep obsidian darks,
/// soft card backdrops, glowing accents and frosted-glass tints.
abstract final class AppColors {
  // Brand identity
  static const Color primary = Color(0xFF121217); // Obsidian / Deep Carbon
  static const Color primaryDark = Color(0xFF090A0C);
  static const Color primaryLight = Color(0xFFF0F1F5);

  // Vibrant Pop Accents (Dribbble signature)
  static const Color accent = Color(0xFFFF5238); // Electric Sunset Tangerine
  static const Color accentLight = Color(0xFFFFEFEB);
  static const Color violet = Color(0xFF6366F1); // Neo Violet
  static const Color violetLight = Color(0xFFEEF0FF);
  static const Color emerald = Color(0xFF10B981); // Mint / In Stock
  static const Color emeraldLight = Color(0xFFE8FDF3);

  // Status indicators
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color star = Color(0xFFFFB800);

  // Canvas & Surfaces
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF0F2F6);
  static const Color surfaceMuted = Color(0xFFF2F4F8);

  // Typography
  static const Color textPrimary = Color(0xFF111218);
  static const Color textSecondary = Color(0xFF717588);
  static const Color textTertiary = Color(0xFFA1A5B7);
  static const Color divider = Color(0xFFEBECEF);

  // Glassmorphic & Shadows
  static const Color glassWhite = Color(0xD8FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color cardBorder = Color(0x0F000000);

  // Preset box shadows for that floating Dribbble lift
  static const List<BoxShadow> softShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 18,
      offset: Offset(0, 6),
    ),
    BoxShadow(
      color: Color(0x04000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> floatingShadow = <BoxShadow>[
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 30,
      offset: Offset(0, 14),
    ),
    BoxShadow(
      color: Color(0x06000000),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];

  static const List<BoxShadow> glowAccent = <BoxShadow>[
    BoxShadow(
      color: Color(0x40FF5238),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> glowPrimary = <BoxShadow>[
    BoxShadow(
      color: Color(0x33121217),
      blurRadius: 24,
      offset: Offset(0, 10),
    ),
  ];
}

import 'package:flutter/material.dart';

/// Data for a single promotional slide shown in the home carousel.
@immutable
class PromoBanner {
  const PromoBanner({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.icon,
  });

  final String tag;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final IconData icon;
}

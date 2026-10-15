import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Small bold heading used to label a group of content.
///
/// Shared by the checkout and product-detail screens so their section titles
/// stay visually identical.
class GroupHeading extends StatelessWidget {
  const GroupHeading(this.text, {super.key, this.fontSize = 16});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Round, filled icon button used for compact row and overlay actions.
///
/// Consolidates the near-identical circle buttons previously duplicated across
/// the wishlist and product-detail screens.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.textPrimary,
    this.background = AppColors.surface,
    this.size = 42,
    this.iconSize = 19,
    this.tooltip,
    this.elevated = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color background;
  final double size;
  final double iconSize;
  final String? tooltip;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final Widget button = Material(
      color: background,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );

    final Widget decorated = elevated
        ? DecoratedBox(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: AppColors.softShadow,
            ),
            child: button,
          )
        : button;

    if (tooltip == null) return decorated;
    return Tooltip(message: tooltip!, child: decorated);
  }
}

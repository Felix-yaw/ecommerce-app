import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Circular +/- control used by [QuantityStepper].
class StepButton extends StatelessWidget {
  const StepButton({
    super.key,
    required this.icon,
    required this.dimension,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final double dimension;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.primary : AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: dimension,
          height: dimension,
          child: Icon(
            icon,
            size: 18,
            color: filled ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

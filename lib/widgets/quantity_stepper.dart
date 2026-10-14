import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Sleek pill-shaped quantity stepper with circular controls.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double dimension = compact ? 32 : 42;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _StepButton(
            icon: Icons.remove_rounded,
            dimension: dimension,
            onTap: onDecrement,
          ),
          SizedBox(
            width: compact ? 36 : 46,
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyle(
                  fontSize: compact ? 14 : 17,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            dimension: dimension,
            onTap: onIncrement,
            filled: true,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
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

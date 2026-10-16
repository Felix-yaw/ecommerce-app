import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'step_button.dart';

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
          StepButton(
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
          StepButton(
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

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Tactile floating "+" button that pops an item into the cart.
class QuickAddButton extends StatefulWidget {
  const QuickAddButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<QuickAddButton> createState() => _QuickAddButtonState();
}

class _QuickAddButtonState extends State<QuickAddButton> {
  double _scale = 1.0;

  void _handleTapDown(TapDownDetails _) {
    setState(() => _scale = 0.85);
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Color(0x2A000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 19),
        ),
      ),
    );
  }
}

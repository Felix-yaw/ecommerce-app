import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Celebration banner shown once the cart qualifies for free shipping.
class FreeShippingBanner extends StatelessWidget {
  const FreeShippingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emeraldLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: <Widget>[
          Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'You have unlocked free shipping!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.emerald,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

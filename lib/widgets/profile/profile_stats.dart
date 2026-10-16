import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'stat_divider.dart';
import 'stat_item.dart';

/// Row of account statistics (orders, saved items, cart count).
class ProfileStats extends StatelessWidget {
  const ProfileStats({
    super.key,
    required this.orders,
    required this.saved,
    required this.inBag,
  });

  final int orders;
  final int saved;
  final int inBag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: AppColors.softShadow,
      ),
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        children: <Widget>[
          StatItem(value: '$orders', label: 'Orders'),
          const StatDivider(),
          StatItem(value: '$saved', label: 'Saved'),
          const StatDivider(),
          StatItem(value: '$inBag', label: 'In bag'),
        ],
      ),
    );
  }
}

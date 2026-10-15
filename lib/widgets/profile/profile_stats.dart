import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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
          _StatItem(value: '$orders', label: 'Orders'),
          const _StatDivider(),
          _StatItem(value: '$saved', label: 'Saved'),
          const _StatDivider(),
          _StatItem(value: '$inBag', label: 'In bag'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 38, color: AppColors.divider);
  }
}

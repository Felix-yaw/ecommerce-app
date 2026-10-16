import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'profile_menu_item.dart';

/// One tappable row inside a [ProfileMenu].
class MenuTile extends StatelessWidget {
  const MenuTile({super.key, required this.item, required this.onTap});

  final ProfileMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(item.icon, size: 20, color: AppColors.textPrimary),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textTertiary,
      ),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'menu_tile.dart';
import 'profile_menu_item.dart';

/// Rounded card grouping a list of [ProfileMenuItem]s.
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<ProfileMenuItem> items;
  final ValueChanged<ProfileMenuItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: <Widget>[
            for (int i = 0; i < items.length; i++) ...<Widget>[
              MenuTile(item: items[i], onTap: () => onItemTap(items[i])),
              if (i != items.length - 1)
                const Divider(height: 1, indent: 68),
            ],
          ],
        ),
      ),
    );
  }
}

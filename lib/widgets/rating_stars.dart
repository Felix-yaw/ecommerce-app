import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Modern rating rendered as a single-star pill (Dribbble style).
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14,
    this.showValue = true,
    this.pill = false,
  });

  final double rating;
  final int? reviewCount;
  final double starSize;
  final bool showValue;
  final bool pill;

  @override
  Widget build(BuildContext context) {
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(Icons.star_rounded, size: starSize, color: AppColors.star),
        const SizedBox(width: 4),
        if (showValue)
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        if (reviewCount != null) ...<Widget>[
          const SizedBox(width: 3),
          Text(
            '($reviewCount)',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ],
    );

    if (!pill) return content;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );
  }
}

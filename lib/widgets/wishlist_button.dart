import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';

/// Tactile, spring-animated heart button that reads/writes the wishlist in [ShopState].
class WishlistButton extends StatefulWidget {
  const WishlistButton({
    super.key,
    required this.product,
    this.size = 36,
    this.iconSize = 18,
    this.background,
  });

  final Product product;
  final double size;
  final double iconSize;
  final Color? background;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();
}

class _WishlistButtonState extends State<WishlistButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  late final Animation<double> _scaleAnimation = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.35, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 20,
      ),
    ],
  ).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(bool active) {
    _controller.forward(from: 0.0);
    context.read<ShopState>().toggleWishlist(widget.product);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            active
                ? '${widget.product.name} removed from saved'
                : '${widget.product.name} saved to wishlist',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bool active = context.select<ShopState, bool>(
      (ShopState s) => s.isWishlisted(widget.product),
    );
    final Color bgColor = widget.background ??
        (active ? AppColors.accentLight : AppColors.surface.withValues(alpha: 0.9));

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _onTap(active),
            child: Center(
              child: Icon(
                active ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: widget.iconSize,
                color: active ? AppColors.accent : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

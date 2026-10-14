import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/product.dart';
import '../navigation/app_routes.dart';
import '../state/shop_scope.dart';
import '../theme/app_colors.dart';
import '../widgets/network_product_image.dart';
import '../widgets/price_text.dart';
import '../widgets/product_card.dart';
import '../widgets/quantity_stepper.dart';
import '../widgets/rating_stars.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';
import '../widgets/wishlist_button.dart';

/// Immersive full-bleed product page with animated variant selection
/// and a frosted floating action bar.
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  late Color? _selectedColor =
      widget.product.colors.isNotEmpty ? widget.product.colors.first : null;
  late String? _selectedSize = widget.product.sizes.isNotEmpty
      ? widget.product.sizes.first
      : null;

  Product get product => widget.product;

  bool get _needsColor => product.colors.isNotEmpty;
  bool get _needsSize => product.sizes.isNotEmpty;

  bool get _canAdd =>
      (!_needsColor || _selectedColor != null) &&
      (!_needsSize || _selectedSize != null);

  void _addToCart({bool goToCart = false}) {
    ShopScope.read(context).addToCart(
      product,
      quantity: _quantity,
      color: _selectedColor,
      size: _selectedSize,
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} added to bag'),
          action: SnackBarAction(
            label: 'View bag',
            textColor: AppColors.primaryLight,
            onPressed: () => AppRoutes.openCart(context),
          ),
        ),
      );
    if (goToCart) AppRoutes.openCart(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _ImageAppBar(product: product),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: _Details(
                product: product,
                quantity: _quantity,
                selectedColor: _selectedColor,
                selectedSize: _selectedSize,
                onQuantityChanged: (int q) => setState(() => _quantity = q),
                onColorSelected: (Color c) =>
                    setState(() => _selectedColor = c),
                onSizeSelected: (String s) =>
                    setState(() => _selectedSize = s),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _RelatedProducts(product: product)),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
      bottomNavigationBar: _AddToCartBar(
        product: product,
        enabled: _canAdd,
        onAdd: _addToCart,
      ),
    );
  }
}

class _ImageAppBar extends StatelessWidget {
  const _ImageAppBar({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 420,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: _GlassCircle(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: WishlistButton(
                product: product,
                size: 44,
                iconSize: 22,
                background: Colors.white,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ColoredBox(
          color: AppColors.surfaceSecondary,
          child: NetworkProductImage(
            url: product.imageUrl,
            width: MediaQuery.sizeOf(context).width,
            height: 420,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _GlassCircle extends StatelessWidget {
  const _GlassCircle({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.product,
    required this.quantity,
    required this.selectedColor,
    required this.selectedSize,
    required this.onQuantityChanged,
    required this.onColorSelected,
    required this.onSizeSelected,
  });

  final Product product;
  final int quantity;
  final Color? selectedColor;
  final String? selectedSize;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<Color> onColorSelected;
  final ValueChanged<String> onSizeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.brand.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (product.isFeatured)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'TRENDING',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            height: 1.18,
            letterSpacing: -0.8,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            RatingStars(
              rating: product.rating,
              reviewCount: product.reviewCount,
              pill: true,
            ),
            const Spacer(),
            if (product.freeShipping)
              const Row(
                children: <Widget>[
                  Icon(
                    Icons.local_shipping_outlined,
                    size: 16,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Free shipping',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 18),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: PriceText(
            product: product,
            priceSize: 28,
            showDiscountBadge: true,
          ),
        ),
        const SizedBox(height: 24),
        const _DetailHeading('Description'),
        const SizedBox(height: 10),
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 14.5,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
        if (product.colors.isNotEmpty) ...<Widget>[
          const SizedBox(height: 26),
          const _DetailHeading('Colour'),
          const SizedBox(height: 14),
          _ColorSelector(
            colors: product.colors,
            selected: selectedColor,
            onSelected: onColorSelected,
          ),
        ],
        if (product.sizes.isNotEmpty) ...<Widget>[
          const SizedBox(height: 26),
          const _DetailHeading('Size'),
          const SizedBox(height: 14),
          _SizeSelector(
            sizes: product.sizes,
            selected: selectedSize,
            onSelected: onSizeSelected,
          ),
        ],
        const SizedBox(height: 26),
        Row(
          children: <Widget>[
            const _DetailHeading('Quantity'),
            const Spacer(),
            QuantityStepper(
              quantity: quantity,
              onIncrement: () => onQuantityChanged(quantity + 1),
              onDecrement: () =>
                  onQuantityChanged(quantity > 1 ? quantity - 1 : 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailHeading extends StatelessWidget {
  const _DetailHeading(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final List<Color> colors;
  final Color? selected;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      children: <Widget>[
        for (final Color color in colors)
          GestureDetector(
            onTap: () => onSelected(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected == color
                      ? AppColors.primary
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: selected == color
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      )
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({
    required this.sizes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> sizes;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: <Widget>[
        for (final String size in sizes)
          GestureDetector(
            onTap: () => onSelected(size),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                color: selected == size
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected == size
                      ? AppColors.primary
                      : AppColors.divider,
                ),
              ),
              child: Text(
                size,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: selected == size
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.product,
    required this.enabled,
    required this.onAdd,
  });

  final Product product;
  final bool enabled;
  final void Function({bool goToCart}) onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: AppColors.floatingShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: enabled ? () => onAdd(goToCart: true) : null,
                  child: const Text('Buy now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: enabled ? () => onAdd() : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                  label: const Text('Add to bag'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelatedProducts extends StatelessWidget {
  const _RelatedProducts({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final List<Product> related = SampleData.products
        .where(
          (Product p) =>
              p.categoryId == product.categoryId && p.id != product.id,
        )
        .take(8)
        .toList(growable: false);

    if (related.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeader(
              title: 'You may also like',
              subtitle: 'Based on this product',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: related.length,
              itemBuilder: (BuildContext context, int index) {
                final Product p = related[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: SizedBox(
                    width: 190,
                    child: Reveal(
                      delay: Duration(milliseconds: 50 * index),
                      child: ProductCard(
                        product: p,
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => ProductDetailScreen(product: p),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
import '../widgets/section_header.dart';
import '../widgets/wishlist_button.dart';

/// Full product page with variant selection and add-to-cart actions.
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
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${product.name} added to cart'),
          action: SnackBarAction(
            label: 'View cart',
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _Details(
                product: product,
                quantity: _quantity,
                selectedColor: _selectedColor,
                selectedSize: _selectedSize,
                onQuantityChanged: (int q) => setState(() => _quantity = q),
                onColorSelected: (Color c) => setState(() => _selectedColor = c),
                onSizeSelected: (String s) => setState(() => _selectedSize = s),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 26)),
          SliverToBoxAdapter(child: _RelatedProducts(product: product)),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      bottomSheet: _AddToCartBar(
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
      expandedHeight: 360,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: _CircleAction(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: WishlistButton(product: product, size: 44, iconSize: 22),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: ColoredBox(
          color: AppColors.surfaceMuted,
          child: NetworkProductImage(
            url: product.imageUrl,
            width: MediaQuery.sizeOf(context).width,
            height: 360,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.textPrimary),
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
        Text(
          product.brand.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.2,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            RatingStars(rating: product.rating, reviewCount: product.reviewCount),
            const Spacer(),
            if (product.freeShipping)
              const Row(
                children: <Widget>[
                  Icon(Icons.local_shipping_outlined,
                      size: 16, color: AppColors.success),
                  SizedBox(width: 4),
                  Text(
                    'Free shipping',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 16),
        PriceText(product: product, priceSize: 26, showDiscountBadge: true),
        const SizedBox(height: 20),
        const _DetailHeading('Description'),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: const TextStyle(
            fontSize: 14,
            height: 1.55,
            color: AppColors.textSecondary,
          ),
        ),
        if (product.colors.isNotEmpty) ...<Widget>[
          const SizedBox(height: 22),
          const _DetailHeading('Colour'),
          const SizedBox(height: 12),
          _ColorSelector(
            colors: product.colors,
            selected: selectedColor,
            onSelected: onColorSelected,
          ),
        ],
        if (product.sizes.isNotEmpty) ...<Widget>[
          const SizedBox(height: 22),
          const _DetailHeading('Size'),
          const SizedBox(height: 12),
          _SizeSelector(
            sizes: product.sizes,
            selected: selectedSize,
            onSelected: onSizeSelected,
          ),
        ],
        const SizedBox(height: 22),
        Row(
          children: <Widget>[
            const _DetailHeading('Quantity'),
            const Spacer(),
            QuantityStepper(
              quantity: quantity,
              onIncrement: () => onQuantityChanged(quantity + 1),
              onDecrement: () => onQuantityChanged(
                quantity > 1 ? quantity - 1 : 1,
              ),
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
        fontSize: 15,
        fontWeight: FontWeight.w700,
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
      spacing: 12,
      children: <Widget>[
        for (final Color color in colors)
          GestureDetector(
            onTap: () => onSelected(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected == color
                      ? AppColors.primary
                      : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: selected == color
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 18)
                  : null,
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
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected == size
                    ? AppColors.primary
                    : AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                size,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
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
                child: FilledButton.icon(
                  onPressed: enabled ? () => onAdd() : null,
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                  label: const Text('Add to cart'),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(title: 'You may also like'),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: related.length,
            itemBuilder: (BuildContext context, int index) {
              final Product p = related[index];
              return Padding(
                padding: const EdgeInsets.only(right: 14),
                child: SizedBox(
                  width: 168,
                  child: ProductCard(
                    product: p,
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => ProductDetailScreen(product: p),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

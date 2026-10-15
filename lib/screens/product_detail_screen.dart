import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../navigation/app_routes.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/product_detail/add_to_cart_bar.dart';
import '../widgets/product_detail/product_details.dart';
import '../widgets/product_detail/product_image_app_bar.dart';
import '../widgets/product_detail/related_products.dart';

/// Immersive full-bleed product page. Composes the image header, details
/// block, related rail and the floating action bar.
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

  bool get _canAdd =>
      (product.colors.isEmpty || _selectedColor != null) &&
      (product.sizes.isEmpty || _selectedSize != null);

  void _addToCart({bool goToCart = false}) {
    context.read<ShopState>().addToCart(
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

  void _openRelated(Product related) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(product: related),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          ProductImageAppBar(product: product),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: ProductDetails(
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
          SliverToBoxAdapter(
            child: RelatedProducts(product: product, onSelect: _openRelated),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 140)),
        ],
      ),
      bottomNavigationBar: AddToCartBar(enabled: _canAdd, onAdd: _addToCart),
    );
  }
}

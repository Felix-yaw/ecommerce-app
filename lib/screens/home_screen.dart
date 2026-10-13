import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../navigation/app_routes.dart';
import '../state/shop_scope.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/badged_icon_button.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/section_header.dart';

/// The discovery/home tab: promo carousel, categories, featured rail and a
/// lazily-built product grid.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ShopState shop = ShopScope.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _HomeAppBar(shop: shop),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          const SliverToBoxAdapter(
            child: PromoCarousel(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 22)),
          SliverToBoxAdapter(child: _CategoryBar(shop: shop)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Featured',
                actionLabel: 'See all',
                onAction: () => AppRoutes.openCategory(context, 'all'),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          const SliverToBoxAdapter(child: _FeaturedRail()),
          const SliverToBoxAdapter(child: SizedBox(height: 26)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(title: 'Popular right now'),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          _PopularGrid(shop: shop),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
        ],
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar({required this.shop});

  final ShopState shop;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 150,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 20, bottom: 14),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Hello, Felix 👋',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Find your next favourite',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        BadgedIconButton(
          icon: Icons.shopping_bag_outlined,
          count: shop.cartCount,
          tooltip: 'Cart',
          onTap: () => AppRoutes.openCart(context),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.shop});

  final ShopState shop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: SampleData.categories.length,
        itemBuilder: (BuildContext context, int index) {
          final ProductCategory category = SampleData.categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CategoryChip(
              category: category,
              selected: shop.selectedCategoryId == category.id,
              onTap: () => shop.selectCategory(category.id),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedRail extends StatelessWidget {
  const _FeaturedRail();

  @override
  Widget build(BuildContext context) {
    final List<Product> featured = SampleData.featured;
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: featured.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = featured[index];
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: SizedBox(
              width: 168,
              child: ProductCard(
                product: product,
                onTap: () => AppRoutes.openProduct(context, product),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PopularGrid extends StatelessWidget {
  const _PopularGrid({required this.shop});

  final ShopState shop;

  @override
  Widget build(BuildContext context) {
    final List<Product> products = shop.filteredProducts;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.60,
        ),
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = products[index];
          return ProductCard(
            product: product,
            onTap: () => AppRoutes.openProduct(context, product),
          );
        },
      ),
    );
  }
}

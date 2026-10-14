import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/sample_data.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../navigation/app_routes.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/badged_icon_button.dart';
import '../widgets/category_chip.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/reveal.dart';
import '../widgets/section_header.dart';

/// The discovery/home tab — a luxury, editorial storefront feed.
///
/// This widget deliberately does **not** watch [ShopState]; each sub-section
/// subscribes to just the slice it needs via `context.select`, so a cart or
/// wishlist mutation never rebuilds the carousel, rails or the whole page.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const _HomeAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(child: PromoCarousel()),
          const SliverToBoxAdapter(child: SizedBox(height: 26)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Categories',
                subtitle: 'Browse by what you love',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          const SliverToBoxAdapter(child: _CategoryBar()),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Featured',
                subtitle: 'Handpicked this week',
                actionLabel: 'See all',
                onAction: () => AppRoutes.openCategory(context, 'all'),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const SliverToBoxAdapter(child: _FeaturedRail()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SectionHeader(
                title: 'Popular right now',
                subtitle: 'Trending across the store',
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          const _PopularGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    final int cartCount = context.select<ShopState, int>(
      (ShopState s) => s.cartCount,
    );

    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      title: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[AppColors.accent, AppColors.violet],
              ),
            ),
            child: const Center(
              child: Text(
                'FA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'GOOD MORNING',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.4,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Felix Azaglo',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        BadgedIconButton(
          icon: Icons.shopping_bag_outlined,
          count: cartCount,
          tooltip: 'Cart',
          onTap: () => AppRoutes.openCart(context),
        ),
        const SizedBox(width: 20),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(74),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () => AppRoutes.openSearch(context),
                  child: Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: AppColors.softShadow,
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(
                          Icons.search_rounded,
                          color: AppColors.textTertiary,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Search products, brands…',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar();

  @override
  Widget build(BuildContext context) {
    final String selectedId = context.select<ShopState, String>(
      (ShopState s) => s.selectedCategoryId,
    );

    return SizedBox(
      height: 46,
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
              selected: selectedId == category.id,
              onTap: () =>
                  context.read<ShopState>().selectCategory(category.id),
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
      height: 290,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: featured.length,
        itemBuilder: (BuildContext context, int index) {
          final Product product = featured[index];
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: SizedBox(
              width: 190,
              child: Reveal(
                key: ValueKey<String>(product.id),
                delay: Duration(milliseconds: 60 * index),
                child: ProductCard(
                  product: product,
                  onTap: () => AppRoutes.openProduct(context, product),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PopularGrid extends StatelessWidget {
  const _PopularGrid();

  @override
  Widget build(BuildContext context) {
    // Stable list instance → rebuilds only when the category changes.
    final List<Product> products = context.select<ShopState, List<Product>>(
      (ShopState s) => s.filteredProducts,
    );

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
          return Reveal(
            key: ValueKey<String>(product.id),
            delay: Duration(milliseconds: 40 * (index % 6)),
            child: ProductCard(
              product: product,
              onTap: () => AppRoutes.openProduct(context, product),
            ),
          );
        },
      ),
    );
  }
}

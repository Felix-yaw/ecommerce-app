import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import '../widgets/home/category_bar.dart';
import '../widgets/home/featured_rail.dart';
import '../widgets/home/home_app_bar.dart';
import '../widgets/home/popular_grid.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/section_header.dart';

/// The discovery/home tab — a luxury, editorial storefront feed.
///
/// This screen is a pure composition of feature widgets; each one subscribes
/// to just its slice of [ShopState], so a cart or wishlist change never
/// rebuilds the whole page.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          const HomeAppBar(),
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
          const SliverToBoxAdapter(child: CategoryBar()),
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
          const SliverToBoxAdapter(child: FeaturedRail()),
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
          const PopularGrid(),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Auto-advancing promotional banner carousel.
///
/// Each page is wrapped in a [RepaintBoundary] so the animated page indicator
/// and auto-scroll never force a repaint of the rest of the home screen.
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key, this.onBannerTap});

  final ValueChanged<PromoBanner>? onBannerTap;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  static const List<PromoBanner> _banners = <PromoBanner>[
    PromoBanner(
      tag: 'Mega Sale',
      title: 'Up to 50% off\nsneakers & apparel',
      colors: <Color>[Color(0xFF6C4CF1), Color(0xFF9E7BFF)],
      icon: Icons.local_offer_rounded,
    ),
    PromoBanner(
      tag: 'New Arrivals',
      title: 'Fresh tech just\nlanded this week',
      colors: <Color>[Color(0xFFFF6584), Color(0xFFFF9A64)],
      icon: Icons.new_releases_rounded,
    ),
    PromoBanner(
      tag: 'Free Shipping',
      title: 'On all orders\nover \$75',
      colors: <Color>[Color(0xFF2ECC71), Color(0xFF27A8A0)],
      icon: Icons.local_shipping_rounded,
    ),
  ];

  final PageController _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startAutoAdvance();
  }

  void _startAutoAdvance() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) return;
      final int next = (_currentPage + 1) % _banners.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 156,
          child: PageView.builder(
            controller: _controller,
            itemCount: _banners.length,
            onPageChanged: (int index) =>
                setState(() => _currentPage = index),
            itemBuilder: (BuildContext context, int index) {
              return RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _BannerCard(
                    banner: _banners[index],
                    onTap: () => widget.onBannerTap?.call(_banners[index]),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _PageDots(count: _banners.length, activeIndex: _currentPage),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner, required this.onTap});

  final PromoBanner banner;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: banner.colors,
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(22),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        banner.tag.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      banner.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(banner.icon, color: Colors.white, size: 38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == activeIndex ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? AppColors.primary
                  : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

/// Data for a single promotional slide.
@immutable
class PromoBanner {
  const PromoBanner({
    required this.tag,
    required this.title,
    required this.colors,
    required this.icon,
  });

  final String tag;
  final String title;
  final List<Color> colors;
  final IconData icon;
}

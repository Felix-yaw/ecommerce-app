import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Auto-advancing promotional banner carousel with fluid animations
/// and Dribbble-tier mesh gradient styling.
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({super.key, this.onBannerTap});

  final ValueChanged<PromoBanner>? onBannerTap;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  static const List<PromoBanner> _banners = <PromoBanner>[
    PromoBanner(
      tag: 'NEW COLLECTION 2026',
      title: 'Aura Sound & Minimal Audio',
      subtitle: 'Up to 40% off top-tier headphones',
      colors: <Color>[Color(0xFF1E1E28), Color(0xFF111117)],
      accentColor: AppColors.violet,
      icon: Icons.headphones_rounded,
    ),
    PromoBanner(
      tag: 'SEASON DROP',
      title: 'Hyper-Light Run Sneakers',
      subtitle: 'Engineered for street & track',
      colors: <Color>[Color(0xFFFF5238), Color(0xFFFF7A59)],
      accentColor: Colors.white,
      icon: Icons.bolt_rounded,
    ),
    PromoBanner(
      tag: 'FREE WORLDWIDE SHIP',
      title: 'Minimal Living Essentials',
      subtitle: 'Crafted ceramic & ambient lighting',
      colors: <Color>[Color(0xFF0F2B20), Color(0xFF104A35)],
      accentColor: AppColors.emerald,
      icon: Icons.local_shipping_rounded,
    ),
  ];

  final PageController _controller = PageController(viewportFraction: 0.90);
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
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeOutCubic,
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
          height: 178,
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
        const SizedBox(height: 14),
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: banner.colors,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
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
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          banner.tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        banner.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          height: 1.2,
                          letterSpacing: -0.4,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        banner.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(banner.icon, color: Colors.white, size: 30),
                ),
              ],
            ),
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
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == activeIndex ? 26 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == activeIndex
                  ? AppColors.primary
                  : AppColors.textTertiary.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }
}

@immutable
class PromoBanner {
  const PromoBanner({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.accentColor,
    required this.icon,
  });

  final String tag;
  final String title;
  final String subtitle;
  final List<Color> colors;
  final Color accentColor;
  final IconData icon;
}

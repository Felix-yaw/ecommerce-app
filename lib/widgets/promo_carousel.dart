import 'dart:async';

import 'package:flutter/material.dart';

import '../models/promo_banner.dart';
import 'home/page_dots.dart';
import 'home/promo_banner_card.dart';

/// Auto-advancing promotional banner carousel.
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
      icon: Icons.headphones_rounded,
    ),
    PromoBanner(
      tag: 'SEASON DROP',
      title: 'Hyper-Light Run Sneakers',
      subtitle: 'Engineered for street & track',
      colors: <Color>[Color(0xFFFF5238), Color(0xFFFF7A59)],
      icon: Icons.bolt_rounded,
    ),
    PromoBanner(
      tag: 'FREE WORLDWIDE SHIP',
      title: 'Minimal Living Essentials',
      subtitle: 'Crafted ceramic & ambient lighting',
      colors: <Color>[Color(0xFF0F2B20), Color(0xFF104A35)],
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
                  child: PromoBannerCard(
                    banner: _banners[index],
                    onTap: () => widget.onBannerTap?.call(_banners[index]),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        PageDots(count: _banners.length, activeIndex: _currentPage),
      ],
    );
  }
}

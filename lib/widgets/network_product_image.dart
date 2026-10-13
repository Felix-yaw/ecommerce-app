import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A network image that always decodes to the size the UI actually needs.
///
/// Passing [cacheWidth]/[cacheHeight] avoids keeping a full-resolution bitmap
/// in memory (or pass explicit caps for tiles that fill their parent). The
/// gradient placeholder keeps layout stable while loading and on error.
class NetworkProductImage extends StatelessWidget {
  const NetworkProductImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final double dpr = MediaQuery.devicePixelRatioOf(context);
    final int? decodedCacheWidth = cacheWidth ?? _cacheDimension(width, dpr);
    final int? decodedCacheHeight = cacheHeight ?? _cacheDimension(height, dpr);

    final Widget image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: decodedCacheWidth,
      cacheHeight: decodedCacheHeight,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? p) =>
          p == null ? child : _placeholder(),
      errorBuilder: (_, _, _) => _placeholder(),
    );

    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  static int? _cacheDimension(double? dimension, double dpr) {
    if (dimension == null || !dimension.isFinite) return null;
    return (dimension * dpr).round();
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primaryLight, AppColors.surfaceMuted],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}

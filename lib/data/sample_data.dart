import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_category.dart';

/// Static in-memory catalogue used by the prototype.
///
/// Keeping the data here (instead of fetching inside `build`) keeps the widget
/// tree pure and lets every list render lazily without extra work.
abstract final class SampleData {
  static const List<ProductCategory> categories = <ProductCategory>[
    ProductCategory(id: 'all', name: 'All', icon: Icons.apps_rounded),
    ProductCategory(id: 'electronics', name: 'Electronics', icon: Icons.devices_rounded),
    ProductCategory(id: 'fashion', name: 'Fashion', icon: Icons.checkroom_rounded),
    ProductCategory(id: 'footwear', name: 'Footwear', icon: Icons.roller_skating_rounded),
    ProductCategory(id: 'home', name: 'Home', icon: Icons.chair_rounded),
    ProductCategory(id: 'beauty', name: 'Beauty', icon: Icons.spa_rounded),
    ProductCategory(id: 'sports', name: 'Sports', icon: Icons.sports_basketball_rounded),
  ];

  static const List<Color> _apparelColors = <Color>[
    Color(0xFF1E1B39),
    Color(0xFF6C4CF1),
    Color(0xFFFF6584),
    Color(0xFF2ECC71),
  ];

  static const List<String> _clothingSizes = <String>['S', 'M', 'L', 'XL'];
  static const List<String> _shoeSizes = <String>['39', '40', '41', '42', '43'];

  static const List<Product> products = <Product>[
    Product(
      id: 'p1',
      name: 'Aurora Wireless Headphones',
      brand: 'Soundwave',
      categoryId: 'electronics',
      description:
          'Immersive over-ear headphones with adaptive noise cancellation, '
          '40-hour battery life and plush memory-foam ear cups for all-day comfort.',
      price: 129.99,
      oldPrice: 199.99,
      imageUrl: 'https://picsum.photos/seed/headphones/600/600',
      rating: 4.8,
      reviewCount: 1240,
      colors: _apparelColors,
      isFeatured: true,
      freeShipping: true,
    ),
    Product(
      id: 'p2',
      name: 'Pulse Smart Watch Series 6',
      brand: 'Nova',
      categoryId: 'electronics',
      description:
          'Track workouts, sleep and heart rate on a vivid AMOLED display. '
          'Water resistant to 50m with 7-day battery life.',
      price: 189.00,
      oldPrice: 249.00,
      imageUrl: 'https://picsum.photos/seed/smartwatch/600/600',
      rating: 4.6,
      reviewCount: 812,
      colors: _apparelColors,
      isFeatured: true,
    ),
    Product(
      id: 'p3',
      name: 'Nimbus Bluetooth Speaker',
      brand: 'Soundwave',
      categoryId: 'electronics',
      description:
          'Portable 360° speaker with deep bass, IPX7 waterproofing and '
          '18 hours of playback for every adventure.',
      price: 59.50,
      oldPrice: 89.00,
      imageUrl: 'https://picsum.photos/seed/speaker/600/600',
      rating: 4.4,
      reviewCount: 388,
      colors: _apparelColors,
      freeShipping: true,
    ),
    Product(
      id: 'p4',
      name: 'Vertex Mechanical Keyboard',
      brand: 'KeyForge',
      categoryId: 'electronics',
      description:
          'Hot-swappable RGB mechanical keyboard with tactile switches and a '
          'brushed aluminium top plate.',
      price: 99.00,
      imageUrl: 'https://picsum.photos/seed/keyboard/600/600',
      rating: 4.7,
      reviewCount: 245,
    ),
    Product(
      id: 'p5',
      name: 'Oversized Cotton Hoodie',
      brand: 'Urban Thread',
      categoryId: 'fashion',
      description:
          'Heavyweight brushed-back fleece hoodie with a relaxed fit and '
          'embroidered logo detail.',
      price: 45.00,
      oldPrice: 65.00,
      imageUrl: 'https://picsum.photos/seed/hoodie/600/600',
      rating: 4.5,
      reviewCount: 640,
      colors: _apparelColors,
      sizes: _clothingSizes,
      isFeatured: true,
    ),
    Product(
      id: 'p6',
      name: 'Linen Summer Shirt',
      brand: 'Urban Thread',
      categoryId: 'fashion',
      description:
          'Breathable European linen shirt with a camp collar and a tailored '
          'yet relaxed silhouette.',
      price: 38.00,
      imageUrl: 'https://picsum.photos/seed/shirt/600/600',
      rating: 4.3,
      reviewCount: 210,
      colors: _apparelColors,
      sizes: _clothingSizes,
    ),
    Product(
      id: 'p7',
      name: 'Everyday Denim Jacket',
      brand: 'Rivet & Co',
      categoryId: 'fashion',
      description:
          'Classic mid-wash denim jacket with a cotton-twill body and '
          'antique-brass hardware.',
      price: 72.00,
      oldPrice: 95.00,
      imageUrl: 'https://picsum.photos/seed/denimjacket/600/600',
      rating: 4.6,
      reviewCount: 154,
      colors: _apparelColors,
      sizes: _clothingSizes,
    ),
    Product(
      id: 'p8',
      name: 'Merino Wool Beanie',
      brand: 'Nord',
      categoryId: 'fashion',
      description:
          'Soft, itch-free merino wool beanie that keeps the cold out without '
          'overheating.',
      price: 22.00,
      imageUrl: 'https://picsum.photos/seed/beanie/600/600',
      rating: 4.2,
      reviewCount: 98,
      colors: _apparelColors,
    ),
    Product(
      id: 'p9',
      name: 'Cloudstep Running Sneakers',
      brand: 'Stride',
      categoryId: 'footwear',
      description:
          'Responsive foam midsole and engineered knit upper deliver a light, '
          'springy ride mile after mile.',
      price: 110.00,
      oldPrice: 140.00,
      imageUrl: 'https://picsum.photos/seed/sneakers/600/600',
      rating: 4.9,
      reviewCount: 2010,
      colors: _apparelColors,
      sizes: _shoeSizes,
      isFeatured: true,
      freeShipping: true,
    ),
    Product(
      id: 'p10',
      name: 'Trailblazer Hiking Boots',
      brand: 'Stride',
      categoryId: 'footwear',
      description:
          'Waterproof leather hiking boots with a grippy lugged outsole and '
          'ankle support for rugged terrain.',
      price: 145.00,
      imageUrl: 'https://picsum.photos/seed/hikingboots/600/600',
      rating: 4.7,
      reviewCount: 431,
      colors: _apparelColors,
      sizes: _shoeSizes,
    ),
    Product(
      id: 'p11',
      name: 'Canvas Low-Top Sneakers',
      brand: 'Rivet & Co',
      categoryId: 'footwear',
      description:
          'Timeless canvas low-tops with vulcanised rubber soles and recycled '
          'cotton laces.',
      price: 49.00,
      imageUrl: 'https://picsum.photos/seed/canvas/600/600',
      rating: 4.1,
      reviewCount: 176,
      colors: _apparelColors,
      sizes: _shoeSizes,
    ),
    Product(
      id: 'p12',
      name: 'Leather Chelsea Boots',
      brand: 'Stride',
      categoryId: 'footwear',
      description:
          'Premium full-grain leather Chelsea boots with elastic side panels '
          'and a stacked heel.',
      price: 165.00,
      oldPrice: 210.00,
      imageUrl: 'https://picsum.photos/seed/chelsea/600/600',
      rating: 4.6,
      reviewCount: 302,
      colors: _apparelColors,
      sizes: _shoeSizes,
    ),
    Product(
      id: 'p13',
      name: 'Halo Table Lamp',
      brand: 'Lumen',
      categoryId: 'home',
      description:
          'Warm dimmable LED table lamp with a hand-finished ceramic base and '
          'touch controls.',
      price: 54.00,
      imageUrl: 'https://picsum.photos/seed/lamp/600/600',
      rating: 4.4,
      reviewCount: 121,
    ),
    Product(
      id: 'p14',
      name: 'Brew Precision Kettle',
      brand: 'Lumen',
      categoryId: 'home',
      description:
          'Variable-temperature gooseneck kettle with a built-in timer for '
          'perfect pour-over coffee.',
      price: 89.00,
      oldPrice: 110.00,
      imageUrl: 'https://picsum.photos/seed/kettle/600/600',
      rating: 4.8,
      reviewCount: 356,
      isFeatured: true,
    ),
    Product(
      id: 'p15',
      name: 'Cloud Throw Blanket',
      brand: 'Nest',
      categoryId: 'home',
      description:
          'Ultra-soft knitted throw blanket in a chunky weave that adds warmth '
          'and texture to any room.',
      price: 42.00,
      imageUrl: 'https://picsum.photos/seed/blanket/600/600',
      rating: 4.5,
      reviewCount: 88,
    ),
    Product(
      id: 'p16',
      name: 'Terracotta Planter Set',
      brand: 'Nest',
      categoryId: 'home',
      description:
          'Set of three hand-thrown terracotta planters with drainage trays '
          'for healthy indoor plants.',
      price: 29.00,
      imageUrl: 'https://picsum.photos/seed/planters/600/600',
      rating: 4.2,
      reviewCount: 64,
    ),
    Product(
      id: 'p17',
      name: 'Radiance Vitamin C Serum',
      brand: 'Glow',
      categoryId: 'beauty',
      description:
          'Brightening 15% vitamin C serum with hyaluronic acid to even skin '
          'tone and boost radiance.',
      price: 34.00,
      oldPrice: 48.00,
      imageUrl: 'https://picsum.photos/seed/serum/600/600',
      rating: 4.9,
      reviewCount: 1502,
      isFeatured: true,
      freeShipping: true,
    ),
    Product(
      id: 'p18',
      name: 'Silk Hydrating Lip Balm',
      brand: 'Glow',
      categoryId: 'beauty',
      description:
          'Nourishing lip balm with shea butter and vitamin E for long-lasting '
          'hydration.',
      price: 12.50,
      imageUrl: 'https://picsum.photos/seed/lipbalm/600/600',
      rating: 4.4,
      reviewCount: 233,
    ),
    Product(
      id: 'p19',
      name: 'Cedar & Amber Eau de Parfum',
      brand: 'Maison Rive',
      categoryId: 'beauty',
      description:
          'Warm woody fragrance with notes of cedar, amber and a whisper of '
          'vanilla. 50ml.',
      price: 78.00,
      imageUrl: 'https://picsum.photos/seed/perfume/600/600',
      rating: 4.7,
      reviewCount: 410,
    ),
    Product(
      id: 'p20',
      name: 'Cloud Cream Moisturiser',
      brand: 'Glow',
      categoryId: 'beauty',
      description:
          'Lightweight gel-cream moisturiser that locks in moisture without '
          'clogging pores.',
      price: 27.00,
      oldPrice: 36.00,
      imageUrl: 'https://picsum.photos/seed/cream/600/600',
      rating: 4.6,
      reviewCount: 289,
    ),
    Product(
      id: 'p21',
      name: 'Pro Yoga Mat 6mm',
      brand: 'Zenith',
      categoryId: 'sports',
      description:
          'Non-slip cushioned yoga mat with alignment lines and a carry strap '
          'for studio or home practice.',
      price: 39.00,
      imageUrl: 'https://picsum.photos/seed/yogamat/600/600',
      rating: 4.5,
      reviewCount: 176,
      colors: _apparelColors,
      freeShipping: true,
    ),
    Product(
      id: 'p22',
      name: 'Adjustable Dumbbell Set',
      brand: 'Zenith',
      categoryId: 'sports',
      description:
          'Space-saving adjustable dumbbells that switch from 2kg to 20kg with '
          'a twist of the dial.',
      price: 199.00,
      oldPrice: 259.00,
      imageUrl: 'https://picsum.photos/seed/dumbbells/600/600',
      rating: 4.8,
      reviewCount: 512,
      isFeatured: true,
    ),
    Product(
      id: 'p23',
      name: 'Insulated Water Bottle 1L',
      brand: 'Zenith',
      categoryId: 'sports',
      description:
          'Double-walled stainless steel bottle that keeps drinks cold for 24 '
          'hours or hot for 12.',
      price: 24.00,
      imageUrl: 'https://picsum.photos/seed/bottle/600/600',
      rating: 4.3,
      reviewCount: 340,
      colors: _apparelColors,
    ),
    Product(
      id: 'p24',
      name: 'Resistance Band Kit',
      brand: 'Zenith',
      categoryId: 'sports',
      description:
          'Five durable latex resistance bands with a mesh carry bag for '
          'strength and mobility training anywhere.',
      price: 19.90,
      oldPrice: 28.00,
      imageUrl: 'https://picsum.photos/seed/bands/600/600',
      rating: 4.4,
      reviewCount: 205,
    ),
  ];

  static final List<Product> featured = List<Product>.unmodifiable(
    products.where((Product p) => p.isFeatured),
  );

  static Product? byId(String id) {
    for (final Product product in products) {
      if (product.id == id) return product;
    }
    return null;
  }
}

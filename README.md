# ecommerce_app

A modern, dependency-free e-commerce storefront prototype built with Flutter.

Discovery feed, product details with variant selection, wishlist, a full cart
with shipping/tax maths, and a checkout flow — all running on in-memory sample
data so the app boots instantly on any platform.

## Features

- **Home** — auto-advancing promo carousel, category filter chips, a featured
  rail and a lazily-built “Popular right now” grid.
- **Search** — live filtering by product name or brand with popular suggestions.
- **Product detail** — hero image, ratings, colour/size variants, quantity
  stepper, related products and add-to-cart / buy-now actions.
- **Cart** — merge duplicate variants, quantity controls, free-shipping
  progress, subtotal / shipping / 8% tax / total, and clear-cart confirmation.
- **Wishlist** — save favourites and add them straight to the cart.
- **Checkout** — address summary, payment method selection, order review and an
  order-placed confirmation.
- **Profile** — member summary, live order/wishlist/cart stats and settings.

## Design system

A modern, Dribbble-inspired visual language:

- Rich editorial typography (heavy weights, tight tracking) on an obsidian +
  off-white palette with electric sunset and indigo accents.
- Floating, frosted-glass bottom navigation with a fluid expanding pill.
- Soft-lift card shadows, generous corner radii and glass tags.
- Motion: staggered `Reveal` entrance animations, spring wishlist hearts,
  auto-advancing hero carousel, animated variant swatches and an animated
  order-confirmation dialog.

## Architecture

```
lib/
  main.dart                 # App root, provides the ShopState instance
  data/                     # In-memory catalogue (SampleData)
  models/                   # Immutable Product / Category / CartItem
  navigation/               # Centralised Navigator helpers (AppRoutes)
  screens/                  # RootShell + feature screens
  state/                    # ShopState (ChangeNotifier)
  theme/                    # Colours and Material 3 theme
  widgets/                  # Reusable presentational widgets
```

State lives in a single `ChangeNotifier` (`ShopState`), provided to the tree with
the [`provider`](https://pub.dev/packages/provider) package's
`ChangeNotifierProvider`. Widgets subscribe with `context.watch<ShopState>()`
and mutate with `context.read<ShopState>()`.

## Performance notes

This prototype deliberately follows the Flutter performance playbook:

- `const` constructors used throughout for immutable widgets.
- Large `build()` methods decomposed into small focused widgets.
- All long/unknown lists use `ListView.builder` / `GridView.builder` /
  `SliverGrid.builder` and only build the cells on screen.
- Images decode with `cacheWidth` / `cacheHeight` so full-resolution bitmaps are
  never held in memory.
- Non-UI work stays out of `build()`; controllers, timers and `PageController`s
  are disposed in `dispose()`.
- `RepaintBoundary` isolates the animated carousel pages.

## Getting started

```bash
flutter pub get
flutter run           # pick a connected device or desktop/web target
```

## Quality checks

```bash
flutter analyze       # static analysis (0 issues)
flutter test          # unit + widget smoke tests
```

## Build

```bash
flutter build web --release
flutter build apk --release
```

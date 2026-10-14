import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/root_shell.dart';
import 'state/shop_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EcommerceApp());
}

/// Root widget. Provides the single [ShopState] instance to the widget tree.
///
/// `ChangeNotifierProvider` creates the notifier and disposes it automatically
/// when the provider is removed from the tree.
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopState>(
      create: (_) => ShopState(),
      child: MaterialApp(
        title: 'ecommerce_app',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const RootShell(),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'screens/root_shell.dart';
import 'state/shop_scope.dart';
import 'state/shop_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const EcommerceApp());
}

/// Root widget. Owns the single [ShopState] instance for the app's lifetime and
/// disposes it when the widget is torn down.
class EcommerceApp extends StatefulWidget {
  const EcommerceApp({super.key});

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  late final ShopState _shop = ShopState();

  @override
  void dispose() {
    _shop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShopScope(
      state: _shop,
      child: MaterialApp(
        title: 'ecommerce_app',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const RootShell(),
      ),
    );
  }
}

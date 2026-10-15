import 'package:flutter/material.dart';

import '../widgets/navigation/floating_nav_bar.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'wishlist_screen.dart';

/// Root scaffold hosting the four primary tabs behind a floating,
/// frosted-glass navigation bar.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void _onSelect(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = <Widget>[
      const HomeScreen(),
      WishlistScreen(onBrowse: () => _onSelect(0)),
      CartScreen(embedded: true, onBrowse: () => _onSelect(0)),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: FloatingNavBar(
        index: _index,
        onSelect: _onSelect,
      ),
    );
  }
}

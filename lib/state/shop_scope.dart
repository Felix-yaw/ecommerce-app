import 'package:flutter/widgets.dart';

import 'shop_state.dart';

/// Exposes a single [ShopState] instance to the widget tree.
///
/// Backed by [InheritedNotifier], so any widget that calls [ShopScope.of] with
/// `listen: true` automatically rebuilds when the state notifies — no external
/// state-management package required.
class ShopScope extends InheritedNotifier<ShopState> {
  const ShopScope({
    super.key,
    required ShopState state,
    required super.child,
  }) : super(notifier: state);

  /// The state, subscribing the caller to rebuilds.
  static ShopState of(BuildContext context) {
    final ShopScope? scope =
        context.dependOnInheritedWidgetOfExactType<ShopScope>();
    assert(scope != null, 'ShopScope.of() called with a context outside ShopScope');
    return scope!.notifier!;
  }

  /// The state without subscribing to rebuilds (useful inside callbacks).
  static ShopState read(BuildContext context) {
    final ShopScope? scope =
        context.getInheritedWidgetOfExactType<ShopScope>();
    assert(scope != null, 'ShopScope.read() called with a context outside ShopScope');
    return scope!.notifier!;
  }
}

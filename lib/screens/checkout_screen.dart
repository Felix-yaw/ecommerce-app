import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/payment_option.dart';
import '../state/shop_state.dart';
import '../theme/app_colors.dart';
import '../widgets/checkout/address_card.dart';
import '../widgets/checkout/order_summary.dart';
import '../widgets/checkout/order_success_dialog.dart';
import '../widgets/checkout/payment_tile.dart';
import '../widgets/checkout/totals_card.dart';
import '../widgets/group_heading.dart';

/// Polished checkout: delivery, payment, order review and confirmation.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  static const List<PaymentOption> _options = <PaymentOption>[
    PaymentOption(
      id: 'card',
      icon: Icons.credit_card_rounded,
      label: 'Credit / Debit Card',
    ),
    PaymentOption(
      id: 'wallet',
      icon: Icons.account_balance_wallet_rounded,
      label: 'Wallet',
    ),
    PaymentOption(
      id: 'cod',
      icon: Icons.local_shipping_rounded,
      label: 'Cash on Delivery',
    ),
  ];

  String _payment = 'card';
  bool _placing = false;

  Future<void> _placeOrder() async {
    setState(() => _placing = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final ShopState shop = context.read<ShopState>();
    final String total = '\$${shop.total.toStringAsFixed(2)}';
    shop.clearCart();
    setState(() => _placing = false);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) => OrderSuccessDialog(total: total),
    );

    if (mounted) Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final ShopState shop = context.watch<ShopState>();
    final List<CartItem> items = shop.cartItems;

    if (items.isEmpty && !_placing) {
      return const Scaffold(body: Center(child: Text('Your bag is empty')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: <Widget>[
          const GroupHeading('Delivery address', fontSize: 17),
          const AddressCard(),
          const SizedBox(height: 26),
          const GroupHeading('Payment method', fontSize: 17),
          const SizedBox(height: 12),
          for (final PaymentOption option in _options)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PaymentTile(
                option: option,
                selected: _payment == option.id,
                onTap: () => setState(() => _payment = option.id),
              ),
            ),
          const SizedBox(height: 18),
          const GroupHeading('Order summary', fontSize: 17),
          const SizedBox(height: 12),
          OrderSummary(items: items),
          const SizedBox(height: 16),
          TotalsCard(
            subtotal: shop.subtotal,
            shipping: shop.shipping,
            tax: shop.tax,
            total: shop.total,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: AppColors.floatingShadow,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: FilledButton(
              onPressed: _placing ? null : _placeOrder,
              child: _placing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text('Place Order · \$${shop.total.toStringAsFixed(2)}'),
            ),
          ),
        ),
      ),
    );
  }
}

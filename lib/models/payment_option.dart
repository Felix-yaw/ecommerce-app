import 'package:flutter/material.dart';

/// A selectable payment method on the checkout screen.
@immutable
class PaymentOption {
  const PaymentOption({
    required this.id,
    required this.icon,
    required this.label,
  });

  final String id;
  final IconData icon;
  final String label;
}

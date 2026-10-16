import 'package:flutter/material.dart';

/// A single entry in a [ProfileMenu] group.
@immutable
class ProfileMenuItem {
  const ProfileMenuItem(this.icon, this.title, this.subtitle);

  final IconData icon;
  final String title;
  final String subtitle;
}

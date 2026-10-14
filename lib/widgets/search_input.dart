import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Modern search input with soft fill and clear affordance.
class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    this.initialValue = '',
    required this.onChanged,
    this.autofocus = false,
    this.hintText = 'Search products, brands…',
    this.readOnly = false,
    this.onTap,
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      textInputAction: TextInputAction.search,
      onChanged: (String value) {
        widget.onChanged(value);
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textTertiary,
        ),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                color: AppColors.textSecondary,
                onPressed: _clear,
              ),
      ),
    );
  }
}

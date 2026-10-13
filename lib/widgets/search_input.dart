import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Rounded search input with a leading icon and clear button.
class SearchInput extends StatefulWidget {
  const SearchInput({
    super.key,
    this.initialValue = '',
    required this.onChanged,
    this.autofocus = false,
    this.hintText = 'Search products, brands…',
  });

  final String initialValue;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final String hintText;

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
      textInputAction: TextInputAction.search,
      onChanged: (String value) {
        widget.onChanged(value);
        setState(() {});
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textSecondary,
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

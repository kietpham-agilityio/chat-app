// MARK: Release Lazy load
import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

part 'custom_dropdown_menu.dart';

class CustomDropdownSuggestion extends StatefulWidget {
  const CustomDropdownSuggestion({
    super.key,
    required this.items,
    required this.onChanged,
    required this.label,
    required this.textController,
    this.isLoading = false,
    this.enabled = true,
    this.errorMessage,
    this.initialValue,
    this.physics,
    this.maxVisibleItems,
    this.onTapped,
    this.onLoadMore,
    this.focusNode,
    this.disabledHint,
  });

  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool isLoading;
  final Widget label;
  final TextEditingController textController;
  final bool enabled;
  final String? errorMessage;
  final String? initialValue;
  final ScrollPhysics? physics;
  final double? maxVisibleItems;
  final VoidCallback? onTapped;
  final VoidCallback? onLoadMore;
  final FocusNode? focusNode;
  final String? disabledHint;

  @override
  State<CustomDropdownSuggestion> createState() =>
      _CustomDropdownSuggestionState();
}

class _CustomDropdownSuggestionState extends State<CustomDropdownSuggestion> {
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label,
        SizedBox(height: 8),
        _CustomDropdownmenu(
          focusNode: _focusNode,
          items: widget.items,
          selectedItem: widget.onChanged,
          initialValue: widget.initialValue,
          physics: widget.physics,
          maxVisibleItems: widget.maxVisibleItems,
          onTapped: widget.onTapped,
          onLoadMore: widget.onLoadMore,
          isLoading: widget.isLoading,
          textController: widget.textController,
          errorMessage: widget.errorMessage,
          disabledHint: widget.disabledHint,
          enabled: widget.enabled,
        ),
        if (widget.errorMessage != null)
          Text(
            widget.errorMessage!,
            style: TextStyle(color: context.colorScheme.error, fontSize: 12),
          )
        else
          SizedBox(height: 17),
      ],
    );
  }
}

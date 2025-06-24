part of 'custom_dropdown_suggestion.dart';

/// A custom dropdown menu widget that supports lazy loading, filtering, and dynamic item selection.
class _CustomDropdownmenu extends StatefulWidget {
  /// Creates a custom dropdown menu.
  ///
  /// [items] is the list of items to display in the dropdown.
  /// [selectedItem] is a callback triggered when an item is selected.
  /// [isLoading] indicates whether the dropdown is in a loading state.
  /// [initialValue] is the initial selected value.
  /// [physics] defines the scroll physics for the dropdown list.
  /// [maxVisibleItems] limits the maximum number of visible items in the dropdown.
  /// [onTapped] is a callback triggered when the dropdown is tapped.
  /// [focusNode] allows external control of the dropdown's focus.
  /// [onLoadMore] is a callback triggered when the user scrolls to the bottom of the list.
  const _CustomDropdownmenu({
    required this.items,
    required this.selectedItem,
    required this.isLoading,
    required this.textController,
    this.enabled = true,
    this.initialValue,
    this.physics,
    this.maxVisibleItems,
    this.onTapped,
    this.focusNode,
    this.onLoadMore,
    this.errorMessage,
    this.disabledHint,
  });

  /// The list of items to display in the dropdown.
  final List<String> items;

  /// Callback triggered when an item is selected.
  final ValueChanged<String> selectedItem;

  /// Indicates whether the dropdown is in a loading state.
  final bool isLoading;

  /// The initial selected value.
  final String? initialValue;

  /// Scroll physics for the dropdown list.
  final ScrollPhysics? physics;

  /// Maximum number of visible items in the dropdown.
  final double? maxVisibleItems;

  /// Callback triggered when the dropdown is tapped.
  final VoidCallback? onTapped;

  /// Focus node for controlling the dropdown's focus.
  final FocusNode? focusNode;

  /// Callback triggered when the user scrolls to the bottom of the list.
  final VoidCallback? onLoadMore;

  /// Text controller for the dropdown's text field.
  final TextEditingController textController;

  /// Error message to display when validation fails.
  final String? errorMessage;

  /// Hint to display when the dropdown is disabled.
  final String? disabledHint;

  /// Indicates whether the dropdown is enabled or disabled.
  final bool enabled;

  @override
  State<_CustomDropdownmenu> createState() => _CustomDropdownmenuState();
}

/// The state for the `_CustomDropdownmenu` widget.
class _CustomDropdownmenuState extends State<_CustomDropdownmenu> {
  /// Text controller for the dropdown's text field.
  late TextEditingController _textController;

  /// The currently selected item.
  late String _selectedItem;

  /// The maximum number of visible items in the dropdown.
  late double _maxVisibleItems;

  /// The focus node for the dropdown.
  late FocusNode _focusNode;

  /// A link for positioning the dropdown overlay.
  final LayerLink _layerLink = LayerLink();

  /// Scroll controller for the dropdown list.
  final ScrollController _scrollController = ScrollController();

  /// Key for identifying the selected list tile.
  final GlobalKey _listTileKey = GlobalKey();

  final ValueNotifier<bool> _isDropdownOpenNotifier = ValueNotifier(false);

  /// Default height of a list tile.
  double _itemHeight = 56.0;

  /// The overlay entry for the dropdown.
  OverlayEntry? _overlayEntry;

  /// The filtered list of items based on user input.
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _textController = widget.textController;
    // _selectedItem = widget.items.isNotEmpty
    //     ? widget.initialValue ?? widget.items.first
    //     : '';
    _selectedItem =
        widget.initialValue ??
        (widget.items.isNotEmpty ? widget.items.first : '');
    _textController.text = _selectedItem;
    _filteredItems = List.from(widget.items);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _textController.addListener(_onTextChanged);
    _maxVisibleItems = widget.maxVisibleItems ?? 4;
    _scrollController.addListener(_onScroll);
  }

  /// Handles scroll events and triggers the `onLoadMore` callback when the user
  /// scrolls to the bottom of the list.
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      widget.onLoadMore?.call();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _textController.removeListener(_onTextChanged);
    _focusNode.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _removeDropdown();
    super.dispose();
  }

  /// Handles focus changes and shows or hides the dropdown accordingly.
  void _onFocusChange() {
    _isDropdownOpenNotifier.value = _focusNode.hasFocus;

    if (_focusNode.hasFocus) {
      _filteredItems = List.from(widget.items);
      _showDropdown();
    } else {
      final input = _textController.text.trim();

      final exactMatch = widget.items.firstWhere(
        (item) => item == input,
        orElse: () => '',
      );

      if (exactMatch.isNotEmpty) {
        // if input matches an item, auto select
        _selectedItem = exactMatch;
        _textController.text = exactMatch;
        widget.selectedItem(_selectedItem);
      } else {
        // if input does not match any item, clear the input
        _selectedItem = '';
        _textController.clear();
        widget.selectedItem('');
      }

      _removeDropdown();
    }
  }

  /// Filters the list of items based on the user's input in the text field.
  void _onTextChanged() {
    final input = _textController.text.trim();

    _filteredItems = widget.items.isEmpty
        ? []
        : widget.items
              .where((item) => item.toLowerCase().contains(input.toLowerCase()))
              .toList();

    if (input.isEmpty) {
      _selectedItem = '';
      widget.selectedItem(_selectedItem);
    }

    _overlayEntry?.markNeedsBuild();
  }

  /// Displays the dropdown overlay.
  void _showDropdown() {
    _filteredItems = List.from(widget.items);
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tileContext = _listTileKey.currentContext;
      if (tileContext != null) {
        final renderBox = tileContext.findRenderObject() as RenderBox;
        _itemHeight = renderBox.size.height;
      }

      int selectedIndex = widget.items.indexOf(_selectedItem);
      if (selectedIndex != -1) {
        double offset = widget.items.length - selectedIndex < 4
            ? widget.items.length - _maxVisibleItems <= 0
                  ? 0
                  : (widget.items.length - _maxVisibleItems) * _itemHeight
            : selectedIndex * _itemHeight;
        _scrollController.jumpTo(offset);
      }
    });
  }

  /// Removes the dropdown overlay.
  void _removeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  /// Creates the overlay entry for the dropdown.
  OverlayEntry _createOverlayEntry() {
    double screenHeight = MediaQuery.of(context).size.height;

    RenderBox renderBox = context.findRenderObject() as RenderBox;
    return OverlayEntry(
      builder: (context) {
        var size = renderBox.size;
        var offset = renderBox.localToGlobal(Offset.zero);

        final double height = _filteredItems.length > _maxVisibleItems
            ? _itemHeight * _maxVisibleItems
            : (_filteredItems.length <= 4 && _filteredItems.isNotEmpty
                  ? _filteredItems.length * _itemHeight + 2
                  : size.height + 10);

        final double offsetDy = offset.dy > screenHeight * 1 / 3
            ? -height
            : size.height;

        return Positioned(
          width: size.width,
          left: offset.dx,
          top: offset.dy + size.height,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, offsetDy),
            child: Material(
              color: context.colorScheme.onPrimary,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.colorScheme.tertiaryFixedDim,
                  ),
                ),
                height: _filteredItems.length > _maxVisibleItems
                    ? _itemHeight * _maxVisibleItems
                    : null,
                // child: Scrollbar(
                //   thumbVisibility: true,
                //   controller: _scrollController,
                //   child: ListView.builder(
                //     padding: EdgeInsets.zero,
                //     physics: widget.physics,
                //     controller: _scrollController,
                //     shrinkWrap: true,
                //     itemCount:
                //         _filteredItems.length + (widget.isLoading ? 1 : 0),
                //     itemBuilder: (context, index) {
                //       if (index == _filteredItems.length && widget.isLoading) {
                //         return const BottomLoader();
                //       }

                //       final item = _filteredItems[index];
                //       return ListTile(
                //         key: item == _selectedItem ? _listTileKey : null,
                //         title: Text(item),
                //         tileColor: item == _selectedItem
                //             ? Theme.of(
                //                 context,
                //               ).colorScheme.primary.withAlpha(50)
                //             : null,
                //         onTap: () {
                //           _selectedItem = item;
                //           _textController.text = item;
                //           widget.selectedItem(item);
                //           _focusNode.unfocus();
                //         },
                //       );
                //     },
                //   ),
                // ),
                child: widget.isLoading && widget.items.isEmpty
                    ? const BottomLoader()
                    : Scrollbar(
                        thumbVisibility: true,
                        controller: _scrollController,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: widget.physics ?? ClampingScrollPhysics(),
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount:
                              _filteredItems.length +
                              (widget.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _filteredItems.length &&
                                widget.isLoading) {
                              return const BottomLoader();
                            }

                            final item = _filteredItems[index];
                            return ListTile(
                              key: item == _selectedItem ? _listTileKey : null,
                              title: Text(item),
                              tileColor: item == _selectedItem
                                  ? context.colorScheme.primary.withAlpha(50)
                                  : null,
                              onTap: () {
                                _selectedItem = item;
                                _textController.text = item;
                                widget.selectedItem(item);
                                _focusNode.unfocus();
                              },
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant _CustomDropdownmenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLoading != widget.isLoading ||
        oldWidget.items != widget.items) {
      _filteredItems = List.from(widget.items);

      if (_focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _overlayEntry?.markNeedsBuild();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        enabled: widget.enabled,
        controller: _textController,
        focusNode: _focusNode,
        onTap: widget.onTapped,
        readOnly: widget.items.isEmpty,
        decoration: InputDecoration(
          hintText: !widget.enabled
              ? (widget.disabledHint ?? '__Select__')
              : '__Select__',
          errorText: widget.errorMessage == null ? null : '',
          errorStyle: TextStyle(height: -1),
          hintStyle: TextStyle(
            color: widget.enabled
                ? context.colorScheme.tertiaryFixed
                : context.colorScheme.tertiary,
          ),
          suffixIcon: ValueListenableBuilder<bool>(
            valueListenable: _isDropdownOpenNotifier,
            builder: (_, isOpen, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up_outlined
                      : Icons.keyboard_arrow_down_outlined,
                  color: widget.enabled
                      ? Theme.of(context).colorScheme.tertiaryContainer
                      : Colors.grey[400],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A widget that displays a loading indicator at the bottom of the dropdown.
class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: const Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

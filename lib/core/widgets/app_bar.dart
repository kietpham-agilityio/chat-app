import 'package:flutter/material.dart';

class CAAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CAAppBar({
    this.title = const SizedBox.shrink(),
    this.toolbarHeight = 44,
    this.leading,
    this.trailing,
    this.titleSpacing,
    super.key,
  });

  /// The widget to be displayed in the center of the app bar.
  ///
  /// The [title] property is optional and can be any widget.
  final Widget? title;

  /// The height of the app bar.
  ///
  /// The [toolbarHeight] property is optional and can be used to customize the
  /// height of the app bar. The default height is 44.
  final double toolbarHeight;

  /// The widget to be displayed on the left side of the app bar.
  ///
  /// The [leading] property is optional and can be any widget.
  final Widget? leading;

  /// A list of widgets to be displayed on the right side of the app bar.
  ///
  /// The [trailing] property is optional and can be a list of widgets. They are
  /// displayed on the right side of the app bar.
  final List<Widget>? trailing;

  final double? titleSpacing;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(toolbarHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            toolbarHeight: toolbarHeight,
            automaticallyImplyLeading: false,
            leading: leading,
            leadingWidth: toolbarHeight,
            actions: [if (trailing != null) ...trailing!],
            titleSpacing: titleSpacing,
            title: title,
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}

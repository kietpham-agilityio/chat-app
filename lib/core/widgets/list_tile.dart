import 'package:flutter/material.dart';

// MARK: ListTile
/// The [ListTile] can have a title, subtitle, leading widget, trailing
/// widget, and a callback when tapped.
///
/// The tile itself does not maintain any state. Instead, the expected
/// behavior is that the parent widget maintains the selected state and
/// passes the new state into this widget when the tile is tapped.
class CAListTile extends StatelessWidget {
  const CAListTile({
    required this.title,
    this.selected = false,
    this.enabled = true,
    this.verticalPadding = 4,
    this.minLeadingWidth,
    this.titleAlignment,
    this.minVerticalPadding,
    this.subtitle,
    this.leading,
    this.trailing,
    this.contentPadding,
    this.onTap,
    this.tileColor,
    super.key,
  });

  /// The primary content of the list tile.
  final Widget title;

  /// Whether this list tile is selected.
  ///
  /// If false, this list tile will not be selected when tapped.
  final bool selected;

  /// Whether this list tile is enabled or disabled.
  ///
  /// If false, this list tile will not be selectable when tapped.
  final bool enabled;

  /// The minimum width allocated for the [leading] widget.
  ///
  /// If null, `0` is used.
  final double? minLeadingWidth;

  /// How the title should be aligned horizontally.
  final ListTileTitleAlignment? titleAlignment;

  /// The minimum padding between the title and subtitle widgets.
  ///
  /// If null, `4` is used.
  final double? minVerticalPadding;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display before the title.
  final Widget? leading;

  /// A widget to display after the title.
  final Widget? trailing;

  /// The tile's internal padding.
  ///
  /// If null, `EdgeInsets.symmetric(horizontal: 16, vertical: 4)` is used.
  final EdgeInsetsGeometry? contentPadding;

  /// The vertical padding around the title and subtitle widgets.
  ///
  /// If null, `4` is used.
  final double verticalPadding;

  /// Called when the tile is tapped.
  final VoidCallback? onTap;

  final Color? tileColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      selected: selected,
      enabled: enabled,
      titleAlignment: titleAlignment,
      minLeadingWidth: minLeadingWidth,
      minVerticalPadding: minVerticalPadding,
      contentPadding: contentPadding,
    );
  }
}

// MARK: TileGroup
/// A widget to display a list of AgbUiListTiles in a vertically scrolling list.
///
/// This widget is a convenience wrapper around [ListView.separated] to display
/// a list of AgbUiListTiles with a separator between each item.
class CATileGroup extends StatelessWidget {
  /// Creates a widget that displays a list of AgbUiListTiles.
  const CATileGroup({
    /// The list of tiles to display.
    required this.tiles,

    /// The widget to use as a separator between each item.
    ///
    /// Defaults to an AgbUiDivider.
    this.separator = const Divider(height: 0),

    /// How the widgets should respond to user input.
    ///
    /// For example, determines how the widget continues to behave
    /// when the user continues to scroll
    /// after the end of the list has been reached.
    this.physics = const AlwaysScrollableScrollPhysics(),

    /// The amount of space by which to inset the children.
    ///
    /// If null, the EdgeInsets.zero is used.
    this.padding = const EdgeInsets.all(8),
    this.tileColor,
    super.key,
  });

  /// The list of tiles to display.
  final List<CAListTile> tiles;

  /// The widget to use as a separator between each item.
  final Widget separator;

  /// How the widgets should respond to user input.
  final ScrollPhysics physics;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry padding;

  /// The background color of the tile.
  ///
  /// If null, the default color of the ListTile is used.
  final Color? tileColor;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: physics,
      padding: padding,
      shrinkWrap: true,
      itemCount: tiles.length,
      separatorBuilder: (context, index) => separator,
      itemBuilder: (context, index) {
        if (index == tiles.length - 1) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CAListTile(
                tileColor: tiles[index].tileColor,
                title: tiles[index].title,
                subtitle: tiles[index].subtitle,
                trailing: tiles[index].trailing,
                onTap: tiles[index].onTap,
                leading: tiles[index].leading,
                contentPadding: tiles[index].contentPadding,
                verticalPadding: tiles[index].verticalPadding,
                selected: tiles[index].selected,
              ),
              separator,
            ],
          );
        }

        return CAListTile(
          tileColor: tiles[index].tileColor,
          title: tiles[index].title,
          subtitle: tiles[index].subtitle,
          trailing: tiles[index].trailing,
          onTap: tiles[index].onTap,
          leading: tiles[index].leading,
          contentPadding: tiles[index].contentPadding,
          verticalPadding: tiles[index].verticalPadding,
          selected: tiles[index].selected,
        );
      },
    );
  }
}

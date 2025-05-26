import 'package:chat_app/core/themes/app_palette.dart';
import 'package:flutter/material.dart';

import 'assets.dart' show CAAssets, CACachedNetworkImage;

/// A [CircleAvatar] widget that loads its image from a network URL.
///
/// If the image fails to load, it displays a default user avatar.
/// The avatar is a 40x40 image.
class CACircleAvatar extends StatelessWidget {
  const CACircleAvatar({super.key, required this.url});

  /// The URL of the image to display.
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: CAPalette.grey[1],
        child: CACachedNetworkImage(
          url: url,
          errorBuilder: CAAssets.user(width: 40, height: 40),
        ),
      ),
    );
  }
}

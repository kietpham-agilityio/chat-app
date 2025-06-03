import 'package:chat_app/core/themes/app_palette.dart';
import 'package:flutter/material.dart';

import 'assets.dart' show CAAssets, CACachedNetworkImage;

/// A [CircleAvatar] widget that loads its image from a network URL.
///
/// If the image fails to load, it displays a default user avatar.
/// The avatar is a 40x40 image.
class CACircleAvatar extends StatelessWidget {
  const CACircleAvatar({
    super.key,
    required this.url,
    this.avatarSize = 40.0,
    this.onTap,
  });

  /// The URL of the image to display.
  final String url;
  final double avatarSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: avatarSize,
        width: avatarSize,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: Container(
              height: avatarSize,
              width: avatarSize,
              color: CAPalette.grey[1],
              child: CACachedNetworkImage(
                url: url,
                errorBuilder: CAAssets.user(
                  width: avatarSize,
                  height: avatarSize,
                  boxFit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

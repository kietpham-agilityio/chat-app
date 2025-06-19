import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/resources/assets_generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          radius: avatarSize / 2,
          backgroundColor: context.colorScheme.tertiary,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: url,
              width: avatarSize,
              height: avatarSize,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => SvgPicture.asset(
                Assets.icons.icUser.path,
                width: avatarSize,
                height: avatarSize,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

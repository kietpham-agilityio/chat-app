import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/core/extensions/context_extensions.dart';
import 'package:chat_app/core/resources/assets_generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///
/// An enum defines all supported types of image loader
///
/// * [ImageLoaderType.assetPNG] load PNG image from asset
/// * [ImageLoaderType.assetSVG] load SVG image from asset
/// * [ImageLoaderType.cachedNetwork] return cache image if exists,
/// *   otherwises return network image
///
enum ImageLoaderType { assetPNG, assetSVG, cachedNetwork }

/// A widget that displays an image from a specified asset path.
///
/// This widget supports different types of image loaders defined by the
/// [ImageLoaderType] enum. By default, it assumes the image type is a PNG
/// asset. An assertion ensures that the image path does not start with 'http'
/// or 'https', as this widget is meant for local asset images only.
class CAAssetImage extends StatelessWidget {
  CAAssetImage({
    required this.path,
    super.key,
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit,
    this.type = ImageLoaderType.assetPNG,
  }) : assert(
         !path.startsWith('http'),
         'Asset Image path should not start with http or https',
       );

  final String path;
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? boxFit;
  final ImageLoaderType type;

  @override
  Widget build(BuildContext context) {
    return _CAImageLoader(
      url: path,
      type: type,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      color: color,
      boxFit: boxFit,
    );
  }
}

/// A widget that displays an image from a network source with caching support.
///
/// This widget uses the [_CAImageLoader] to display images from a cached
/// network source. It requires a [url] for the image source and optionally
/// accepts a [width], [height], [boxFit], and a custom [errorBuilder].
///
/// The default [width] and [height] are set to 40, and the default [boxFit]
/// is set to [BoxFit.contain].
class CACachedNetworkImage extends StatelessWidget {
  const CACachedNetworkImage({
    required this.url,
    this.width = 40,
    this.height = 40,
    this.boxFit = BoxFit.contain,
    this.errorBuilder,
    super.key,
  });

  final String url;
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return _CAImageLoader(
      url: url,
      type: ImageLoaderType.cachedNetwork,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      boxFit: boxFit,
    );
  }
}

/// A widget that loads and displays images from various sources with optional caching and error handling.
///
/// This widget supports loading images from asset images (PNG and SVG) and cached network images. It can optionally display
/// a custom error widget if the image fails to load and supports custom sizing, color, and fitting options.
class _CAImageLoader extends StatelessWidget {
  const _CAImageLoader({
    required this.type,
    required this.url,
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit = BoxFit.cover,
  });

  final ImageLoaderType type;
  final String url;
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ImageLoaderType.assetPNG:
        return Image.asset(
          url,
          fit: boxFit,
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
            log('Image $url load failed. Error: $error');
            return errorBuilder ?? Icon(Icons.broken_image, size: width);
          },
          width: width,
          height: height,
          color: color,
        );
      case ImageLoaderType.assetSVG:
        return SvgPicture.asset(
          url,
          colorFilter: ColorFilter.mode(
            color ?? context.colorScheme.onSurface,
            BlendMode.srcIn,
          ),
          fit: boxFit ?? BoxFit.contain,
          placeholderBuilder: (BuildContext context) {
            return errorBuilder ?? Icon(Icons.broken_image, size: width);
          },
          width: width,
          height: height,
        );
      case ImageLoaderType.cachedNetwork:
        return CachedNetworkImage(
          imageUrl: url,
          fit: boxFit,
          width: width,
          height: height,
          errorWidget: (BuildContext context, String url, dynamic error) {
            log('Image $url load failed. Error: $error');
            return errorBuilder ?? Icon(Icons.broken_image, size: width);
          },
          imageBuilder:
              (BuildContext context, ImageProvider<Object> provider) =>
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: provider),
                    ),
                  ),
        );
    }
  }
}

class CAAssets {
  static Widget Function({double? width, double? height, BoxFit? boxfit}) logo =
      _CALogoImage.new;

  static Widget Function({Color? color, double? width, double? height})
  arrowLeft = _CAArrowLeftImage.new;

  static Widget Function({Color? color, double? width, double? height}) bell =
      _CABellImage.new;

  static Widget Function({Color? color, double? width, double? height}) error =
      _CAErrorImage.new;

  static Widget Function({Color? color, double? width, double? height})
  gallery = _CAGalleryImage.new;

  static Widget Function({Color? color, double? width, double? height}) logOut =
      _CALogOutImage.new;

  static Widget Function({Color? color, double? width, double? height})
  moreHorizontal = _CAMoreHorizontalImage.new;

  static Widget Function({Color? color, double? width, double? height}) plus =
      _CAPlusImage.new;

  static Widget Function({Color? color, double? width, double? height}) search =
      _CASearchImage.new;

  static Widget Function({Color? color, double? width, double? height})
  thumpsUp = _CAThumbsUpImage.new;

  static Widget Function({Color? color, double? width, double? height}) user =
      _CAUserImage.new;
}

// MARK: Logo
class _CALogoImage extends StatelessWidget {
  const _CALogoImage({this.width, this.height, this.boxfit});
  final double? height;
  final double? width;
  final BoxFit? boxfit;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      boxFit: boxfit,
      path: Assets.images.imgMessage.path,
      width: width ?? 88,
      height: height ?? 88,
    );
  }
}

// MARK: Arrow Left
class _CAArrowLeftImage extends StatelessWidget {
  const _CAArrowLeftImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icArrowLeft.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: Bell
class _CABellImage extends StatelessWidget {
  const _CABellImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icBell.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: Error
class _CAErrorImage extends StatelessWidget {
  const _CAErrorImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icError.path,
      width: width ?? 16,
      height: height ?? 16,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: Gallery
class _CAGalleryImage extends StatelessWidget {
  const _CAGalleryImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icGallery.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: Log Out
class _CALogOutImage extends StatelessWidget {
  const _CALogOutImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icLogOut.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: More Horizontal
class _CAMoreHorizontalImage extends StatelessWidget {
  const _CAMoreHorizontalImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icMoreHorizontal.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: Plus
class _CAPlusImage extends StatelessWidget {
  const _CAPlusImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icPlus.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: Search
class _CASearchImage extends StatelessWidget {
  const _CASearchImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icSearch.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: ThubsUp
class _CAThumbsUpImage extends StatelessWidget {
  const _CAThumbsUpImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icThumbsUp.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

// MARK: User
class _CAUserImage extends StatelessWidget {
  const _CAUserImage({this.color, this.width, this.height});

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CAAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.icons.icUser.path,
      width: width ?? 24,
      height: height ?? 24,
      color: color ?? context.colorScheme.primary,
    );
  }
}

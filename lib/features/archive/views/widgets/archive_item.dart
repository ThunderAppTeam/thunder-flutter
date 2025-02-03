import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/thunder_network_image.dart';
import 'package:thunder/features/archive/models/data/body_check_preview_data.dart';

class ArchiveItem extends StatelessWidget {
  final BodyCheckPreviewData item;

  const ArchiveItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Stack(
      children: [
        Hero(
          tag: 'body_check_image_${item.bodyPhotoId}',
          child: ThunderNetworkImage(imageUrl: item.imageUrl),
        ),
        Positioned(
          left: Sizes.spacing8,
          right: Sizes.spacing8,
          bottom: Sizes.spacing8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.logos.thunderSymbolW.svg(height: Sizes.icon12),
              Text(
                item.reviewCount == 0 ? '?.?' : item.reviewScore.toString(),
                style: textTheme.textSubtitle14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

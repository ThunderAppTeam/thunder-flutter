import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/thunder_network_image.dart';
import 'package:thunder/features/archive/view_models/archive_view_model.dart';

class ArchiveItem extends StatelessWidget {
  final BodyCheckPreview item;

  const ArchiveItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Stack(
      children: [
        ThunderNetworkImage(imageUrl: item.imageUrl),
        Positioned(
          left: Sizes.spacing8,
          right: Sizes.spacing8,
          bottom: Sizes.spacing8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.logos.thunderSymbolW.svg(
                height: 12,
              ),
              Text(
                item.averageRating.toStringAsFixed(1),
                style: textTheme.textSubtitle14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

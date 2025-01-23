import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/features/archive/view_models/archive_view_model.dart';

class ArchiveItem extends StatelessWidget {
  final BodyCheckPreview item;

  const ArchiveItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Stack(
      children: [
        ExtendedImage.network(
          item.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cache: true,
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return const CustomCircularIndicator();
              case LoadState.completed:
                return state.completedWidget;
              case LoadState.failed:
                return const Center(
                  child: Icon(Icons.error, color: ColorName.darkLabel2),
                );
            }
          },
        ),
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

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';

class ThunderNetworkImage extends StatelessWidget {
  final String imageUrl;
  const ThunderNetworkImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
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
            return Center(
              child: Icon(
                Icons.error,
                color: ColorName.darkLabel2,
              ),
            );
        }
      },
    );
  }
}

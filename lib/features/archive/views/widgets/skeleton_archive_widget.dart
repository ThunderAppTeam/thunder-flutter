import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class SkeletonArchiveWidget extends StatelessWidget {
  final int crossAxisCount;
  final double itemWidth;
  final double itemHeight;

  const SkeletonArchiveWidget({
    super.key,
    required this.crossAxisCount,
    required this.itemWidth,
    required this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ColorName.darkBackground2,
      highlightColor: ColorName.darkSkeletonBase,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: Sizes.borderWidth1,
          mainAxisSpacing: Sizes.borderWidth1,
          childAspectRatio: itemWidth / itemHeight,
        ),
        itemCount: crossAxisCount * 3,
        itemBuilder: (context, index) {
          return Container(
            width: itemWidth,
            height: itemHeight,
            color: Colors.white,
          );
        },
      ),
    );
  }
}

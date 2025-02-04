import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';

class SkeletonBodyCheckWidget extends StatelessWidget {
  const SkeletonBodyCheckWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 메인 이미지 영역
        Shimmer.fromColors(
          baseColor: ColorName.darkBackground2,
          highlightColor: ColorName.darkSkeletonBase,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),
        ),
        Shimmer.fromColors(
          baseColor: ColorName.darkBackground3,
          highlightColor: ColorName.darkSkeletonHighlight,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                left: Sizes.spacing16,
                right: Sizes.spacing16,
                bottom: Sizes.spacing16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: constraints.maxWidth / 2,
                            height: 20,
                            color: Colors.white,
                          ),
                        ],
                      );
                    },
                  ),
                  Gaps.v16,
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: Sizes.spacing20),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

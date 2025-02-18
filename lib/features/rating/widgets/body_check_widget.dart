import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/buttons/custom_icon_button.dart';
import 'package:thunder/core/widgets/thunder_network_image.dart';
import 'package:thunder/features/rating/models/data/body_check_data.dart';
import 'package:thunder/features/rating/widgets/rating_widget.dart';

class BodyCheckWidget extends StatelessWidget {
  final BodyCheckData bodyCheckData;
  final int rating; // 1~5
  final Function(int targetRating)? onRatingChanged;
  final Function()? onRatingComplete;
  final VoidCallback? onMoreTap;
  // For User Guide Line
  final bool noRating;

  const BodyCheckWidget({
    super.key,
    required this.bodyCheckData,
    required this.rating,
    this.onRatingChanged,
    this.onRatingComplete,
    this.onMoreTap,
    this.noRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ThunderNetworkImage(imageUrl: bodyCheckData.imageUrl),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(
              right: Sizes.spacing16,
              bottom: Sizes.spacing16,
              left: Sizes.spacing16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.75),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUserSection(context),
                Gaps.v16,
                if (!noRating)
                  RatingWidget(
                    rating: rating,
                    onRatingChanged: onRatingChanged,
                    onRatingComplete: onRatingComplete,
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.spacing20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Sizes.spacing56,
                          height: Sizes.spacing56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              onRatingChanged?.call(1);
                              onRatingComplete?.call();
                            },
                            padding: EdgeInsets.all(0),
                            iconSize: Sizes.icon36,
                            color: ColorName.darkGray3,
                            icon: Icon(Icons.close),
                          ),
                        ),
                        Gaps.h32,
                        Container(
                          width: Sizes.spacing56,
                          height: Sizes.spacing56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              onRatingChanged?.call(5);
                              onRatingComplete?.call();
                            },
                            padding: EdgeInsets.all(0),
                            iconSize: Sizes.icon32,
                            color: ColorName.darkRed,
                            icon: Icon(Icons.favorite),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserSection(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Row(
      children: [
        Text(
          bodyCheckData.nickname,
          style: textTheme.textTitle24,
        ),
        Gaps.h8,
        Text(
          '${bodyCheckData.age}',
          style: textTheme.textTitle24.copyWith(fontWeight: FontWeight.w400),
        ),
        Spacer(),
        CustomIconButton(
          icon: ThunderIcons.moreVert,
          onTap: onMoreTap,
        ),
      ],
    );
  }
}

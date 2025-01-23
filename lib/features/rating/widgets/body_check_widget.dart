import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/thunder_network_image.dart';
import 'package:thunder/features/rating/models/data/body_check_data.dart';
import 'package:thunder/features/rating/widgets/rating_widget.dart';

class BodyCheckWidget extends StatelessWidget {
  final BodyCheckData bodyCheckData;
  final int rating; // 1~5
  final Function(int targetRating)? onRatingChanged;
  final Function()? onRatingComplete;
  final VoidCallback? onMoreTap;

  const BodyCheckWidget({
    super.key,
    required this.bodyCheckData,
    required this.rating,
    this.onRatingChanged,
    this.onRatingComplete,
    this.onMoreTap,
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
                RatingWidget(
                  rating: rating,
                  onRatingChanged: onRatingChanged,
                  onRatingComplete: onRatingComplete,
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onMoreTap,
            customBorder: CircleBorder(),
            child: Icon(
              ThunderIcons.moreVert,
              color: ColorName.white,
            ),
          ),
        ),
      ],
    );
  }
}

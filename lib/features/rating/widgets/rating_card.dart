import 'package:flutter/material.dart';
import 'package:thunder/core/constants/body_check_const.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/features/rating/models/data/body_check_data.dart';

class RatingWidget extends StatelessWidget {
  final BodyCheckData bodyCheckData;
  final int rating; // 1~5
  final Function(int targetRating)? onRatingChanged;
  final Function()? onRatingComplete;
  final VoidCallback? onMoreTap;

  const RatingWidget({
    super.key,
    required this.bodyCheckData,
    required this.rating,
    this.onRatingChanged,
    this.onRatingComplete,
    this.onMoreTap,
  });

  final _iconWidth = 33;
  final _totalIcons = 5;
  final _iconSpacing = Sizes.spacing20;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          bodyCheckData.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
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
                _buildRatingSection(),
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

  Widget _buildRatingSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (details) => _handleHorizontalDragUpdate(
            details.localPosition.dx,
            constraints.maxWidth,
          ),
          onTapDown: (details) => _handleTapDown(
            details.localPosition.dx,
            constraints.maxWidth,
          ),
          onTapUp: (_) => onRatingComplete?.call(),
          onHorizontalDragEnd: (_) => onRatingComplete?.call(),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: Sizes.spacing20),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: _iconSpacing,
                children: List.generate(
                  _totalIcons,
                  (index) {
                    final isActive = index < rating;
                    return GestureDetector(
                      child: Opacity(
                        opacity: isActive ? 1.0 : 0.5,
                        child: Assets.images.logos.thunderSymbolW.svg(
                          width: _iconWidth.toDouble(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  int _calculateRating(double dx, double maxWidth) {
    final containerWidth =
        (_iconWidth * _totalIcons) + (_iconSpacing * (_totalIcons - 1));
    final startX = (maxWidth - containerWidth) / 2; // 중앙 정렬 보정
    final adjustedDx = dx - startX; // 보정된 X 좌표

    return (adjustedDx / (_iconWidth + _iconSpacing))
        .ceil()
        .clamp(RatingConst.minRating, RatingConst.maxRating);
  }

  void _handleHorizontalDragUpdate(double dx, double maxWidth) {
    final newRating = _calculateRating(dx, maxWidth);
    onRatingChanged?.call(newRating);
  }

  void _handleTapDown(double dx, double maxWidth) {
    final newRating = _calculateRating(dx, maxWidth);
    // 현재 별점과 새로운 별점이 같으면 이전 별점으로 변경
    onRatingChanged?.call(newRating == rating ? newRating - 1 : newRating);
  }
}

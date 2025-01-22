import 'package:flutter/widgets.dart';
import 'package:thunder/core/constants/body_check_const.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';

class RatingWidget extends StatelessWidget {
  final int rating;
  final Function(int)? onRatingChanged;
  final Function()? onRatingComplete;

  const RatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.onRatingComplete,
  });

  final _iconWidth = 33;
  final _totalIcons = 5;
  final _iconSpacing = Sizes.spacing20;

  @override
  Widget build(BuildContext context) {
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
                    return Opacity(
                      opacity: isActive ? 1.0 : 0.5,
                      child: Assets.images.logos.thunderSymbolW.svg(
                        width: _iconWidth.toDouble(),
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

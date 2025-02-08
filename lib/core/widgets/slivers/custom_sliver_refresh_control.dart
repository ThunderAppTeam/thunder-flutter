import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';

class CustomSliverRefreshControl extends StatelessWidget {
  final RefreshCallback? onRefresh;
  const CustomSliverRefreshControl({super.key, this.onRefresh});

  final double _kActivityIndicatorMargin = 16.0;

  final double _indicatorSize = Sizes.circularIndicatorSize32;
  final double _indicatorStrokeWidth = Sizes.circularIndicatorStrokeWidth3;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      builder: (
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
      ) {
        final double percentageComplete =
            clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: _kActivityIndicatorMargin,
                left: 0.0,
                right: 0.0,
                child: _buildIndicatorForRefreshState(
                    refreshState, _indicatorSize, percentageComplete),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndicatorForRefreshState(RefreshIndicatorMode refreshState,
      double size, double percentageComplete) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        const Curve opacityCurve = Interval(0.0, 0.35, curve: Curves.easeInOut);
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: Center(
            child: CustomCircularIndicator(
              size: size,
              strokeWidth: _indicatorStrokeWidth,
              value: percentageComplete,
            ),
          ),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        return Center(
          child: CustomCircularIndicator(
              size: size, strokeWidth: _indicatorStrokeWidth),
        );
      case RefreshIndicatorMode.done:
        final sizeCurve = Interval(0.0, 0.4, curve: Curves.easeInOut);
        final opacityCurve = Interval(0.0, 0.6, curve: Curves.easeInOut);
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: Center(
            child: CustomCircularIndicator(
              size: size * sizeCurve.transform(percentageComplete),
              strokeWidth: _indicatorStrokeWidth *
                  sizeCurve.transform(percentageComplete),
            ),
          ),
        );
      case RefreshIndicatorMode.inactive:
        return const SizedBox.shrink();
    }
  }
}

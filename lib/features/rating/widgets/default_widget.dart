import 'package:flutter/widgets.dart';
import 'package:thunder/core/theme/constants/sizes.dart';

class DefaultCard extends StatelessWidget {
  const DefaultCard({super.key, this.color, required this.child});
  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.radius16),
        color: color,
      ),
      child: child,
    );
  }
}

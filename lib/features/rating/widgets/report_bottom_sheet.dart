import 'package:flutter/widgets.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';

class ReportBottomSheet extends StatelessWidget {
  const ReportBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      title: "신고",
    );
  }
}

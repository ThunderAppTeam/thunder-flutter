import 'package:flutter/material.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/generated/l10n.dart';

class SurveyResult {
  final int index;
  final bool isOtherOption;
  final String? otherOptionText;

  SurveyResult({
    required this.index,
    this.isOtherOption = false,
    this.otherOptionText,
  });

  @override
  String toString() {
    return 'SurveyResult(index: $index, isOtherOption: $isOtherOption, otherOptionText: $otherOptionText)';
  }
}

class SurveyBottomSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final String buttonText;
  final VoidCallback onButtonTap;
  final bool hasOtherOption;

  const SurveyBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.buttonText,
    required this.onButtonTap,
    this.hasOtherOption = false,
  });

  @override
  State<SurveyBottomSheet> createState() => _SurveyBottomSheetState();
}

class _SurveyBottomSheetState extends State<SurveyBottomSheet> {
  int? _selectedIndex;
  String? _otherOptionText;
  bool get _isOtherSelected =>
      widget.hasOtherOption && _selectedIndex == widget.options.length - 1;

  @override
  Widget build(BuildContext context) {
    final textTheme = getTextTheme(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          color: ColorName.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Sizes.radius24),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Home Indicator
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: Sizes.spacing8),
                  width: Sizes.homeIndicatorWidth60,
                  height: Sizes.homeIndicatorHeight5,
                  decoration: BoxDecoration(
                    color: ColorName.darkFill2,
                    borderRadius: BorderRadius.circular(Sizes.radius16),
                  ),
                ),
              ),
              // Title Section
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.spacing12,
                  horizontal: Sizes.spacing16,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ColorName.darkLine2,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.title,
                      style: textTheme.textTitle24
                          .copyWith(color: ColorName.black),
                    ),
                  ],
                ),
              ),
              // Content Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: Sizes.spacing16,
                          left: Sizes.spacing16,
                          right: Sizes.spacing16,
                          bottom: Sizes.spacing24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).surveyTitle,
                              style: textTheme.textBody18.copyWith(
                                fontSize: Sizes.fontSize22,
                                color: ColorName.black,
                              ),
                            ),
                            Gaps.v12,
                            Text(
                              S.of(context).surveySubtitle,
                              style: textTheme.textBody16.copyWith(
                                color: ColorName.darkGray3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: Sizes.spacing16,
                        ),
                        child: Column(
                          children: List.generate(
                            widget.options.length,
                            (index) => InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: Sizes.spacing16,
                                  right: Sizes.spacing16,
                                  top: Sizes.spacing8 +
                                      (index > 0 ? Sizes.spacing4 : 0),
                                  bottom: Sizes.spacing8 +
                                      (index < widget.options.length - 1
                                          ? Sizes.spacing4
                                          : 0),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Sizes.icon24,
                                      height: Sizes.icon24,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: ColorName.black,
                                            width: Sizes.borderWidth2,
                                          ),
                                        ),
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration: Styles.duration100,
                                            width: _selectedIndex == index
                                                ? Sizes.icon12
                                                : 0,
                                            height: _selectedIndex == index
                                                ? Sizes.icon12
                                                : 0,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: ColorName.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.h12,
                                    Text(
                                      widget.options[index],
                                      style: textTheme.textBody18.copyWith(
                                        color: ColorName.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_isOtherSelected)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: Sizes.spacing16,
                            left: Sizes.spacing16,
                            right: Sizes.spacing16,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Sizes.radius4),
                              border: Border.all(
                                color: ColorName.black.withOpacity(0.8),
                                width: Sizes.borderWidth1,
                              ),
                            ),
                            padding: EdgeInsets.all(Sizes.spacing10),
                            child: TextField(
                              maxLines: 3,
                              maxLength: 200,
                              scrollPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              onChanged: (value) {
                                _otherOptionText = value;
                              },
                              decoration: InputDecoration(
                                counterStyle: textTheme.textBody12.copyWith(
                                  color: ColorName.darkGray3,
                                ),
                                hintStyle: textTheme.textBody18.copyWith(
                                  color: ColorName.darkGray3,
                                ),
                                border: InputBorder.none,
                              ),
                              style: textTheme.textBody18.copyWith(
                                color: ColorName.black,
                                height: Sizes.fontHeight14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Button Section
              Padding(
                padding: const EdgeInsets.only(
                  bottom: Sizes.spacing8,
                  right: Sizes.spacing16,
                  left: Sizes.spacing16,
                ),
                child: CustomWideButton(
                  backgroundColor: ColorName.black,
                  textColor: ColorName.white,
                  text: widget.buttonText,
                  isEnabled: _selectedIndex != null,
                  onPressed: () {
                    widget.onButtonTap();
                    Navigator.of(context).pop(
                      SurveyResult(
                        index: _selectedIndex!,
                        isOtherOption: _isOtherSelected,
                        otherOptionText: _otherOptionText,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

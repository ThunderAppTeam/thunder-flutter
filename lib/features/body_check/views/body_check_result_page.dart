import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/enums/gender.dart';
import 'package:thunder/core/services/analytics_service.dart';
import 'package:thunder/core/theme/constants/gaps.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/theme/gen/assets.gen.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/theme/icon/thunder_icons_icons.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/utils/theme_utils.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';
import 'package:thunder/core/widgets/bottom_sheets/action_bottom_sheet.dart';
import 'package:thunder/core/widgets/buttons/custom_wide_button.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/core/widgets/dialog/custom_alert_dialog.dart';
import 'package:thunder/core/widgets/thunder_network_image.dart';
import 'package:thunder/features/archive/view_models/archive_view_model.dart';
import 'package:thunder/features/body_check/view_models/body_check_result_view_model.dart';
import 'package:thunder/generated/l10n.dart';

class BodyCheckResultPage extends ConsumerStatefulWidget {
  final int bodyPhotoId;
  final bool fromUpload;
  final String imageUrl;
  final String? pointText;

  const BodyCheckResultPage({
    super.key,
    required this.bodyPhotoId,
    this.fromUpload = false,
    required this.imageUrl,
    this.pointText,
  });

  @override
  ConsumerState<BodyCheckResultPage> createState() =>
      _BodyCheckResultPageState();
}

class _BodyCheckResultPageState extends ConsumerState<BodyCheckResultPage> {
  bool _isAnimationStarted = false;
  bool _isAnimationCompleted = false;
  final Duration _animationDuration = const Duration(milliseconds: 500);
  late final BodyCheckResultViewModel _viewModel;
  final GlobalKey _shareKey = GlobalKey();
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.viewBodyResult(widget.bodyPhotoId);
      Future.delayed(
          // 페이지 완전 전환 보단 약간 빠르게 시작
          Styles.pageTransitionDuration500 - Duration(milliseconds: 200), () {
        setState(() {
          _isAnimationStarted = true;
        });
      });
    });
    _viewModel = ref.read(bodyCheckResultProvider(widget.bodyPhotoId).notifier);
  }

  void _onError(BuildContext context) {
    showCommonUnknownErrorBottomSheet(context);
  }

  void _onDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: S.of(context).bodyCheckResultDeleteTitle,
        subtitle: S.of(context).bodyCheckResultDeleteSubtitle,
        confirmText: S.of(context).commonDelete,
        cancelText: S.of(context).commonCancel,
      ),
    );
    if (confirmed == true && context.mounted) {
      final deleted = await _viewModel.deleteBodyCheckResult();
      if (deleted) {
        ref
            .read(archiveViewModelProvider.notifier)
            .removeItem(widget.bodyPhotoId);
        if (mounted) {
          if (widget.fromUpload) {
            ref.read(safeRouterProvider).goToHome(context);
          } else {
            ref.read(safeRouterProvider).pop(context);
          }
        }
      }
    }
  }

  void _onMoreTap() {
    final modalActions = [
      ModalActionItem(text: S.of(context).commonDelete, onTap: _onDelete),
    ];
    showActionBottomSheet(context, modalActions);
  }

  Widget _buildAnimatedOpacity({
    required bool hasValue,
    required Widget child,
  }) {
    return AnimatedOpacity(
      opacity: _isAnimationStarted && hasValue ? 1.0 : 0.0,
      duration: _animationDuration,
      curve: Curves.linear,
      child: child,
      onEnd: () {
        setState(() {
          _isAnimationCompleted = true;
        });
      },
    );
  }

  void _onShare() async {
    if (_isSharing) return; // 이미 공유 중이면 무시
    setState(() {
      _isSharing = true;
    });

    try {
      // 1) RepaintBoundary의 RenderObject 가져오기
      RenderRepaintBoundary? boundary = _shareKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) return;

      // 2) 이미지를 만들어서 Byte 형식으로 변환
      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      // 3) 임시 폴더에 저장
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/share_screenshot.png');
      await file.writeAsBytes(pngBytes);

      // 4) Share 패키지를 이용해 공유 시트 표시
      if (mounted) {
        final result = await Share.shareXFiles([XFile(file.path)],
            subject: S.of(context).bodyCheckResultShareTitle);
        if (result.status == ShareResultStatus.success) {
          AnalyticsService.share(widget.bodyPhotoId);
        }
        await file.delete();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultState = ref.watch(bodyCheckResultProvider(widget.bodyPhotoId));
    final textTheme = getTextTheme(context);
    ref.listen(bodyCheckResultProvider(widget.bodyPhotoId), (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        _onError(context);
      }
    });

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).bodyCheckResultTitle,
          actions: [
            CustomAppBarAction(
              type: CustomAppBarActionType.icon,
              icon: ThunderIcons.moreHoriz,
              onTap: _onMoreTap,
            ),
            if (widget.fromUpload)
              CustomAppBarAction(
                type: CustomAppBarActionType.icon,
                icon: ThunderIcons.closeSquareLight,
                onTap: () {
                  ref
                      .read(safeRouterProvider)
                      .goNamed(context, Routes.archive.name);
                },
              ),
          ],
          showBackButton: !widget.fromUpload,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            bottom: Sizes.spacing8,
          ),
          child: Column(
            children: [
              Expanded(
                  child: RepaintBoundary(
                key: _shareKey,
                child: Stack(
                  children: [
                    Hero(
                      tag: 'body_check_image_${widget.bodyPhotoId}',
                      child: ThunderNetworkImage(
                        imageUrl: resultState.maybeWhen(
                          data: (result) => result.imageUrl,
                          orElse: () => widget.imageUrl,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: _animationDuration,
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(Sizes.spacing16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(
                                  _isAnimationStarted && resultState.hasValue
                                      ? 0.25
                                      : 0.0),
                              Colors.black.withOpacity(
                                  _isAnimationStarted && resultState.hasValue
                                      ? 0.5
                                      : 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAnimatedOpacity(
                              hasValue: resultState.hasValue,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Assets.images.logos.thunderSymbolW.svg(
                                          height: 30,
                                        ),
                                        Gaps.h8,
                                        if (widget.pointText != null)
                                          Text(
                                            widget.pointText!,
                                            style: textTheme.textHead32,
                                          )
                                        else
                                          Text(
                                            resultState.maybeWhen(
                                              data: (result) =>
                                                  result.reviewCount == 0
                                                      ? '?.?'
                                                      : result.reviewScore
                                                          .toString(),
                                              orElse: () => '?.?',
                                            ),
                                            style: textTheme.textHead32,
                                          ),
                                      ],
                                    ),
                                  ),
                                  Text('점', style: textTheme.textTitle16),
                                ],
                              ),
                            ),
                            Gaps.v12,
                            _buildAnimatedOpacity(
                              hasValue: resultState.hasValue,
                              child: resultState.maybeWhen(
                                data: (result) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          result.isReviewCompleted
                                              ? '최근 30일 기준 ${result.gender.toDisplayString(context)} 상위 ${result.genderTopRate.toStringAsFixed(0)}%'
                                              : '눈바디 측정 중... ${result.progressRate.toStringAsFixed(0)}% 완료',
                                          style: textTheme.textBody16,
                                        ),
                                        if (!result.isReviewCompleted) ...[
                                          Gaps.h4,
                                          CustomCircularIndicator(
                                            size: Sizes.circularIndicatorSize18,
                                            strokeWidth: Sizes
                                                .circularIndicatorStrokeWidth2,
                                          ),
                                        ],
                                      ],
                                    ),
                                    Assets.images.logos.thunderLogotypeW.svg(
                                      height: Sizes.fontSize16,
                                      colorFilter: ColorFilter.mode(
                                        ColorName.white.withOpacity(0.8),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                                orElse: () =>
                                    const SizedBox(height: Sizes.spacing16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Gaps.v16,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Sizes.spacing16),
                child: CustomWideButton(
                  text: S.of(context).commonShare,
                  isEnabled: !_isSharing &&
                      _isAnimationCompleted &&
                      resultState.maybeWhen(
                        data: (result) => result.isReviewCompleted,
                        orElse: () => false,
                      ),
                  onPressed: _onShare,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

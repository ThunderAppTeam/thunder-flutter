import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/core/widgets/empty_widget.dart';
import 'package:thunder/features/archive/models/data/body_check_preview_data.dart';
import 'package:thunder/features/archive/view_models/archive_view_model.dart';
import 'package:thunder/features/archive/views/widgets/archive_item.dart';
import 'package:thunder/generated/l10n.dart';

class ArchivePage extends ConsumerStatefulWidget {
  const ArchivePage({super.key});

  @override
  ConsumerState<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends ConsumerState<ArchivePage> {
  final int _crossAxisCount = 3;
  final AutoScrollController _scrollController =
      AutoScrollController(); // AutoScrollController 사용

  void _onButtonTap() {
    ref.read(safeRouterProvider).pushNamed(context, Routes.measure.name);
  }

  void _onError(error) {
    log('error: $error');
    showCommonUnknownErrorBottomSheet(context);
  }

  void _onItemTap(BodyCheckPreviewData item, int index) async {
    // 페이지 이동
    ref.read(safeRouterProvider).pushNamed(
      context,
      Routes.bodyCheck.name,
      pathParameters: {
        KeyConst.bodyPhotoId: item.bodyPhotoId.toString(),
      },
      extra: {
        KeyConst.imageUrl: item.imageUrl,
        KeyConst.pointText:
            item.reviewCount == 0 ? '?.?' : item.reviewScore.toString(),
      },
    );
    _scrollController.scrollToIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final archive = ref.watch(archiveViewModelProvider);
    ref.listen(archiveViewModelProvider, (previous, next) {
      if (next.error != null && !next.isLoading) {
        _onError(next.error);
      }
    });
    return Scaffold(
      backgroundColor: ColorName.darkBackground2,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / _crossAxisCount;
          final itemHeight = constraints.maxHeight / _crossAxisCount;
          return archive.when(
            data: (items) {
              if (items.isEmpty) {
                return EmptyWidget(
                  guideText: S.of(context).archiveEmptyGuideText,
                  buttonText: S.of(context).archiveEmptyButtonText,
                  onButtonTap: _onButtonTap,
                );
              }
              return GridView.builder(
                controller: _scrollController, // AutoScrollController 적용
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount,
                  crossAxisSpacing: Sizes.borderWidth1,
                  mainAxisSpacing: Sizes.borderWidth1,
                  childAspectRatio: itemWidth / itemHeight,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return AutoScrollTag(
                    // 스크롤 태그 추가
                    key: ValueKey(index),
                    controller: _scrollController,
                    index: index,
                    child: GestureDetector(
                      onTap: () => _onItemTap(item, index),
                      child: SizedBox(
                        width: itemWidth,
                        height: itemHeight,
                        child: ArchiveItem(item: item),
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stack) => const SizedBox.shrink(),
            loading: () => const Center(child: CustomCircularIndicator()),
          );
        },
      ),
    );
  }
}

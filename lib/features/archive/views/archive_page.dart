import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/constants/key_contst.dart';
import 'package:thunder/core/services/log_service.dart';
import 'package:thunder/core/theme/constants/sizes.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/utils/event_control/debouncer.dart';
import 'package:thunder/core/utils/show_utils.dart';
import 'package:thunder/core/widgets/empty_widget.dart';
import 'package:thunder/core/widgets/slivers/custom_sliver_refresh_control.dart';
import 'package:thunder/features/archive/models/data/body_check_preview_data.dart';
import 'package:thunder/features/archive/view_models/archive_view_model.dart';
import 'package:thunder/features/archive/views/widgets/archive_item.dart';
import 'package:thunder/features/archive/views/widgets/skeleton_archive_widget.dart';
import 'package:thunder/generated/l10n.dart';

class ArchivePage extends ConsumerStatefulWidget {
  const ArchivePage({super.key});

  @override
  ConsumerState<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends ConsumerState<ArchivePage> {
  final int _crossAxisCount = 3;
  final AutoScrollController _scrollController = AutoScrollController();
  final _refreshDebouncer = Debouncer(duration: const Duration(seconds: 1));
  @override
  void dispose() {
    _refreshDebouncer.dispose();
    super.dispose();
  }

  void _onButtonTap() {
    ref.read(safeRouterProvider).pushNamed(context, Routes.camera.name);
  }

  void _onError(error) {
    LogService.error('error: $error');
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

  Future<void> _onRefresh() async {
    await _refreshDebouncer.run(() async {
      await ref.read(archiveViewModelProvider.notifier).refresh(
            keepPreviousData: true,
          );
    });
  }

  SliverGrid _buildGrid(
    List<BodyCheckPreviewData> items, {
    required double itemWidth,
    required double itemHeight,
  }) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        crossAxisSpacing: Sizes.borderWidth1,
        mainAxisSpacing: Sizes.borderWidth1,
        childAspectRatio: itemWidth / itemHeight,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return AutoScrollTag(
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
        childCount: items.length,
      ),
    );
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
      body: LayoutBuilder(builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / _crossAxisCount;
        final itemHeight = constraints.maxHeight / _crossAxisCount;
        return CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            CustomSliverRefreshControl(onRefresh: _onRefresh),
            // CupertinoSliverRefreshControl(onRefresh: _onRefresh),
            archive.maybeWhen(
              skipError: true,
              data: (items) {
                if (items.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyWidget(
                      onButtonTap: _onButtonTap,
                      guideText: S.of(context).archiveEmptyGuideText,
                      buttonText: S.of(context).archiveEmptyButtonText,
                    ),
                  );
                }
                return _buildGrid(items,
                    itemWidth: itemWidth, itemHeight: itemHeight);
              },
              loading: () => archive.value == null
                  ? SliverFillRemaining(
                      child: SkeletonArchiveWidget(
                        crossAxisCount: _crossAxisCount,
                        itemWidth: itemWidth,
                        itemHeight: itemHeight,
                      ),
                    )
                  : _buildGrid(
                      archive.value!,
                      itemWidth: itemWidth,
                      itemHeight: itemHeight,
                    ),
              orElse: () => const SliverFillRemaining(
                child: SizedBox.shrink(),
              ),
            ),
          ],
        );
      }),
    );
  }
}

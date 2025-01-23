import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';
import 'package:thunder/core/theme/gen/colors.gen.dart';
import 'package:thunder/core/widgets/bottom_sheets/custom_bottom_sheet.dart';
import 'package:thunder/core/widgets/custom_circular_indicator.dart';
import 'package:thunder/core/widgets/empty_widget.dart';
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

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    ref.read(archiveViewModelProvider.notifier).refresh();
  }

  void _onButtonTap() {
    // 카메라 페이지로 이동
    ref.read(safeRouterProvider).pushNamed(context, Routes.measure.name);
  }

  void _onError(error) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(
        title: S.of(context).commonErrorUnknownTitle,
        subtitle: S.of(context).commonErrorUnknownSubtitle,
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
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: ColorName.white,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    crossAxisSpacing: 1, // 1px 간격
                    mainAxisSpacing: 1, // 1px 간격
                    childAspectRatio: itemWidth / itemHeight, // 추가: 가로/세로 비율 지정
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return SizedBox(
                      width: itemWidth,
                      height: itemHeight,
                      child: ArchiveItem(item: item),
                    );
                  },
                ),
              );
            },
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
            loading: () => const CustomCircularIndicator(),
          );
        },
      ),
    );
  }
}

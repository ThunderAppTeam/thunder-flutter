import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/theme/constants/styles.dart';
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';

class PhotoPreviewPage extends ConsumerWidget {
  final String imagePath;

  const PhotoPreviewPage({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: '사진 미리보기',
          actionText: '완료',
          onAction: () {
            // 눈바디 측정 결과 대기화면으로 이동
          },
        ),
        body: Center(
          child: AspectRatio(
            aspectRatio: Styles.cameraPreviewAspectRatio,
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

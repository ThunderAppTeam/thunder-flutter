import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:thunder/core/widgets/app_bars/custom_app_bar.dart';

class CroppedImagePreviewPage extends StatelessWidget {
  final File compressedFile;
  final img.Image originalImage;
  final img.Image croppedImage;
  final img.Image resizedImage;

  const CroppedImagePreviewPage({
    super.key,
    required this.compressedFile,
    required this.originalImage,
    required this.croppedImage,
    required this.resizedImage,
  });

  String _formatFileSize(int size) {
    if (size < 1024) return "$size bytes";
    if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(2)} KB";
    return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: '크롭된 이미지 정보',
          actionText: '확인',
          onAction: () => Navigator.pop(context),
        ),
        body: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.file(
                  compressedFile,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '원본 이미지:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('해상도: ${originalImage.width}x${originalImage.height}'),
                    Text('파일 크기: ${_formatFileSize(originalImage.length)}'),
                    const SizedBox(height: 16),
                    const Text(
                      '크롭된 이미지:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('해상도: ${croppedImage.width}x${croppedImage.height}'),
                    Text('파일 크기: ${_formatFileSize(croppedImage.length)}'),
                    const SizedBox(height: 16),
                    const Text(
                      '리사이즈된 이미지:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('해상도: ${resizedImage.width}x${resizedImage.height}'),
                    Text('파일 크기: ${_formatFileSize(resizedImage.length)}'),
                    const SizedBox(height: 16),
                    const Text(
                      '압축된 이미지 (75%):',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('해상도: ${resizedImage.width}x${resizedImage.height}'),
                    Text(
                        '파일 크기: ${_formatFileSize(compressedFile.lengthSync())}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter/services.dart';

String formatFileSize(int size) {
  if (size < 1024) return "$size bytes";
  if (size < 1024 * 1024) return "${(size / 1024).toStringAsFixed(2)} KB";
  return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
}

Future<void> logImageInfo(String title, Uint8List imageBytes) async {
  final originalImage = await decodeImageFromList(imageBytes);
  final originalSizeKB = (imageBytes.length / 1000).toStringAsFixed(2);
  final originalMB = (imageBytes.length / (1000 * 1000)).toStringAsFixed(2);

  log('''
  $title:
  - Resolution: ${originalImage.width} x ${originalImage.height}
  - Size: $originalSizeKB KB ($originalMB MB)
  ''');
}

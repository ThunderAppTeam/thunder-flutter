import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

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

Future<void> clearImage(String filePath) async {
  final tempFile = File(filePath);

  if (await tempFile.exists()) {
    await tempFile.delete();
  } else {
    throw Exception('Image file not found: $filePath');
  }
}

Future<void> clearFolder(Directory folder) async {
  if (await folder.exists()) {
    final files = folder.listSync();
    if (files.isEmpty) {
      await folder.delete();
    }
  }
}

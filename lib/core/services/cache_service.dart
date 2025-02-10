import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thunder/core/services/log_service.dart';

class CacheService {
  static const int _maxCacheAgeDays = 7;
  static const int _maxCacheSizeMB = 100;

  static Future<Directory> _getImagesCacheDirectory() async {
    final cacheDir = await getTemporaryDirectory();
    final imagesDir = Directory('${cacheDir.path}/$cacheImageFolderName');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  static Future<String> getNewImagePath() async {
    final imagesDir = await _getImagesCacheDirectory();
    return '${imagesDir.path}${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  static Future<void> cleanCache() async {
    LogService.info('Cleaning cache');
    await cleanOldCache();
    await limitCacheSize();
  }

  // 오래된 캐시만 정리
  static Future<void> cleanOldCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      LogService.trace('Cache directory: ${cacheDir.path}');
      final now = DateTime.now();
      if (await cacheDir.exists()) {
        await for (var entity in cacheDir.list(recursive: true)) {
          if (entity is File) {
            final lastModified = entity.statSync().modified;
            if (now.difference(lastModified).inDays >= _maxCacheAgeDays) {
              await entity.delete();
            }
          }
        }
      }
    } catch (e) {
      LogService.error('Cache cleanup error: $e');
    }
  }

  // 캐시 크기 제한
  static Future<void> limitCacheSize() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      int totalSize = 0;

      final files = await cacheDir
          .list(recursive: true)
          .where((entity) => entity is File)
          .toList();

      for (var file in files) {
        if (file is File) {
          totalSize += await file.length();
        }
      }

      // 최대 크기 초과시 오래된 파일부터 삭제
      if (totalSize > _maxCacheSizeMB * 1024 * 1024) {
        files.sort(
            (a, b) => a.statSync().modified.compareTo(b.statSync().modified));

        for (var file in files) {
          if (file is File) {
            await file.delete();
            totalSize -= await file.length();
            if (totalSize <= _maxCacheSizeMB * 1024 * 1024) break;
          }
        }
      }
    } catch (e) {
      LogService.error('Cache size limit error: $e');
    }
  }
}

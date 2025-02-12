import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thunder/core/services/log_service.dart';

class CacheService {
  static const int _maxCacheAgeDays = 7;
  static const int _maxCacheSizeMB = 50;
  static const int _mbSize = 1024 * 1024;

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
    LogService.info('Starting cache cleanup...');
    final cacheDir = await getTemporaryDirectory();
    if (await cacheDir.exists()) {
      final oldCacheResult = await cleanOldCache(cacheDir);
      final sizeLimitResult = await limitCacheSize(cacheDir);
      // 최종 결과 로깅
      if (oldCacheResult.deletedCount > 0 || sizeLimitResult.deletedCount > 0) {
        LogService.debug('Cache cleanup completed:\n'
            '- Old files removed: ${oldCacheResult.deletedCount} (${oldCacheResult.deletedSizeMB.toStringAsFixed(2)}MB)\n'
            '- Size limit cleanup: ${sizeLimitResult.deletedCount} (${sizeLimitResult.deletedSizeMB.toStringAsFixed(2)}MB)');
      } else {
        LogService.debug('No cache cleanup needed');
      }
    }
  }

// 오래된 캐시만 정리
  static Future<CleanupResult> cleanOldCache(Directory cacheDir) async {
    try {
      final now = DateTime.now();
      final targetFiles = <FileInfo>[];
      int deletedCount = 0;
      int deletedSize = 0;
      await for (var entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final stat = entity.statSync();
            if (now.difference(stat.modified).inDays >= _maxCacheAgeDays) {
              targetFiles.add(FileInfo(entity, stat.size, stat.modified));
            }
          } catch (_) {
            continue;
          }
        }
      }
      for (var fileInfo in targetFiles) {
        await fileInfo.file.delete();
        deletedSize += fileInfo.size;
        deletedCount++;
      }
      return CleanupResult(deletedCount, deletedSize / _mbSize);
    } catch (e) {
      LogService.error('Old cache cleanup error: $e');
      return CleanupResult(0, 0);
    }
  }

  static Future<CleanupResult> limitCacheSize(Directory cacheDir) async {
    try {
      int totalSize = 0;
      final validFiles = <FileInfo>[];
      await for (final entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final stat = entity.statSync();
            totalSize += stat.size;
            validFiles.add(FileInfo(entity, stat.size, stat.modified));
          } catch (_) {
            continue;
          }
        }
      }
      if (totalSize > _maxCacheSizeMB * _mbSize) {
        validFiles.sort((a, b) => a.modified.compareTo(b.modified));
        int deletedCount = 0;
        int deletedSize = 0;

        for (var fileInfo in validFiles) {
          try {
            await fileInfo.file.delete();
            deletedSize += fileInfo.size;
            deletedCount++;
            if ((totalSize - deletedSize) <= _maxCacheSizeMB * _mbSize) {
              break;
            }
          } catch (_) {
            continue;
          }
        }
        return CleanupResult(deletedCount, deletedSize / _mbSize);
      }
      return CleanupResult(0, 0);
    } catch (e) {
      LogService.error('Cache size limit error: $e');
      return CleanupResult(0, 0);
    }
  }
}

// 파일 정보를 담을 클래스
class FileInfo {
  final File file;
  final int size;
  final DateTime modified;
  FileInfo(this.file, this.size, this.modified);
}

class CleanupResult {
  final int deletedCount;
  final double deletedSizeMB;
  CleanupResult(this.deletedCount, this.deletedSizeMB);
}

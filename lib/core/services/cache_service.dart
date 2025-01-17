import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CacheService {
  static Future<Directory> _getImagesCacheDirectory() async {
    final cacheDir = await getTemporaryDirectory();
    final imagesDir = Directory('${cacheDir.path}/images/');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  static Future<String> getNewImagePath() async {
    final imagesDir = await _getImagesCacheDirectory();
    return '${imagesDir.path}${DateTime.now().millisecondsSinceEpoch}.jpg';
  }
}

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/core/network/dio_provider.dart';

class ArchiveRepository {
  final Dio _dio;

  ArchiveRepository(this._dio);

  Future<List<Map<String, dynamic>>> fetchArchive() async {
    // final path = '/v1/body/archive';
    // final response = await _dio.get(path);
    // return response.data;
    return fetchDummyArchive();
  }

  List<Map<String, dynamic>> fetchDummyArchive() {
    return List.generate(100, generateDummyArchive);
  }

  Map<String, dynamic> generateDummyArchive(int index) {
    return {
      'imageUrl': 'https://picsum.photos/id/${index + 1}/200/300',
      'date': DateTime.now().subtract(Duration(days: index)).toIso8601String(),
      'averageRating': Random().nextDouble() * 10,
    };
  }
}

final archiveRepositoryProvider = Provider<ArchiveRepository>((ref) {
  return ArchiveRepository(ref.read(dioProvider));
});

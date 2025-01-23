import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/archive/repositories/archive_repository.dart';

class BodyCheckPreview {
  final String imageUrl;
  final DateTime date;
  final double averageRating;

  BodyCheckPreview({
    required this.imageUrl,
    required this.date,
    required this.averageRating,
  });

  factory BodyCheckPreview.fromJson(Map<String, dynamic> json) {
    return BodyCheckPreview(
      imageUrl: json['imageUrl'],
      date: DateTime.parse(json['date']),
      averageRating: json['averageRating'],
    );
  }
}

class ArchiveViewModel
    extends AutoDisposeAsyncNotifier<List<BodyCheckPreview>> {
  late final ArchiveRepository _repository;

  @override
  Future<List<BodyCheckPreview>> build() async {
    _repository = ref.read(archiveRepositoryProvider);
    return await _fetchArchive();
  }

  Future<List<BodyCheckPreview>> _fetchArchive() async {
    final archive = await _repository.fetchArchive();
    return archive.map((e) => BodyCheckPreview.fromJson(e)).toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchArchive());
  }
}

final archiveViewModelProvider =
    AutoDisposeAsyncNotifierProvider<ArchiveViewModel, List<BodyCheckPreview>>(
  () => ArchiveViewModel(),
);

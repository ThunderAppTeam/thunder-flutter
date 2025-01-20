import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thunder/features/rating/view_models/rating_view_model.dart';

import 'package:thunder/features/rating/widgets/rating_card.dart';

class RatingPage extends ConsumerStatefulWidget {
  const RatingPage({super.key});

  @override
  ConsumerState<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends ConsumerState<RatingPage>
    with SingleTickerProviderStateMixin {
  int _selectedRating = 0; // 선택된 점수 (1~5)

  void _onRate(int rating) async {
    setState(() {
      _selectedRating = rating; // 선택된 점수 설정
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(bodyCheckListProvider);
    return providerState.when(
      data: (bodyCheckList) {
        return Scaffold(
          body: GestureDetector(
            child: Stack(
              children: bodyCheckList.map((bodyCheckData) {
                return RadingCard(
                  bodyCheckData: bodyCheckData,
                  rating: _selectedRating,
                  onRatingChanged: _onRate,
                );
              }).toList(),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(child: Text('Error: $error')),
        );
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}

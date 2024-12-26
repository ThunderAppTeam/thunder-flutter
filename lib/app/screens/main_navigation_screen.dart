import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thunder/app/router/routes.dart';
import 'package:thunder/app/router/safe_router.dart';

class MainNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationScreen({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    if (index == 1) {
      SafeRouter.pushNamed(context, Routes.camera.name);
      return;
    }
    // 카메라 탭을 건너뛰고 매핑
    final adjustedIndex = index > 1 ? index - 1 : index;
    navigationShell.goBranch(adjustedIndex);
  }

  int _getSelectedIndex() {
    // 브랜치 인덱스를 탭 인덱스로 변환
    final branchIndex = navigationShell.currentIndex;
    return branchIndex >= 1 ? branchIndex + 1 : branchIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getSelectedIndex(),
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: '카메라',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}

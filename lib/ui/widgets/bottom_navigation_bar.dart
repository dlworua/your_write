import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // 현재 선택된 탭 표시
      backgroundColor: const Color(0xFFFFF3C3),
      selectedItemColor: Colors.grey, // 선택된 버튼
      unselectedItemColor: Colors.black, // 선택되지 않은 버튼
      onTap: onTap, // 탭을 클릭 시 실행할 함수 (mainPage에서 처리)
      showSelectedLabels: false, // 선택된 라벨 숨기기
      showUnselectedLabels: false, // 선택되지 않은 라벨 숨기기
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}

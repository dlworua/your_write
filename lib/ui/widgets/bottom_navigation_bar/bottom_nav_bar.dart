import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex; // 현재 선택된 탭 인덱스 (예: 0, 1, 2)
  final ValueChanged<int> onTap; // 탭이 눌렸을 때 호출되는 콜백 함수

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // 팝업 메뉴 띄우는 함수
  void _showPopupMenu(BuildContext context, GlobalKey key) {
    // 프레임이 끝난 후 안전한 시점에 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentContext = key.currentContext;
      if (currentContext == null) return;

      final renderBox = key.currentContext?.findRenderObject();
      if (renderBox is! RenderBox || !renderBox.hasSize) return;

      final Offset position = renderBox.localToGlobal(Offset.zero);
      final Size size = renderBox.size;
      final overlay = Overlay.of(context);

      late OverlayEntry entry;

      entry = OverlayEntry(
        builder:
            (_) => GestureDetector(
              onTap: () => entry.remove(), // 외부 영역 클릭 시 닫힘
              behavior: HitTestBehavior.translucent, // 투명한 영역도 감지
              child: Stack(
                children: [
                  Positioned(
                    left: position.dx - 40,
                    bottom:
                        MediaQuery.of(context).size.height -
                        position.dy +
                        size.height +
                        1, // 위치 조정
                    child: _PopupMenu(
                      onItemSelected: (index) {
                        entry.remove();
                        onTap(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
      );

      overlay.insert(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey iconKey = GlobalKey(); // 목록 아이콘에 부여할 키

    return BottomNavigationBar(
      currentIndex: currentIndex, // 현재 선택된 탭 표시
      backgroundColor: const Color(0xFFFFF3C3),
      selectedItemColor: Colors.grey, // 선택된 버튼
      unselectedItemColor: Colors.black, // 선택되지 않은 버튼
      showSelectedLabels: false, // 선택된 라벨 숨기기
      showUnselectedLabels: false, // 선택되지 않은 라벨 숨기기
      onTap: (index) {
        if (index == 0) {
          _showPopupMenu(context, iconKey); // 메뉴 표시
        } else {
          onTap(index); // 일반 탭 이동
        }
      }, // 탭을 클릭 시 실행할 함수 (mainPage에서 처리)

      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list_rounded, key: iconKey), // 아이콘에 key 부여
          label: '',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}

// 팝업 메뉴 위젯
class _PopupMenu extends StatelessWidget {
  final void Function(int) onItemSelected;

  const _PopupMenu({required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 160,
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 8,
        color: Colors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.smart_toy, color: Colors.green),
                  title: Text('AI 게시판'),
                  onTap: () => onItemSelected(0),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.shuffle, color: Colors.orange),
                  title: Text('랜덤 키워드'),
                  onTap: () => onItemSelected(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

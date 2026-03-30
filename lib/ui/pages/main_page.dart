import 'package:flutter/material.dart';
import 'package:your_write/services/popup_service.dart';
import 'package:your_write/ui/pages/ai/ai_post/ai_page.dart';
import 'package:your_write/ui/pages/home/home_post/home_page.dart';
import 'package:your_write/ui/pages/my_profile/my_profile_page.dart';
import 'package:your_write/ui/pages/random/random_post/random_page.dart';
import 'package:your_write/ui/widgets/app_popup_dialog.dart';
import 'package:your_write/ui/widgets/bottom_navigation_bar/bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  final List<Widget> _pages = const [
    AiPage(),
    HomePage(),
    MyProfilePage(),
    RandomPage(),
  ];

  @override
  void initState() {
    super.initState();
    // 앱 시작 시 팝업 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showStartupPopups();
    });
  }

  Future<void> _showStartupPopups() async {
    try {
      print('[MainPage] 팝업 가져오기 시작...');
      final popups = await PopupService.getPopupsToShow();

      print('[MainPage] 가져온 팝업 개수: ${popups.length}');

      if (popups.isEmpty) {
        print('[MainPage] 표시할 팝업 없음');
        return;
      }

      if (!mounted) {
        print('[MainPage] Widget이 mounted 상태가 아님');
        return;
      }

      print('[MainPage] 팝업 다이얼로그 표시 시작 (${popups.length}개)');

      // 모든 팝업을 하나의 다이얼로그에서 슬라이드로 표시
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AppPopupDialog(popups: popups),
      );

      print('[MainPage] 팝업 다이얼로그 닫힘');
    } catch (e) {
      print('[MainPage] 팝업 표시 실패: $e');
      print('[MainPage] 에러 스택트레이스: ${StackTrace.current}');
    }
  }

  void _onTabTapped(int index) {
    if (index <= 2) {
      setState(() => _currentIndex = index);
    }
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai_post/ai_page.dart';
import 'package:your_write/ui/pages/home/home_page.dart';
import 'package:your_write/ui/pages/my_profile/my_profile_page.dart';
import 'package:your_write/ui/pages/random_post/random_page.dart';
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

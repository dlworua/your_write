import 'package:flutter/material.dart';

class BottomNavigationBar extends StatelessWidget {
  const BottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Category'),
      //     BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Write'),
      //     BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Profile'),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
    );
  }
}

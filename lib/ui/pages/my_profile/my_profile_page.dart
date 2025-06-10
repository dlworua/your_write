import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/my_profile/widgets/post_grid.dart';
import 'package:your_write/ui/pages/my_profile/widgets/profile_header.dart';
import 'package:your_write/ui/pages/my_profile/widgets/tap_filter.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3C3),
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(),
            const FilterTabs(),
            Expanded(child: const PostGrid()),
          ],
        ),
      ),
    );
  }
}

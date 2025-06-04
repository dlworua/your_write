import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_bottom.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_middle.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_top.dart';

class HomePostWidget extends StatelessWidget {
  const HomePostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [HomePostTop(), HomePostMiddle(), HomePostBottom()],
    );
  }
}

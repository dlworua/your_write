import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_bottom.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_middle.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_top.dart';

class RandomPostWidget extends StatelessWidget {
  const RandomPostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [HomePostTop(), HomePostMiddle(), HomePostBottom()],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/widgets/home_post_widget.dart';

class HomePostList extends StatelessWidget {
  const HomePostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HomePostWidget(),
        SizedBox(height: 30),
        HomePostWidget(),
        SizedBox(height: 30),
        HomePostWidget(),
        SizedBox(height: 30),
        HomePostWidget(),
        SizedBox(height: 30),
        HomePostWidget(),
        SizedBox(height: 30),
        HomePostWidget(),
        SizedBox(height: 30),
      ],
    );
  }
}

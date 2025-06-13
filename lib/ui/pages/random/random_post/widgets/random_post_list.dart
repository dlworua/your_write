import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_widget.dart';

class RandomPostList extends StatelessWidget {
  const RandomPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RandomPostWidget(),
        SizedBox(height: 30),
        RandomPostWidget(),
        SizedBox(height: 30),
        RandomPostWidget(),
        SizedBox(height: 30),
        RandomPostWidget(),
        SizedBox(height: 30),
        RandomPostWidget(),
        SizedBox(height: 30),
        RandomPostWidget(),
        SizedBox(height: 30),
      ],
    );
  }
}

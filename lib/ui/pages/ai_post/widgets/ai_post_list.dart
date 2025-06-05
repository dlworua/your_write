import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai_post/widgets/ai_post_widget.dart';

class AiPostList extends StatelessWidget {
  const AiPostList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AiPostWidget(),
        SizedBox(height: 30),
        AiPostWidget(),
        SizedBox(height: 30),
        AiPostWidget(),
        SizedBox(height: 30),
        AiPostWidget(),
        SizedBox(height: 30),
        AiPostWidget(),
        SizedBox(height: 30),
        AiPostWidget(),
        SizedBox(height: 30),
      ],
    );
  }
}

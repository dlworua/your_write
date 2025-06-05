import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai_post/widgets/ai_post_bottom.dart';
import 'package:your_write/ui/pages/ai_post/widgets/ai_post_middle.dart';
import 'package:your_write/ui/pages/ai_post/widgets/ai_post_top.dart';

class AiPostWidget extends StatelessWidget {
  const AiPostWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [AiPostTop(), AiPostMiddle(), AiPostBottom()]);
  }
}

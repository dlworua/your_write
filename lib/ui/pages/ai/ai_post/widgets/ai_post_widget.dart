import 'package:flutter/material.dart';
import 'ai_post_top.dart';
import 'ai_post_middle.dart';
import 'ai_post_bottom.dart';

class AiPostWidget extends StatelessWidget {
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;

  const AiPostWidget({
    super.key,
    required this.nickname,
    required this.title,
    required this.content,
    required this.keywords,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AiPostTop(nickname: nickname),
        AiPostMiddle(title: title, content: content),
        AiPostBottom(keywords: keywords),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai/ai_detail/ai_detail.dart';
import 'ai_post_top.dart';
import 'ai_post_middle.dart';
import 'ai_post_bottom.dart';

class AiPostWidget extends StatelessWidget {
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;
  final DateTime date;

  const AiPostWidget({
    super.key,
    required this.nickname,
    required this.title,
    required this.content,
    required this.keywords,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFFAF6F0).withOpacity(0.4), // 크림 베이지
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 25,
            offset: Offset(0, 12),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 40,
            offset: Offset(0, 8),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            AiPostTop(nickname: nickname),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => AiDetailPage(
                          title: title,
                          content: content,
                          author: nickname,
                          keyword: keywords.join(', '),
                          date: date,
                        ),
                  ),
                );
              },
              child: AiPostMiddle(title: title, content: content),
            ),
            AiPostBottom(keywords: keywords),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai/ai_detail/ai_detail.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_bottom.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_middle.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_top.dart';

class AiPostWidget extends StatelessWidget {
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;
  final DateTime date;
  final String postId;

  const AiPostWidget({
    super.key,
    required this.nickname,
    required this.title,
    required this.content,
    required this.keywords,
    required this.date,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFFFAF6F0).withOpacity(0.4),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 8),
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
                          postId: postId,
                          scrollToCommentOnLoad: false, // 원한다면 true로 변경 가능
                        ),
                  ),
                );
              },
              child: AiPostMiddle(title: title, content: content),
            ),
            AiPostBottom(
              postId: postId,
              onCommentTap: () {
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
                          postId: postId,
                          scrollToCommentOnLoad: true, // 이게 꼭 true여야 함!
                        ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

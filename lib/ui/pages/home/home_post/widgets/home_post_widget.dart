import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/home_detail/detail_page.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_bottom.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_middle.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_top.dart';

class HomePostWidget extends StatelessWidget {
  final String postId;
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;
  final DateTime date;
  final VoidCallback onCommentPressed;

  const HomePostWidget({
    super.key,
    required this.postId,
    required this.nickname,
    required this.title,
    required this.content,
    required this.keywords,
    required this.date,
    required this.onCommentPressed,
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
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 25,
            offset: const Offset(0, 12),
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
            HomePostTop(nickname: nickname),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => HomeDetailPage(
                          postId: postId,
                          title: title,
                          content: content,
                          author: nickname,
                          keyword: keywords.isNotEmpty ? keywords.first : '',
                          date: date,
                        ),
                  ),
                );
              },
              child: HomePostMiddle(title: title, content: content),
            ),
            HomePostBottom(
              postId: postId,
              keywords: keywords,
              date: date,
              onCommentPressed: onCommentPressed,
              title: title,
              content: content,
            ),
          ],
        ),
      ),
    );
  }
}

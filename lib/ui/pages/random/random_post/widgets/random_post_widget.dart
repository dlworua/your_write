import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/random/random_detail/random_detail.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_bottom.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_middle.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_top.dart';

class RandomPostWidget extends StatelessWidget {
  final String postId;
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;
  final DateTime date;

  const RandomPostWidget({
    super.key,
    required this.postId,
    required this.nickname,
    required this.title,
    required this.content,
    required this.keywords,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    print('✅ RandomPostWidget 최신 버전 로드됨');

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
            RandomPostTop(nickname: nickname, postId: postId),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => RandomDetailPage(
                          postId: postId,
                          title: title,
                          content: content,
                          author: nickname,
                          keyword: keywords,
                          date: date,
                        ),
                  ),
                );
              },
              child: RandomPostMiddle(title: title, content: content),
            ),
            RandomPostBottom(
              postId: postId,
              title: title,
              content: content,
              keywords: keywords,
              onCommentPressed: () {
                // 댓글 아이콘 클릭 시 상세페이지 이동 + 댓글창 포커스 유도
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => RandomDetailPage(
                          postId: postId,
                          title: title,
                          content: content,
                          author: nickname,
                          keyword: keywords,
                          date: date,
                          focusOnComment: true, // 🟡 다음에 구현할 상세페이지에서 이 값 처리
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

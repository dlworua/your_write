import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/random/random_detail/random_detail.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_bottom.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_middle.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_top.dart';

class RandomPostWidget extends StatelessWidget {
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;
  final DateTime date;

  const RandomPostWidget({
    super.key,
    required this.nickname,
    required this.title,
    required this.content,
    required this.keywords,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RandomPostTop(nickname: nickname),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => RandomDetailPage(
                      title: title,
                      content: content,
                      author: nickname,
                      keyword: keywords.join(','),
                      date: date,
                    ), // post를 전달
              ),
            );
          },
          child: RandomPostMiddle(title: title, content: content),
        ),
        RandomPostBottom(keywords: keywords),
      ],
    );
  }
}

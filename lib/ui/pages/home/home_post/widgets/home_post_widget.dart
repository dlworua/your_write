import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/home/home_detail/detail_page.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_bottom.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_middle.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_top.dart';

class HomePostWidget extends StatelessWidget {
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;
  final DateTime date;

  const HomePostWidget({
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
        HomePostTop(nickname: nickname),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => HomeDetailPage(
                      title: title,
                      content: content,
                      author: nickname,
                      keyword: keywords.join(', '),
                      date: date,
                    ), // post를 전달
              ),
            );
          },
          child: HomePostMiddle(title: title, content: content),
        ),
        HomePostBottom(),
      ],
    );
  }
}

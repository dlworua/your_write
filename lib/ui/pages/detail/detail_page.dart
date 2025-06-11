import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/detail/widgets/comment_input.dart';
import 'package:your_write/ui/pages/detail/widgets/comment_list.dart';
import 'package:your_write/ui/pages/detail/widgets/comment_model.dart';
import 'package:your_write/ui/pages/detail/widgets/detail_write.dart';
import 'package:your_write/ui/pages/random_post/random_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Comment> _comments = [];

  void _addComment(String content) {
    if (content.trim().isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        Comment(writer: '익명', content: content, createdAt: DateTime.now()),
      );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 다른창 선택 시 키보드 내리기
      child: Scaffold(
        backgroundColor: Color(0XFFFFFDF4),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Image.asset('assets/appbar_logo.png'),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RandomPage();
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 85, left: 30),
                        child: Icon(Icons.keyboard_return_sharp, size: 30),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                children: [
                  DetailTitle(),
                  const SizedBox(height: 8),
                  DetailWriter(),
                  const SizedBox(height: 12),
                  DetailKeyword(),
                  const Divider(height: 32, thickness: 2),
                  DetailContent(),
                  Divider(height: 32, thickness: 2),
                  const SizedBox(height: 5),
                  CommentInput(
                    controller: _controller,
                    onSubmitted: _addComment,
                  ),
                  const SizedBox(height: 16),
                  CommentList(comments: _comments),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

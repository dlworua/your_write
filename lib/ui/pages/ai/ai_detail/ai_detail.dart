import 'package:flutter/material.dart';
import 'package:your_write/data/models/comment.dart';
import 'package:your_write/ui/pages/ai/ai_detail/widgets/ai_comment_input.dart';
import 'package:your_write/ui/pages/ai/ai_detail/widgets/ai_comment_list.dart';
import 'package:your_write/ui/pages/ai/ai_detail/widgets/ai_detail_writer.dart';
import 'package:your_write/ui/pages/ai/ai_post/ai_page.dart';

class AiDetailPage extends StatefulWidget {
  const AiDetailPage({super.key});

  @override
  State<AiDetailPage> createState() => _AiDetailPageState();
}

class _AiDetailPageState extends State<AiDetailPage> {
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
                          return AiPage();
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
                  AiDetailTitle(),
                  const SizedBox(height: 8),
                  AiDetailWriter(),
                  const SizedBox(height: 12),
                  AiDetailKeyword(),
                  const Divider(height: 32, thickness: 2),
                  AiDetailContent(),
                  Divider(height: 32, thickness: 2),
                  const SizedBox(height: 5),
                  AiCommentInput(
                    controller: _controller,
                    onSubmitted: _addComment,
                  ),
                  const SizedBox(height: 16),
                  AiCommentList(comments: _comments),
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

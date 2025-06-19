import 'package:flutter/material.dart';
import 'package:your_write/data/models/comment.dart';
import 'package:your_write/ui/pages/ai/ai_detail/widgets/ai_comment_input.dart';
import 'package:your_write/ui/pages/ai/ai_detail/widgets/ai_comment_list.dart';

class AiDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String author;
  final String keyword;
  final DateTime date;

  const AiDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.keyword,
    required this.date,
  });

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
        Comment(
          id: '',
          author: '익명',
          content: content,
          createdAt: DateTime.now(),
        ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 85, left: 30),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.keyboard_return_sharp, size: 30),
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
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${widget.author}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${widget.keyword}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.date.year}.${widget.date.month.toString().padLeft(2, '0')}.${widget.date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32, thickness: 2),
                  Text(
                    widget.content,
                    style: const TextStyle(fontSize: 18, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32, thickness: 2),
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

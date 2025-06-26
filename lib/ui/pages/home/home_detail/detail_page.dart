import 'package:flutter/material.dart';
import 'package:your_write/data/models/comment_model.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_input.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_list.dart';

class HomeDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String author;
  final String keyword;
  final DateTime date;

  /// 댓글 입력창으로 스크롤 및 포커스 요청 콜백
  final VoidCallback? onScrollToComment;

  const HomeDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.keyword,
    required this.date,
    this.onScrollToComment,
  });

  @override
  State<HomeDetailPage> createState() => HomeDetailPageState();
}

class HomeDetailPageState extends State<HomeDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final List<CommentModel> _comments = [];

  void _addComment(String content) {
    if (content.trim().isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        CommentModel(
          id: '',
          author: '익명',
          content: content,
          createdAt: DateTime.now(),
        ),
      );
      _controller.clear();
    });
  }

  /// 댓글 입력란으로 스크롤 + 포커스 주는 함수
  void scrollToCommentInput() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void initState() {
    super.initState();
    // 콜백이 있다면 콜백에 현재 함수 연결
    widget.onScrollToComment?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0XFFFFFDF4),
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
                controller: _scrollController,
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
                  SharedCommentInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: _addComment,
                  ),
                  const SizedBox(height: 16),
                  SharedCommentList(comments: _comments),
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

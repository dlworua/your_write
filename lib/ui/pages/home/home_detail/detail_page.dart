// lib/ui/pages/home/home_detail/detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_input.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_list.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class HomeDetailPage extends ConsumerStatefulWidget {
  final String postId;
  final String title;
  final String content;
  final String author;
  final String keyword;
  final DateTime date;
  final bool scrollToCommentInput;

  const HomeDetailPage({
    super.key,
    required this.postId,
    required this.title,
    required this.content,
    required this.author,
    required this.keyword,
    required this.date,
    this.scrollToCommentInput = false,
  });

  @override
  ConsumerState<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends ConsumerState<HomeDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  void _scrollToCommentInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.scrollToCommentInput) {
      _scrollToCommentInput();
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentParams = CommentParams(
      postId: widget.postId,
      boardType: 'home_posts', // ✅ 컬렉션 경로 통일
    );

    final commentState = ref.watch(postInteractionProvider(commentParams));
    final commentNotifier = ref.read(
      postInteractionProvider(commentParams).notifier,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0XFFFFFDF4),
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset('assets/appbar_logo.png'),
                Positioned(
                  top: 85,
                  left: 30,
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
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "by ${widget.author}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "#${widget.keyword}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${widget.date.year}.${widget.date.month.toString().padLeft(2, '0')}.${widget.date.day.toString().padLeft(2, '0')}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Divider(height: 32, thickness: 2),
                  Text(
                    widget.content,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                  const Divider(height: 32, thickness: 2),
                  SharedCommentInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (text) async {
                      await commentNotifier.addComment(text);
                      _controller.clear();
                    },
                  ),
                  const SizedBox(height: 16),
                  SharedCommentList(comments: commentState.comments),
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

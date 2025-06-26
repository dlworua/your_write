import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_input.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_list.dart';

class RandomDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String content;
  final String author;
  final String keyword;
  final DateTime date;
  final String postId;

  /// 댓글창 포커스를 요청할지 여부
  final bool focusOnComment;

  const RandomDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.keyword,
    required this.date,
    required this.postId,
    this.focusOnComment = false,
  });

  @override
  ConsumerState<RandomDetailPage> createState() => _RandomDetailPageState();
}

class _RandomDetailPageState extends ConsumerState<RandomDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  late final postParams = CommentParams(
    postId: widget.postId,
    boardType: 'random_writes', // Firestore 컬렉션명 확인 필요
  );

  void scrollToCommentInput() {
    Future.delayed(const Duration(milliseconds: 300), () {
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
    if (widget.focusOnComment) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToCommentInput();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final interaction = ref.watch(postInteractionProvider(postParams));
    final viewModel = ref.read(postInteractionProvider(postParams).notifier);

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

                  // 댓글 입력 위젯
                  SharedCommentInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (content) async {
                      await viewModel.addComment(content);
                      _controller.clear();
                    },
                  ),
                  const SizedBox(height: 16),

                  // 댓글 리스트 위젯
                  SharedCommentList(comments: interaction.comments),
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

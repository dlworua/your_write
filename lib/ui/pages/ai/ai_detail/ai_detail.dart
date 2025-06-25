import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_input.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_list.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_bottom.dart';

class AiDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String content;
  final String author;
  final String keyword;
  final DateTime date;
  final String postId;
  final bool scrollToCommentOnLoad;

  const AiDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.keyword,
    required this.date,
    required this.postId,
    this.scrollToCommentOnLoad = false,
  });

  @override
  ConsumerState<AiDetailPage> createState() => _AiDetailPageState();
}

class _AiDetailPageState extends ConsumerState<AiDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  late final CommentParams params;

  /// 댓글 입력창으로 스크롤하는 함수 (재시도 포함)
  void scrollToCommentInput({int retryCount = 0}) {
    if (retryCount > 10) return; // 최대 재시도 횟수 제한

    if (!_scrollController.hasClients) {
      print('[DEBUG] hasClients false, 재시도 $retryCount');
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollToCommentInput(retryCount: retryCount + 1);
      });
      return;
    }

    // 🔥 고정된 위치로 무조건 이동 (예: 1000 픽셀)
    const double fixedScrollPosition = 400;

    _scrollController.animateTo(
      fixedScrollPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );

    // 댓글 입력창 포커스
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void initState() {
    super.initState();
    params = CommentParams(postId: widget.postId, boardType: 'ai_writes');

    if (widget.scrollToCommentOnLoad) {
      print('[DEBUG] scrollToCommentOnLoad true → post frame callback');
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // ❗ 댓글 데이터가 로드되기까지 기다리기 (최소 300~500ms 정도)
        await Future.delayed(const Duration(milliseconds: 500));
        scrollToCommentInput();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final interaction = ref.watch(postInteractionProvider(params));
    final viewModel = ref.read(postInteractionProvider(params).notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF4),

        /// 하단 좋아요/댓글/저장 버튼
        bottomNavigationBar: AiPostBottom(
          postId: widget.postId,
          onCommentTap: () {
            print('[DEBUG] 댓글 아이콘 클릭됨');
            scrollToCommentInput();
          },
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 상단 앱바
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

            // 본문 + 댓글 영역
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

                  /// 댓글 입력창
                  SharedCommentInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (content) {
                      viewModel.addComment(content);
                      _controller.clear();
                    },
                  ),
                  const SizedBox(height: 16),

                  /// 댓글 리스트
                  SharedCommentList(comments: interaction.comments),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

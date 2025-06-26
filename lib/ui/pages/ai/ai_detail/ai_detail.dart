import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_input.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_list.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class AiDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String content;
  final String author;
  final List<String> keywords;
  final DateTime date;
  final String postId;
  final bool scrollToCommentOnLoad;

  const AiDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.author,
    required this.keywords,
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

  void scrollToCommentInput({int retryCount = 0}) {
    if (retryCount > 10) return;
    if (!_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollToCommentInput(retryCount: retryCount + 1);
      });
      return;
    }
    const double fixedScrollPosition = 400;
    _scrollController.animateTo(
      fixedScrollPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void initState() {
    super.initState();
    params = CommentParams(postId: widget.postId, boardType: 'ai_writes');

    if (widget.scrollToCommentOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
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

        // 하단 버튼 없음
        bottomNavigationBar: null,

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                children: [
                  // 제목
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 작성자, 날짜 한줄 배치
                  Row(
                    children: [
                      Text(
                        'by ${widget.author}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8B7D7B),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '${widget.date.year}.${widget.date.month.toString().padLeft(2, '0')}.${widget.date.day.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF8B7D7B),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 키워드 가로 스크롤
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          widget.keywords.map((k) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFE6CCB2).withOpacity(0.7),
                                    const Color(0xFFF5F1EB).withOpacity(0.5),
                                    Colors.white.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: const Color(
                                    0xFFDDBEA9,
                                  ).withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '#$k',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFA0522D),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 본문 내용
                  Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 18,
                      height: 1.6,
                      color: Color(0xFF5D4037),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 댓글 입력창
                  SharedCommentInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (content) {
                      viewModel.addComment(content);
                      _controller.clear();
                    },
                  ),

                  const SizedBox(height: 16),

                  // 댓글 리스트
                  SharedCommentList(comments: interaction.comments),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

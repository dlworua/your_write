import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_input.dart';
import 'package:your_write/ui/widgets/comment/shared_comment_list.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class RandomDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String content;
  final String author;
  final List<String> keyword;
  final DateTime date;
  final String postId;
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
    boardType: 'random_writes',
  );

  void scrollToCommentInput({int retryCount = 0}) {
    if (retryCount > 10) return;
    if (!_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        scrollToCommentInput(retryCount: retryCount + 1);
      });
      return;
    }
    const double fixedScrollPosition = 700;
    _scrollController.animateTo(
      fixedScrollPosition,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
    FocusScope.of(context).requestFocus(_focusNode);
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
          children: [
            Stack(
              children: [
                Image.asset('assets/appbar_logo.png'),
                Positioned(
                  top: 85,
                  left: 30,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20.sp,
                      color: const Color(0xFF8B6F47),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                children: [
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8D5C4).withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6B4E3D),
                            height: 1.3,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _infoTag(
                              icon: Icons.person_outline,
                              text: 'by ${widget.author}',
                            ),
                            SizedBox(width: 8.w),
                            _infoTag(
                              icon: Icons.calendar_today_outlined,
                              text:
                                  '${widget.date.year}.${widget.date.month.toString().padLeft(2, '0')}.${widget.date.day.toString().padLeft(2, '0')}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // 키워드
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          widget.keyword.map((k) {
                            return Container(
                              margin: EdgeInsets.only(right: 12.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFF0E6D2).withOpacity(0.8),
                                    const Color(0xFFE8D5C4).withOpacity(0.6),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: const Color(
                                    0xFFD4B5A0,
                                  ).withOpacity(0.4),
                                  width: 1.w,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFE8D5C4,
                                    ).withOpacity(0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: Text(
                                '#$k',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF8B6F47),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  Container(
                    padding: EdgeInsets.all(28.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.95),
                          const Color(0xFFFAF6F0).withOpacity(0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFE8D5C4).withOpacity(0.2),
                          offset: const Offset(0, 6),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Text(
                      widget.content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        height: 1.7,
                        color: const Color(0xFF5D4E42),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 25.h),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF5EFE7).withOpacity(0.6),
                          const Color(0xFFE8D5C4).withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 18.sp,
                          color: const Color(0xFF8B6F47),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '댓글을 남겨보세요',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8B6F47),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  SharedCommentInput(
                    controller: _controller,
                    focusNode: _focusNode,
                    onSubmitted: (content) async {
                      await viewModel.addComment(content);
                      _controller.clear();
                    },
                  ),

                  SizedBox(height: 5.h),

                  SharedCommentList(comments: interaction.comments),

                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTag({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EFE7).withOpacity(0.7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFFD4B5A0).withOpacity(0.3),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(icon, size: 12.sp, color: const Color(0xFF8B6F47)),
          ),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8B6F47),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class AiPostBottom extends ConsumerWidget {
  final String postId;
  final VoidCallback onCommentTap;

  const AiPostBottom({
    super.key,
    required this.postId,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // postId가 비어있으면 빈 화면 출력
    if (postId.isEmpty) {
      return const SizedBox.shrink();
    }

    final params = CommentParams(postId: postId, boardType: 'ai_writes');
    final state = ref.watch(postInteractionProvider(params));
    final viewModel = ref.read(postInteractionProvider(params).notifier);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF5F1EB).withOpacity(0.3), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 좋아요
          GestureDetector(
            onTap: viewModel.toggleLike,
            child: Row(
              children: [
                Icon(
                  state.isLiked
                      ? Icons.favorite
                      : Icons.favorite_border_rounded,
                  color:
                      state.isLiked
                          ? const Color(0xFFE57373) // 빨간색
                          : const Color(0xFFD2691E),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text('${state.likeCount}'),
              ],
            ),
          ),

          // 댓글
          GestureDetector(
            onTap: onCommentTap,
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF4682B4),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text('${state.comments.length}'),
              ],
            ),
          ),

          // 공유 (동작 없음)
          const Icon(Icons.share_outlined, color: Color(0xFF8FBC8F), size: 20),

          // 저장
          GestureDetector(
            onTap: viewModel.toggleSave,
            child: Icon(
              state.isSaved ? Icons.bookmark : Icons.bookmark_outline_rounded,
              color:
                  state.isSaved
                      ? const Color(0xFFBA68C8) // 보라
                      : const Color(0xFFDDA0DD),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

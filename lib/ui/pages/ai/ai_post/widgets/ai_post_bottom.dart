import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class AiPostBottom extends ConsumerWidget {
  final String postId;
  final String title;
  final String content;
  final VoidCallback onCommentTap;

  const AiPostBottom({
    super.key,
    required this.postId,
    required this.title,
    required this.content,
    required this.onCommentTap,
  });

  void _sharePost() {
    final postUrl = 'https://your-write.firebaseapp.com/posts/$postId';
    final shareText = '📌 $title\n\n$content\n\n👉 자세히 보기: $postUrl';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (postId.isEmpty) return const SizedBox.shrink();

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
                          ? const Color(0xFFE57373)
                          : const Color(0xFFD2691E),
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text('${state.likeCount}'),
              ],
            ),
          ),
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
          GestureDetector(
            onTap: _sharePost,
            child: const Icon(
              Icons.share_outlined,
              color: Color(0xFF8FBC8F),
              size: 20,
            ),
          ),
          GestureDetector(
            onTap: viewModel.toggleSave,
            child: Icon(
              state.isSaved ? Icons.bookmark : Icons.bookmark_outline_rounded,
              color:
                  state.isSaved
                      ? const Color(0xFFBA68C8)
                      : const Color(0xFFDDA0DD),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

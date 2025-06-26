import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';
import 'package:share_plus/share_plus.dart';

class RandomPostBottom extends ConsumerWidget {
  final String postId;
  final String title;
  final String content;
  final List<String> keywords;
  final VoidCallback onCommentPressed;

  const RandomPostBottom({
    super.key,
    required this.postId,
    required this.title,
    required this.content,
    required this.keywords,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interaction = ref.watch(
      postInteractionProvider(
        CommentParams(postId: postId, boardType: 'random_writes'),
      ),
    );
    final viewModel = ref.read(
      postInteractionProvider(
        CommentParams(postId: postId, boardType: 'random_writes'),
      ).notifier,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF5F1EB).withOpacity(0.3), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔁 AI 스타일 키워드 UI
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: '📌 키워드: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: keywords.join(', '),
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // 💬 좋아요/댓글/공유/저장 아이콘
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconOnlyButton(
                icon:
                    interaction.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                count: interaction.likeCount.toString(),
                color: const Color(0xFFD2691E),
                onTap: viewModel.toggleLike,
              ),
              _buildIconOnlyButton(
                icon: Icons.chat_bubble_outline_rounded,
                count: interaction.comments.length.toString(),
                color: const Color(0xFF4682B4),
                onTap: onCommentPressed,
              ),
              _buildIconOnlyButton(
                icon: Icons.share_outlined,
                count: '',
                color: const Color(0xFF8FBC8F),
                onTap: () {
                  final text = '"$title"\n\n$content\n\n👉 from Your Write App';
                  Share.share(text);
                },
              ),
              _buildIconOnlyButton(
                icon:
                    interaction.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_outline_rounded,
                count: '',
                color: const Color(0xFFDDA0DD),
                onTap: viewModel.toggleSave,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconOnlyButton({
    required IconData icon,
    required String count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          if (count.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              count,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5D4037),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

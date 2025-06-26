import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';
import 'package:share_plus/share_plus.dart';

class HomePostBottom extends ConsumerWidget {
  final String postId;
  final List<String> keywords;
  final DateTime date;
  final VoidCallback onCommentPressed;
  final String title;
  final String content;

  const HomePostBottom({
    super.key,
    required this.postId,
    required this.keywords,
    required this.date,
    required this.onCommentPressed,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final interaction = ref.watch(
      postInteractionProvider(
        CommentParams(postId: postId, boardType: 'home_posts'),
      ),
    );
    final interactionNotifier = ref.read(
      postInteractionProvider(
        CommentParams(postId: postId, boardType: 'home_posts'),
      ).notifier,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF5F1EB).withOpacity(0.3), Colors.white],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconWithCount(
                icon:
                    interaction.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                count: interaction.likeCount.toString(),
                isActive: interaction.isLiked,
                color: const Color(0xFFD2691E),
                onTap: interactionNotifier.toggleLike,
              ),
              _buildIconWithCount(
                icon: Icons.chat_bubble_outline_rounded,
                count: interaction.comments.length.toString(),
                isActive: false,
                color: const Color(0xFF4682B4),
                onTap: onCommentPressed,
              ),
              _buildIconWithCount(
                icon: Icons.share_outlined,
                count: null,
                isActive: false,
                color: const Color(0xFF8FBC8F),
                onTap:
                    () => ShareUtil.sharePost(
                      title: title,
                      content: content,
                      postId: postId,
                    ),
              ),
              _buildIconWithCount(
                icon:
                    interaction.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_outline_rounded,
                count: null,
                isActive: interaction.isSaved,
                color: const Color(0xFFDDA0DD),
                onTap: interactionNotifier.toggleSave,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithCount({
    required IconData icon,
    required String? count,
    required bool isActive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: isActive ? color : Colors.grey),
          if (count != null && count.isNotEmpty) ...[
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

class ShareUtil {
  static void sharePost({
    required String postId,
    required String title,
    required String content,
  }) {
    final text = '[$title]\n\n$content\n\n🔗 게시글 ID: $postId';
    Share.share(text);
  }
}

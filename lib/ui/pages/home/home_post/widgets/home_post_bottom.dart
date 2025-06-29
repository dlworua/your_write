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

  void _sharePost() {
    final postUrl = 'https://your-write.firebaseapp.com/posts/$postId';
    final shareText = '📌 $title\n\n$content\n\n👉 자세히 보기: $postUrl';
    Share.share(shareText);
  }

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
              _buildTapButton(
                icon:
                    interaction.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                count: interaction.likeCount.toString(),
                color: const Color(0xFFD2691E),
                splashColor: const Color(0xFFFFE4E1),
                onTap: interactionNotifier.toggleLike,
              ),
              _buildTapButton(
                icon: Icons.chat_bubble_outline_rounded,
                count: interaction.comments.length.toString(),
                color: const Color(0xFF4682B4),
                splashColor: const Color(0xFFF0F8FF),
                onTap: onCommentPressed,
              ),
              _buildTapButton(
                icon: Icons.share_outlined,
                count: '',
                color: const Color(0xFF8FBC8F),
                splashColor: const Color(0xFFF0FFF0),
                onTap: _sharePost,
              ),
              _buildTapButton(
                icon:
                    interaction.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_outline_rounded,
                count: '',
                color: const Color(0xFFDDA0DD),
                splashColor: const Color(0xFFFFF0FF),
                onTap: interactionNotifier.toggleSave,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTapButton({
    required IconData icon,
    required String count,
    required Color color,
    required Color splashColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: splashColor.withOpacity(0.3),
        highlightColor: splashColor.withOpacity(0.2),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              if (count.isNotEmpty) ...[
                SizedBox(width: 6),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5D4037),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

//               _buildIconWithCount(
//                 icon:
//                     interaction.isLiked
//                         ? Icons.favorite
//                         : Icons.favorite_border_rounded,
//                 count: interaction.likeCount.toString(),
//                 isActive: interaction.isLiked,
//                 color: const Color(0xFFD2691E),
//                 onTap: interactionNotifier.toggleLike,
//               ),
//               _buildIconWithCount(
//                 icon: Icons.chat_bubble_outline_rounded,
//                 count: interaction.comments.length.toString(),
//                 isActive: false,
//                 color: const Color(0xFF4682B4),
//                 onTap: onCommentPressed,
//               ),
//               _buildIconWithCount(
//                 icon: Icons.share_outlined,
//                 count: null,
//                 isActive: false,
//                 color: const Color(0xFF8FBC8F),
//                 onTap:
//                     () => ShareUtil.sharePost(
//                       title: title,
//                       content: content,
//                       postId: postId,
//                     ),
//               ),
//               _buildIconWithCount(
//                 icon:
//                     interaction.isSaved
//                         ? Icons.bookmark
//                         : Icons.bookmark_outline_rounded,
//                 count: null,
//                 isActive: interaction.isSaved,
//                 color: const Color(0xFFDDA0DD),
//                 onTap: interactionNotifier.toggleSave,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildIconWithCount({
//     required IconData icon,
//     required String? count,
//     required bool isActive,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: isActive ? color : Colors.grey),
//           if (count != null && count.isNotEmpty) ...[
//             const SizedBox(width: 6),
//             Text(
//               count,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF5D4037),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// class ShareUtil {
//   static void sharePost({
//     required String postId,
//     required String title,
//     required String content,
//   }) {
//     final text = '[$title]\n\n$content\n\n🔗 게시글 ID: $postId';
//     Share.share(text);
//   }
// }

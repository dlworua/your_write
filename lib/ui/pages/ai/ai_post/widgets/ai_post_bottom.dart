import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class AiPostBottom extends ConsumerWidget {
  final String postId;
  final String title;
  final String content;
  final List<String> keywords;
  final VoidCallback onCommentTap;

  const AiPostBottom({
    super.key,
    required this.postId,
    required this.title,
    required this.content,
    required this.keywords,
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
      padding: EdgeInsets.all(24),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD2B48C).withOpacity(0.8),
                      const Color(0xFFDDBEA9).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '🍂 글 키워드',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        keywords
                            .map(
                              (k) => Container(
                                margin: EdgeInsets.only(right: 8),
                                padding: EdgeInsets.symmetric(
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFA0522D),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTapButton(
                icon:
                    state.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                count: state.likeCount.toString(),
                color: const Color(0xFFD2691E),
                splashColor: const Color(0xFFFFE4E1),
                onTap: viewModel.toggleLike,
              ),
              _buildTapButton(
                icon: Icons.chat_bubble_outline_rounded,
                count: state.comments.length.toString(),
                color: const Color(0xFF4682B4),
                splashColor: const Color(0xFFF0F8FF),
                onTap: onCommentTap,
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
                    state.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_outline_rounded,
                count: '',
                color: const Color(0xFFDDA0DD),
                splashColor: const Color(0xFFFFF0FF),
                onTap: viewModel.toggleSave,
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

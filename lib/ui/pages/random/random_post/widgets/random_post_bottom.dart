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
          // 키워드 영역 (가로 스크롤)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFD2B48C).withOpacity(0.8),
                      const Color(0xFFDDBEA9).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '🍂 글 키워드',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        keywords
                            .map(
                              (k) => Container(
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
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 액션 버튼 영역
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
                onTap: viewModel.toggleLike,
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
                onTap: () {
                  final text = '"$title"\n\n$content\n\n👉 from Your Write App';
                  Share.share(text);
                },
              ),
              _buildTapButton(
                icon:
                    interaction.isSaved
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
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
        ),
      ),
    );
  }
}

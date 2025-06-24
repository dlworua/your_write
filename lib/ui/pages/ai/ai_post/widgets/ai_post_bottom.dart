import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/viewmodel/post_interaction_viewmodel.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_keyword.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

class AiPostBottom extends ConsumerWidget {
  final List<String> keywords;
  final String postId;
  final VoidCallback onCommentTap;

  const AiPostBottom({
    super.key,
    required this.keywords,
    required this.postId,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = CommentParams(postId: postId, boardType: 'ai_posts');
    final interaction = ref.watch(postInteractionProvider(params));
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
      child: Column(
        children: [
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  '🍂 AI 인용구',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        keywords
                            .map(
                              (k) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: AiPostKeyword(keyword: k),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => viewModel.toggleLike(),
                child: Row(
                  children: [
                    Icon(
                      interaction.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      size: 20,
                      color: const Color(0xFFD2691E),
                    ),
                    const SizedBox(width: 6),
                    Text('${interaction.likeCount}'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onCommentTap,
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 20,
                      color: Color(0xFF4682B4),
                    ),
                    const SizedBox(width: 6),
                    Text('${interaction.comments.length}'),
                  ],
                ),
              ),
              const Icon(
                Icons.share_outlined,
                size: 20,
                color: Color(0xFF8FBC8F),
              ),
              GestureDetector(
                onTap: () => viewModel.toggleSave(),
                child: Icon(
                  interaction.isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_outline_rounded,
                  size: 20,
                  color: const Color(0xFFDDA0DD),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

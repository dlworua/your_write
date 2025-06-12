import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_widget.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';

class AiPostList extends ConsumerWidget {
  const AiPostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(savedAiWritesProvider);

    if (posts.isEmpty) {
      return const Center(child: Text("출간된 글이 없습니다."));
    }

    return Column(
      children:
          posts
              .map(
                (post) => Column(
                  children: [
                    AiPostWidget(
                      nickname: post.author,
                      title: post.title,
                      content: post.content,
                      keywords: post.keyWord.split(','),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )
              .toList(),
    );
  }
}

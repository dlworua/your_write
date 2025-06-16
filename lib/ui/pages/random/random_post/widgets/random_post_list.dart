import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_widget.dart';

class RandomPostList extends ConsumerWidget {
  const RandomPostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts =
        ref
            .watch(savedAiWritesProvider)
            .where((post) => post.type == PostType.random)
            .toList();
    ;

    if (posts.isEmpty) {
      return const Center(child: Text("출간된 글이 없습니다."));
    }

    return Column(
      children:
          posts
              .map(
                (post) => Column(
                  children: [
                    RandomPostWidget(
                      nickname: post.nickname,
                      title: post.title,
                      content: post.content,
                      keywords: post.keyWord.split(','),
                      date: post.date,
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              )
              .toList(),
    );
  }
}

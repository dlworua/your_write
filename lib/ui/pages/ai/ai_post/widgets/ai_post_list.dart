import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_widget.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';

class AiPostList extends ConsumerStatefulWidget {
  const AiPostList({super.key});

  @override
  ConsumerState<AiPostList> createState() => _AiPostListState();
}

class _AiPostListState extends ConsumerState<AiPostList> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      loadAiPostsFromFirestore(ref);
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts =
        ref
            .watch(savedAiWritesProvider)
            .where((post) => post.type == PostType.ai)
            .toList();

    if (posts.isEmpty) {
      return const Center(child: Text("AI에 출간된 글이 없습니다."));
    }

    return Column(
      children:
          posts
              .map(
                (post) => Column(
                  children: [
                    AiPostWidget(
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

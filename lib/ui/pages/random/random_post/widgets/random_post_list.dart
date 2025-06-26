// lib/ui/pages/random/random_post/random_post_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/ui/pages/random/random_post/widgets/random_post_widget.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_viewmodel.dart';
import 'package:your_write/ui/pages/random/random_write/saved_random_writes_provider.dart';

class RandomPostList extends ConsumerStatefulWidget {
  const RandomPostList({super.key});

  @override
  ConsumerState<RandomPostList> createState() => _RandomPostListState();
}

class _RandomPostListState extends ConsumerState<RandomPostList> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      ref.read(randomWriteViewModelProvider.notifier).loadRandomPosts();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(savedRandomWritesProvider);

    if (posts.isEmpty) {
      return const Center(child: Text("랜덤 게시판에 출간된 글이 없습니다."));
    }

    return Column(
      children:
          posts.map((post) {
            return Column(
              children: [
                RandomPostWidget(
                  postId: post.id,
                  nickname: post.nickname,
                  title: post.title,
                  content: post.content,
                  keywords: post.keyWord.split(','),
                  date: post.date,
                ),
                const SizedBox(height: 30),
              ],
            );
          }).toList(),
    );
  }
}

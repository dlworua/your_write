import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/ui/pages/home/home_post/home_view_model.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_widget.dart';

class HomePostList extends ConsumerStatefulWidget {
  const HomePostList({super.key});

  @override
  ConsumerState<HomePostList> createState() => _HomePostListState();
}

class _HomePostListState extends ConsumerState<HomePostList> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      ref.read(homePostListProvider.notifier).loadPosts();
      _isLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(homePostListProvider);

    if (posts.isEmpty) {
      return const Center(child: Text("메인 게시판에 출간된 글이 없습니다."));
    }

    return Column(
      children:
          posts.map((post) {
            return Column(
              children: [
                HomePostWidget(
                  content: post.content,
                  title: post.title,
                  nickname: post.author,
                  keywords: [post.keyword],
                  date: post.date,
                ),
                SizedBox(height: 30),
              ],
            );
          }).toList(),
    );
  }
}

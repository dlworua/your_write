import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/ui/pages/home/home_post/home_view_model.dart';
import 'package:your_write/ui/pages/home/home_post/widgets/home_post_widget.dart';
import 'package:your_write/ui/pages/home/home_detail/detail_page.dart';

class HomePostList extends ConsumerWidget {
  const HomePostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  postId: post.id,
                  content: post.content,
                  title: post.title,
                  nickname: post.author,
                  keywords: [post.keyword],
                  date: post.date,
                  onCommentPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => HomeDetailPage(
                              postId: post.id,
                              title: post.title,
                              content: post.content,
                              author: post.author,
                              keyword: post.keyword,
                              date: post.date,
                              scrollToCommentInput: true,
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            );
          }).toList(),
    );
  }
}

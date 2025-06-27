import 'package:flutter/material.dart';
import 'package:your_write/data/models/unified_post_model.dart';
import 'package:your_write/ui/pages/ai/ai_detail/ai_detail.dart';
import 'package:your_write/ui/pages/random/random_detail/random_detail.dart';
import 'package:your_write/ui/pages/home/home_detail/detail_page.dart';

class UnifiedPostItem extends StatelessWidget {
  final UnifiedPostModel post;

  const UnifiedPostItem({super.key, required this.post});

  void _navigateToDetail(BuildContext context) {
    switch (post.boardType) {
      case BoardType.ai:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => AiDetailPage(
                  postId: post.id,
                  author: post.nickname,
                  content: post.content,
                  title: post.title,
                  keywords: [post.keyword],
                  date: post.date,
                  scrollToCommentOnLoad: false,
                ),
          ),
        );
        break;
      case BoardType.random:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => RandomDetailPage(
                  postId: post.id,
                  author: post.nickname,
                  title: post.title,
                  content: post.content,
                  keyword: [post.keyword],
                  date: post.date,
                  focusOnComment: false,
                ),
          ),
        );
        break;
      case BoardType.home:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => HomeDetailPage(
                  postId: post.id,
                  title: post.title,
                  content: post.content,
                  author: post.nickname,
                  keyword: post.keyword,
                  date: post.date,
                  scrollToCommentInput: false,
                ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(post.content, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${post.keyword}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    post.nickname,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

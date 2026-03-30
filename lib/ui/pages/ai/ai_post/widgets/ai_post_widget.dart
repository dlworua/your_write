import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/ai/ai_detail/ai_detail.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_bottom.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_middle.dart';
import 'package:your_write/ui/pages/ai/ai_post/widgets/ai_post_top.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_page.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_service.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';

class AiPostWidget extends ConsumerWidget {
  final String nickname;
  final String title;
  final String content;
  final List<String> keywords;
  final DateTime date;
  final String postId;
  final String authorUid;

  const AiPostWidget({
    super.key,
    required this.nickname,
    required this.title,
    required this.content,
    required this.keywords,
    required this.date,
    required this.postId,
    this.authorUid = '',
  });

  void _navigateToEdit(BuildContext context) {
    final editPost = WriteModel(
      id: postId,
      title: title,
      keyWord: keywords.join(', '),
      nickname: nickname,
      content: content,
      date: date,
      type: PostType.ai,
      uid: authorUid,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AiWritePage(editPost: editPost),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '글 삭제',
          style: TextStyle(color: Color(0xFF6B4E3D), fontWeight: FontWeight.w700),
        ),
        content: const Text(
          '이 글을 삭제하시겠습니까?',
          style: TextStyle(color: Color(0xFF5D4E42)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('취소', style: TextStyle(color: Color(0xFF8B6F47))),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(aiWriterServiceProvider).deletePost(postId);
              final posts = ref.read(savedAiWritesProvider);
              ref.read(savedAiWritesProvider.notifier).setPosts(
                posts.where((p) => p.id != postId).toList(),
              );
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFE8D5C4).withOpacity(0.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('삭제', style: TextStyle(color: Color(0xFFB44A2A), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isAuthor = authorUid.isNotEmpty && currentUid == authorUid;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            Colors.white,
            const Color(0xFFFAF6F0).withOpacity(0.4),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.brown.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 8),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          children: [
            AiPostTop(
              nickname: nickname,
              postId: postId,
              isAuthor: isAuthor,
              onEdit: () => _navigateToEdit(context),
              onDelete: () => _showDeleteConfirm(context, ref),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiDetailPage(
                      title: title,
                      content: content,
                      author: nickname,
                      keywords: keywords,
                      date: date,
                      postId: postId,
                      authorUid: authorUid,
                      scrollToCommentOnLoad: false,
                    ),
                  ),
                );
              },
              child: AiPostMiddle(title: title, content: content),
            ),
            AiPostBottom(
              postId: postId,
              title: title,
              content: content,
              keywords: keywords,
              onCommentTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AiDetailPage(
                      title: title,
                      content: content,
                      author: nickname,
                      keywords: keywords,
                      date: date,
                      postId: postId,
                      authorUid: authorUid,
                      scrollToCommentOnLoad: true,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

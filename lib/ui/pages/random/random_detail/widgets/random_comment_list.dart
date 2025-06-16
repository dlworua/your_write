import 'package:flutter/material.dart';
import 'package:your_write/data/models/comment.dart';

class RandomCommentList extends StatelessWidget {
  final List<Comment> comments;

  const RandomCommentList({super.key, required this.comments});

  String _formatTimeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}주 전';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}달 전';
    return '${(diff.inDays / 365).floor()}년 전';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '댓글',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...comments.map(
          (comment) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${comment.writer} · ${_formatTimeAgo(comment.createdAt)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(comment.content),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

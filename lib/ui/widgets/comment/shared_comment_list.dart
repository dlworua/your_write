import 'package:flutter/material.dart';
import 'package:your_write/data/models/comment_model.dart';

class SharedCommentList extends StatelessWidget {
  final List<CommentModel> comments;

  const SharedCommentList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const Center(child: Text('댓글이 없습니다.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return ListTile(
          title: Text(comment.author),
          subtitle: Text(comment.content),
          trailing: Text(
            '${comment.createdAt.year}.${comment.createdAt.month.toString().padLeft(2, '0')}.${comment.createdAt.day.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String writer;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.writer,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'writer': writer,
      'content': content,
      'createdAt': createdAt.toUtc(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      writer: map['writer'] ?? '익명',
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

import 'package:flutter/foundation.dart';

@immutable
class CommentParams {
  final String postId;
  final String boardType;

  CommentParams({required this.postId, required this.boardType}) {
    if (postId.isEmpty) {
      throw ArgumentError('postId cannot be empty');
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommentParams &&
          runtimeType == other.runtimeType &&
          postId == other.postId &&
          boardType == other.boardType;

  @override
  int get hashCode => postId.hashCode ^ boardType.hashCode;
}

import 'package:cloud_firestore/cloud_firestore.dart';

enum BoardType { ai, random, home }

class UnifiedPostModel {
  final String id;
  final String title;
  final String content;
  final String nickname;
  final String keyword;
  final DateTime date;
  final BoardType boardType;

  UnifiedPostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.nickname,
    required this.keyword,
    required this.date,
    required this.boardType,
  });

  factory UnifiedPostModel.fromMap(
    Map<String, dynamic> map,
    String id,
    BoardType boardType,
  ) {
    return UnifiedPostModel(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      nickname: map['nickname'] ?? map['author'] ?? '',
      keyword: map['keyWord'] ?? map['keyword'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      boardType: boardType,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

/// 글 타입 구분용 enum
enum PostType { ai, random }

PostType postTypeFromString(String value) {
  switch (value) {
    case 'ai':
      return PostType.ai;
    case 'random':
      return PostType.random;
    default:
      throw Exception('Unknown post type: $value');
  }
}

String postTypeToString(PostType type) {
  return type.name;
  //   return type.toString().split('.').last;
}

/// 글 모델
class WriteModel {
  final String id; // ✅ 추가됨
  final String title;
  final String keyWord;
  final String nickname;
  final String content;
  final DateTime date;
  final PostType type;

  WriteModel({
    required this.id,
    required this.title,
    required this.keyWord,
    required this.nickname,
    required this.content,
    required this.date,
    required this.type,
  });

  WriteModel copyWith({
    String? id,
    String? title,
    String? keyWord,
    String? nickname,
    String? content,
    DateTime? date,
    PostType? type,
  }) {
    return WriteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      keyWord: keyWord ?? this.keyWord,
      nickname: nickname ?? this.nickname,
      content: content ?? this.content,
      date: date ?? this.date,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'keyWord': keyWord,
      'nickname': nickname,
      'content': content,
      'date': date.toIso8601String(),
      'type': postTypeToString(type),
    };
  }

  factory WriteModel.fromMap(
    Map<String, dynamic> map, {
    required String docId,
  }) {
    return WriteModel(
      id: docId,
      title: map['title'],
      keyWord: map['keyWord'],
      nickname: map['nickname'],
      content: map['content'],
      date:
          map['date'] is Timestamp
              ? (map['date'] as Timestamp).toDate()
              : DateTime.parse(map['date']),
      type: postTypeFromString(map['type']),
    );
  }
}

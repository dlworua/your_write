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
class Write {
  final String title;
  final String keyWord;
  final String nickname;
  final String content;
  final DateTime date;
  final PostType type;

  Write({
    required this.title,
    required this.keyWord,
    required this.nickname,
    required this.content,
    required this.date,
    required this.type,
  });

  Write copyWith({
    String? title,
    String? keyWord,
    String? nickname,
    String? content,
    DateTime? date,
    PostType? type,
  }) {
    return Write(
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

  factory Write.fromMap(Map<String, dynamic> map) {
    return Write(
      title: map['title'],
      keyWord: map['keyWord'],
      nickname: map['nickname'],
      content: map['content'],
      date: (map['date'] as Timestamp).toDate(),
      type: postTypeFromString(map['type']),
    );
  }
}

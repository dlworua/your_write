/// 글 타입 구분용 enum
enum PostType { ai, random }

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
}

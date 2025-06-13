class AiWrite {
  final String title;
  final String keyWord;
  final String nickname;
  final String content;
  final DateTime date;

  AiWrite({
    required this.title,
    required this.keyWord,
    required this.nickname,
    required this.content,
    required this.date,
  });

  AiWrite copyWith({
    String? title,
    String? keyWord,
    String? author,
    String? content,
    DateTime? date,
  }) {
    return AiWrite(
      title: title ?? this.title,
      keyWord: keyWord ?? this.keyWord,
      nickname: author ?? this.nickname,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }
}

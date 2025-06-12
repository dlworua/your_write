class AiWrite {
  final String title;
  final String keyWord;
  final String author;
  final String content;

  AiWrite({
    required this.title,
    required this.keyWord,
    required this.author,
    required this.content,
  });

  AiWrite copyWith({
    String? title,
    String? keyWord,
    String? author,
    String? content,
  }) {
    return AiWrite(
      title: title ?? this.title,
      keyWord: keyWord ?? this.keyWord,
      author: author ?? this.author,
      content: content ?? this.content,
    );
  }
}

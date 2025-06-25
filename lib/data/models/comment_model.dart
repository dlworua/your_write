class CommentModel {
  final String id;
  final String author;
  final String content;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromMap(String id, Map<String, dynamic> map) {
    return CommentModel(
      id: id,
      author: map['author'] ?? '익명',
      content: map['content'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'author': author, 'content': content, 'createdAt': createdAt};
  }
}

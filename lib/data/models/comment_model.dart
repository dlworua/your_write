class CommentModel {
  final String id;
  final String content;
  final String author;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'content': content,
    'author': author,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CommentModel.fromMap(Map<String, dynamic> map, String id) {
    return CommentModel(
      id: id,
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

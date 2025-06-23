class Comment {
  final String id;
  final String content;
  final String author;
  final DateTime createdAt;

  Comment({
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

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

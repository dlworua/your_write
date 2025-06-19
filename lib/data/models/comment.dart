class Comment {
  final String id; // Firestore 문서 ID
  final String content;
  final String author;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      createdAt: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
    );
  }
}

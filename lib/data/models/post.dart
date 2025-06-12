class Post {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final String authorId;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.authorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'authorId': authorId,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      authorId: json['authorId'],
    );
  }
}

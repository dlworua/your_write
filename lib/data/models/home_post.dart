class HomePost {
  final String title;
  final String content;
  final String keyword;
  final String author;
  final DateTime date;

  HomePost({
    required this.title,
    required this.content,
    required this.keyword,
    required this.author,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'keyword': keyword,
      'author': author,
      'date': date.toIso8601String(),
    };
  }

  factory HomePost.fromMap(Map<String, dynamic> map) {
    return HomePost(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      keyword: map['keyword'] ?? '',
      author: map['author'] ?? '익명',
      date: DateTime.parse(map['date']),
    );
  }
}

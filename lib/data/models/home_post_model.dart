class HomePostModel {
  final String id;
  final String title;
  final String content;
  final String keyword;
  final String author;
  final DateTime date;

  HomePostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.keyword,
    required this.author,
    required this.date,
  });

  factory HomePostModel.fromMap(Map<String, dynamic> map, String docId) {
    return HomePostModel(
      id: docId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      keyword: map['keyword'] ?? '',
      author: map['author'] ?? '익명',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'keyword': keyword,
      'author': author,
      'date': date.toIso8601String(),
    };
  }
}

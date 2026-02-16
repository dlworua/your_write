class HomePostModel {
  final String id;
  final String title;
  final String content;
  final String keyword;
  final String author;
  final DateTime date;
  final String uid; // 작성자 UID (수정/삭제 권한 확인용)

  HomePostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.keyword,
    required this.author,
    required this.date,
    this.uid = '',
  });

  HomePostModel copyWith({
    String? id,
    String? title,
    String? content,
    String? keyword,
    String? author,
    DateTime? date,
    String? uid,
  }) {
    return HomePostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      keyword: keyword ?? this.keyword,
      author: author ?? this.author,
      date: date ?? this.date,
      uid: uid ?? this.uid,
    );
  }

  factory HomePostModel.fromMap(Map<String, dynamic> map, String docId) {
    return HomePostModel(
      id: docId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      keyword: map['keyword'] ?? '',
      author: map['author'] ?? '익명',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      uid: map['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'keyword': keyword,
      'author': author,
      'date': date.toIso8601String(),
      'uid': uid,
    };
  }
}

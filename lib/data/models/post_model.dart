class PostModel {
  final String id;
  final String title;
  final String nickname;
  final String content;
  final String boardType;

  PostModel({
    required this.id,
    required this.title,
    required this.nickname,
    required this.content,
    required this.boardType,
  });

  factory PostModel.fromMap(Map<String, dynamic> map, String id) {
    return PostModel(
      id: id,
      title: map['title'] ?? '',
      nickname: map['nickname'] ?? '',
      content: map['content'] ?? '',
      boardType: map['boardType'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'nickname': nickname,
      'content': content,
      'boardType': boardType,
    };
  }
}

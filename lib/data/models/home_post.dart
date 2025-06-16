class HomePost {
  final String title;
  final String content;
  final String keyword;
  final String author;
  // final int? likes;
  // final int comments;
  // 보류
  // final String profileImageUrl;

  HomePost({
    required this.title,
    required this.content,
    required this.keyword,
    required this.author,
    // this.likes = 0,
    // this.comments = 0,

    // 보류
    // required this.profileImageUrl,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'title': title,
  //     'content': content,
  //     'keyword': keyword,
  //     'author': author,
  //     'likes': likes,
  //     'comments': comments,
  //   };
  // }

  // factory HomePost.fromJson(Map<String, dynamic> json) {
  //   return HomePost(
  //     title: json['title'],
  //     content: json['content'],
  //     keyword: json['keyword'],
  //     author: json['author'],
  //     likes: json['likes'] ?? 0,
  //     comments: json['comments'] ?? 0,
  //   );
  // }
}

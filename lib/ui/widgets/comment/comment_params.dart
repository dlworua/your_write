class CommentParams {
  final String boardType; // 'ai_posts', 'home_posts', 'random_posts'
  final String postId;

  CommentParams({required this.boardType, required this.postId});
}

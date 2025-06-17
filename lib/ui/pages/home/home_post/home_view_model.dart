import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/home_post.dart';
import 'package:your_write/ui/pages/home/home_post/home_post_service.dart';

// ignore: non_constant_identifier_names
final homePostListProvider =
    StateNotifierProvider<HomePostListNotifier, List<HomePost>>(
      (ref) => HomePostListNotifier(),
    );

class HomePostListNotifier extends StateNotifier<List<HomePost>> {
  final _service = HomePostService();

  HomePostListNotifier() : super([]);

  Future<void> loadPosts() async {
    final posts = await _service.fetchPosts();
    state = posts;
  }

  Future<void> addPost(HomePost post) async {
    await _service.addPost(post);
    state = [post, ...state]; // 최신글이 위에 오도록
  }

  void clear() => state = [];
}

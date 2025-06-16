import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/home_post.dart';

// ignore: non_constant_identifier_names
final homePostListProvider =
    StateNotifierProvider<HomePostListNotifier, List<HomePost>>(
      (ref) => HomePostListNotifier(),
    );

class HomePostListNotifier extends StateNotifier<List<HomePost>> {
  HomePostListNotifier() : super([]);

  void addPost(HomePost post) {
    state = [post, ...state]; // 최신글이 위에 오도록
  }
}

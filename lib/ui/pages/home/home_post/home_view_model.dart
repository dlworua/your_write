import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/home_post_model.dart';
import 'package:your_write/ui/pages/home/home_post/home_post_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final homePostListProvider =
    StateNotifierProvider<HomePostListNotifier, List<HomePostModel>>(
      (ref) => HomePostListNotifier(),
    );

class HomePostListNotifier extends StateNotifier<List<HomePostModel>> {
  HomePostListNotifier() : super([]) {
    _init();
  }

  final _db = FirebaseFirestore.instance;
  final _service = HomePostService();

  void _init() {
    _db
        .collection('home_posts')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
          final posts =
              snapshot.docs
                  .map((doc) => HomePostModel.fromMap(doc.data(), doc.id))
                  .toList();
          state = posts;
        });
  }

  Future<void> addPost(HomePostModel post) async {
    await _db.collection('home_posts').add(post.toMap());
  }

  Future<void> updatePost(HomePostModel post) async {
    await _service.updatePost(post);
  }

  Future<void> deletePost(String postId) async {
    await _service.deletePost(postId);
  }
}

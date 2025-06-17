import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_write/data/models/home_post.dart';

class HomePostService {
  final _db = FirebaseFirestore.instance;

  Future<void> addPost(HomePost post) async {
    await _db.collection('home_posts').add(post.toMap());
  }

  Future<List<HomePost>> fetchPosts() async {
    final snapshot =
        await _db
            .collection('home_posts')
            .orderBy('date', descending: true)
            .get();

    return snapshot.docs.map((doc) {
      return HomePost.fromMap(doc.data());
    }).toList();
  }
}

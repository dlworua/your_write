import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_write/data/models/comment.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Comment>> getComments(String boardType, String postId) {
    return _firestore
        .collection(boardType)
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Comment.fromMap(doc.data(), doc.id))
                  .toList(),
        );
  }

  Future<void> addComment({
    required String boardType,
    required String postId,
    required Comment comment,
  }) async {
    await _firestore
        .collection(boardType)
        .doc(postId)
        .collection('comments')
        .add(comment.toMap());
  }
}

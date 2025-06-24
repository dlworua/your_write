// 📦 ViewModel: 댓글 + 좋아요 + 저장 통합 상태 관리
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_write/data/models/comment_model.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

final postInteractionProvider = StateNotifierProvider.family<
  PostInteractionViewModel,
  PostInteractionState,
  CommentParams
>((ref, params) => PostInteractionViewModel(params: params));

class PostInteractionState {
  final List<CommentModel> comments;
  final int likeCount;
  final bool isLiked;
  final bool isSaved;

  PostInteractionState({
    required this.comments,
    required this.likeCount,
    required this.isLiked,
    required this.isSaved,
  });

  PostInteractionState copyWith({
    List<CommentModel>? comments,
    int? likeCount,
    bool? isLiked,
    bool? isSaved,
  }) {
    return PostInteractionState(
      comments: comments ?? this.comments,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class PostInteractionViewModel extends StateNotifier<PostInteractionState> {
  final CommentParams params;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  StreamSubscription? _commentSub;

  PostInteractionViewModel({required this.params})
    : super(
        PostInteractionState(
          comments: [],
          likeCount: 0,
          isLiked: false,
          isSaved: false,
        ),
      ) {
    _init();
  }

  Future<void> _init() async {
    _subscribeToComments();
    _loadLikeState();
    _loadSaveState();
  }

  void _subscribeToComments() {
    _commentSub = _firestore
        .collection(params.boardType)
        .doc(params.postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final comments =
              snapshot.docs
                  .map((doc) => CommentModel.fromMap(doc.data(), doc.id))
                  .toList();
          state = state.copyWith(comments: comments);
        });
  }

  Future<void> _loadLikeState() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await _firestore
            .collection(params.boardType)
            .doc(params.postId)
            .collection('likes')
            .doc(uid)
            .get();

    final snap =
        await _firestore
            .collection(params.boardType)
            .doc(params.postId)
            .collection('likes')
            .get();

    state = state.copyWith(isLiked: doc.exists, likeCount: snap.size);
  }

  Future<void> _loadSaveState() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('savedPosts')
            .doc(params.postId)
            .get();

    state = state.copyWith(isSaved: doc.exists);
  }

  Future<void> toggleLike() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final ref = _firestore
        .collection(params.boardType)
        .doc(params.postId)
        .collection('likes')
        .doc(uid);

    if (state.isLiked) {
      await ref.delete();
    } else {
      await ref.set({'createdAt': Timestamp.now()});
    }
    _loadLikeState();
  }

  Future<void> toggleSave() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final ref = _firestore
        .collection('users')
        .doc(uid)
        .collection('savedPosts')
        .doc(params.postId);

    if (state.isSaved) {
      await ref.delete();
    } else {
      await ref.set({
        'boardType': params.boardType,
        'createdAt': Timestamp.now(),
      });
    }
    _loadSaveState();
  }

  Future<void> addComment(String content, String author) async {
    final comment = CommentModel(
      id: '',
      content: content,
      author: author,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection(params.boardType)
        .doc(params.postId)
        .collection('comments')
        .add(comment.toMap());
  }

  @override
  void dispose() {
    _commentSub?.cancel();
    super.dispose();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_write/data/models/comment_model.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';

final postInteractionProvider = StateNotifierProvider.family
    .autoDispose<PostInteractionViewModel, PostInteractionState, CommentParams>(
      (ref, params) {
        // postId 빈 문자열이면 에러 발생 방지용 빈 상태 반환
        if (params.postId.isEmpty) {
          return PostInteractionViewModel.empty();
        }
        final viewModel = PostInteractionViewModel(params);
        ref.keepAlive();
        return viewModel;
      },
    );

class PostInteractionState {
  final bool isLiked;
  final int likeCount;
  final bool isSaved;
  final List<CommentModel> comments;

  PostInteractionState({
    required this.isLiked,
    required this.likeCount,
    required this.isSaved,
    required this.comments,
  });

  PostInteractionState copyWith({
    bool? isLiked,
    int? likeCount,
    bool? isSaved,
    List<CommentModel>? comments,
  }) {
    return PostInteractionState(
      isLiked: isLiked ?? this.isLiked,
      likeCount: likeCount ?? this.likeCount,
      isSaved: isSaved ?? this.isSaved,
      comments: comments ?? this.comments,
    );
  }
}

class PostInteractionViewModel extends StateNotifier<PostInteractionState> {
  final CommentParams? params;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  final String nickname =
      FirebaseAuth.instance.currentUser?.displayName ?? '익명';

  PostInteractionViewModel(this.params)
    : super(
        PostInteractionState(
          isLiked: false,
          likeCount: 0,
          isSaved: false,
          comments: [],
        ),
      ) {
    if (params != null && uid != null) {
      _init();
      _subscribeRealtime();
    }
  }

  // 빈 상태 생성자
  PostInteractionViewModel.empty()
    : params = null,
      super(
        PostInteractionState(
          isLiked: false,
          likeCount: 0,
          isSaved: false,
          comments: [],
        ),
      );

  Future<void> _init() async {
    if (params == null || uid == null) return;

    final docRef = firestore.collection(params!.boardType).doc(params!.postId);

    final likeSnapshot = await docRef.collection('likes').get();
    final isLiked = likeSnapshot.docs.any((doc) => doc.id == uid);

    final savedDoc = await docRef.collection('saves').doc(uid).get();
    final isSaved = savedDoc.exists;

    final commentSnapshot =
        await docRef
            .collection('comments')
            .orderBy('createdAt', descending: true)
            .get();

    final comments =
        commentSnapshot.docs.map((doc) {
          final data = doc.data();
          return CommentModel(
            id: doc.id,
            author: data['author'],
            content: data['content'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

    state = state.copyWith(
      isLiked: isLiked,
      likeCount: likeSnapshot.size,
      isSaved: isSaved,
      comments: comments,
    );
  }

  void _subscribeRealtime() {
    if (params == null || uid == null) return;

    final docRef = firestore.collection(params!.boardType).doc(params!.postId);

    docRef.collection('likes').snapshots().listen((snapshot) {
      final isLiked = snapshot.docs.any((doc) => doc.id == uid);
      final likeCount = snapshot.size;
      state = state.copyWith(isLiked: isLiked, likeCount: likeCount);
    });

    docRef.collection('saves').doc(uid).snapshots().listen((doc) {
      final isSaved = doc.exists;
      state = state.copyWith(isSaved: isSaved);
    });

    docRef
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final comments =
              snapshot.docs.map((doc) {
                final data = doc.data();
                return CommentModel(
                  id: doc.id,
                  author: data['author'],
                  content: data['content'],
                  createdAt: (data['createdAt'] as Timestamp).toDate(),
                );
              }).toList();

          state = state.copyWith(comments: comments);
        });
  }

  Future<void> toggleLike() async {
    if (params == null || uid == null) return;

    final likeDoc = firestore
        .collection(params!.boardType)
        .doc(params!.postId)
        .collection('likes')
        .doc(uid);

    if (state.isLiked) {
      state = state.copyWith(isLiked: false, likeCount: state.likeCount - 1);
      await likeDoc.delete();
    } else {
      state = state.copyWith(isLiked: true, likeCount: state.likeCount + 1);
      await likeDoc.set({'nickname': nickname});
    }
  }

  Future<void> toggleSave() async {
    if (params == null || uid == null) return;

    final saveDoc = firestore
        .collection(params!.boardType)
        .doc(params!.postId)
        .collection('saves')
        .doc(uid);

    if (state.isSaved) {
      await saveDoc.delete();
    } else {
      await saveDoc.set({'nickname': nickname});
    }
  }

  Future<void> addComment(String content) async {
    if (params == null || uid == null) return;
    if (content.trim().isEmpty) return;

    final commentRef =
        firestore
            .collection(params!.boardType)
            .doc(params!.postId)
            .collection('comments')
            .doc();

    final comment = CommentModel(
      id: commentRef.id,
      author: nickname,
      content: content.trim(),
      createdAt: DateTime.now(),
    );

    await commentRef.set({
      'author': comment.author,
      'content': comment.content,
      'createdAt': Timestamp.fromDate(comment.createdAt),
      'uid': uid,
    });
  }
}

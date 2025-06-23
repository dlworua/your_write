import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/comment_model.dart';
import 'package:your_write/ui/widgets/comment/comment_params.dart';
import 'package:your_write/ui/widgets/comment/comment_service.dart';

final commentServiceProvider = Provider((ref) => CommentService());

final commentViewModelProvider = StateNotifierProvider.family<
  CommentViewModel,
  List<CommentModel>,
  CommentParams
>(
  (ref, params) => CommentViewModel(
    service: ref.read(commentServiceProvider),
    params: params,
  ),
);

class CommentViewModel extends StateNotifier<List<CommentModel>> {
  final CommentService service;
  final CommentParams params;
  StreamSubscription? _subscription;

  CommentViewModel({required this.service, required this.params}) : super([]) {
    _subscribeComments();
  }

  void _subscribeComments() {
    _subscription = service.getComments(params.boardType, params.postId).listen(
      (comments) {
        state = comments;
      },
    );
  }

  Future<void> addComment(String content, String author) async {
    final comment = CommentModel(
      id: '',
      content: content,
      author: author,
      createdAt: DateTime.now(),
    );

    await service.addComment(
      boardType: params.boardType,
      postId: params.postId,
      comment: comment,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

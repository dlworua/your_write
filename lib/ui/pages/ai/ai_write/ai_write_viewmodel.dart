import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final aiWriteViewModelProvider =
    StateNotifierProvider<AiWriteViewModel, AsyncValue<WriteModel>>(
      (ref) => AiWriteViewModel(ref),
    );

class AiWriteViewModel extends StateNotifier<AsyncValue<WriteModel>> {
  final Ref ref;

  AiWriteViewModel(this.ref)
    : super(AsyncValue.data(WriteModel.empty(PostType.ai)));

  Future<void> generateContentFromPrompt(String prompt) async {
    state = const AsyncValue.loading();
    try {
      final aiWrite = await ref
          .read(aiWriterServiceProvider)
          .generateStructuredText(prompt);
      final current = state.value ?? WriteModel.empty(PostType.ai);
      final updated = aiWrite.copyWith(nickname: current.nickname);
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void updateFields({
    String? title,
    String? keyWord,
    String? author,
    String? content,
  }) {
    final current = state.value ?? WriteModel.empty(PostType.ai);
    state = AsyncValue.data(
      current.copyWith(
        title: title,
        keyWord: keyWord,
        nickname: author,
        content: content,
      ),
    );
  }

  Future<String?> publishWrite() async {
    final current = state.value;
    if (current == null) return null;

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('ai_writes')
          .add(current.toMap());

      final updated = current.copyWith(id: docRef.id);
      state = AsyncValue.data(updated);

      return docRef.id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }
}

final aiWriteListProvider =
    StateNotifierProvider<AiWriteListViewModel, List<WriteModel>>(
      (ref) => AiWriteListViewModel(AiWriteService()),
    );

class AiWriteListViewModel extends StateNotifier<List<WriteModel>> {
  final AiWriteService _service;

  AiWriteListViewModel(this._service) : super([]);

  Future<void> fetchPosts() async {
    final posts = await _service.fetchAiPosts();
    state = posts;
  }
}

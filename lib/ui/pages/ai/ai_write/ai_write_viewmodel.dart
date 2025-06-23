import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write.dart';
import 'package:your_write/ui/pages/ai/ai_write/ai_write_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final aiWriteViewModelProvider =
    StateNotifierProvider<AiWriteViewModel, AsyncValue<Write>>(
      (ref) => AiWriteViewModel(ref),
    );

class AiWriteViewModel extends StateNotifier<AsyncValue<Write>> {
  final Ref ref;

  AiWriteViewModel(this.ref)
    : super(
        AsyncValue.data(
          Write(
            title: '',
            keyWord: '',
            nickname: '',
            content: '',
            date: DateTime.now(),
            type: PostType.ai,
          ),
        ),
      );

  Future<void> generateContentFromPrompt(String prompt) async {
    state = const AsyncValue.loading();

    try {
      final aiWrite = await ref
          .read(aiWriterServiceProvider)
          .generateStructuredText(prompt);

      final current =
          state.value ??
          Write(
            title: '',
            keyWord: '',
            nickname: '',
            content: '',
            date: DateTime.now(),
            type: PostType.ai,
          );

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
    final current =
        state.value ??
        Write(
          title: '',
          keyWord: '',
          nickname: '',
          content: '',
          date: DateTime.now(),
          type: PostType.ai,
        );

    state = AsyncValue.data(
      current.copyWith(
        title: title,
        keyWord: keyWord,
        nickname: author,
        content: content,
      ),
    );
  }

  /// ✅ 파이어베이스에 출간하는 메서드
  Future<void> publishWrite() async {
    final current = state.value;
    if (current == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('ai_writes') // Firestore 컬렉션 이름
          .add({
            'title': current.title,
            'keyWord': current.keyWord,
            'nickname': current.nickname,
            'content': current.content,
            'date': current.date.toIso8601String(),
            'type': current.type.name, // enum → string 저장
          });
      // ignore: avoid_print
      print('✅ Ai 글 Firestore 저장 완료');
    } catch (e, st) {
      // ignore: avoid_print
      print('❌ Firestore 저장 실패: $e');
      state = AsyncValue.error(e, st);
    }
  }
}

final aiWriteListProvider =
    StateNotifierProvider<AiWriteListViewModel, List<Write>>(
      (ref) => AiWriteListViewModel(AiWriteService()),
    );

class AiWriteListViewModel extends StateNotifier<List<Write>> {
  final AiWriteService _service;

  AiWriteListViewModel(this._service) : super([]);

  Future<void> fetchPosts() async {
    final posts = await _service.fetchAiPosts();
    state = posts;
  }
}

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/random/random_write/random_keyword_list.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_service.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_state.dart';
import 'saved_random_writes_provider.dart';

final randomWriteViewModelProvider =
    StateNotifierProvider<RandomWriteViewModel, RandomWriteState>(
      (ref) => RandomWriteViewModel(ref.read(randomWriteServiceProvider), ref),
    );

class RandomWriteViewModel extends StateNotifier<RandomWriteState> {
  final RandomWriteService _service;
  final Ref ref;

  bool _isSaving = false; // 저장 중복 방지 플래그

  RandomWriteViewModel(this._service, this.ref)
    : super(RandomWriteState.initial());

  void generateKeywords(int count) {
    final random = Random();
    final Set<String> newKeywords = {};

    while (newKeywords.length < count) {
      newKeywords.add(
        randomkeywordList[random.nextInt(randomkeywordList.length)],
      );
    }

    state = state.copyWith(keywords: newKeywords.toList());
  }

  void updateFields({String? title, String? author, String? content}) {
    state = state.copyWith(
      title: title ?? state.title,
      author: author ?? state.author,
      content: content ?? state.content,
    );
  }

  /// 저장 + 상태 업데이트 (중복 저장 방지)
  Future<String?> saveRandomPostToFirestore() async {
    if (_isSaving) {
      print('⚠️ 저장 중복 호출 방지');
      return null;
    }

    final title = state.title.trim();
    final content = state.content.trim();
    final nickname = state.author.trim();
    final keyword = state.keywords.join(', ').trim();

    if (title.isEmpty ||
        content.isEmpty ||
        nickname.isEmpty ||
        keyword.isEmpty) {
      print("❌ Firestore 저장 실패: 입력값이 비어 있음");
      return null;
    }

    _isSaving = true;
    try {
      final write = WriteModel(
        id: '',
        title: title,
        keyWord: keyword,
        nickname: nickname,
        content: content,
        date: DateTime.now(),
        type: PostType.random,
      );

      final docId = await _service.saveWriteToFirestore(write);
      if (docId != null) {
        final newPost = write.copyWith(id: docId);
        // Firestore 저장 후 상태에만 추가 (중복 저장 방지)
        await ref
            .read(savedRandomWritesProvider.notifier)
            .publish(newPost, fromExternal: true);

        state = RandomWriteState.initial();

        return docId;
      }
      return null;
    } catch (e) {
      print('❌ 저장 중 오류 발생: $e');
      return null;
    } finally {
      _isSaving = false;
    }
  }

  Future<void> loadRandomPosts() async {
    // Firestore에서 불러와 새 Provider 상태로 저장
    final posts = await _service.fetchRandomPostsFromFirestore();
    ref.read(savedRandomWritesProvider.notifier).setPosts(posts);
  }
}

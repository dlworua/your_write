import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:your_write/ui/pages/ai/ai_write/saved_ai_writes_provider.dart';
import 'package:your_write/ui/pages/random/random_write/random_keyword_list.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_service.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_state.dart';

final randomWriteViewModelProvider =
    StateNotifierProvider<RandomWriteViewModel, RandomWriteState>(
      (ref) => RandomWriteViewModel(ref.read(randomWriteServiceProvider), ref),
    );

class RandomWriteViewModel extends StateNotifier<RandomWriteState> {
  final RandomWriteService _service;
  final Ref ref;

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

  /// Service를 통해 저장 요청
  Future<void> saveRandomPostToFirestore() async {
    final title = state.title.trim();
    final content = state.content.trim();
    final nickname = state.author.trim();
    final keyword = state.keywords.join(', ').trim();

    // ✅ 저장 조건 검사
    if (title.isEmpty ||
        content.isEmpty ||
        nickname.isEmpty ||
        keyword.isEmpty) {
      print("❌ Firestore 저장 실패: 입력값이 비어 있음");
      return;
    }

    final write = WriteModel(
      title: title,
      keyWord: keyword,
      nickname: nickname,
      content: content,
      date: DateTime.now(),
      type: PostType.random,
    );
    await _service.saveWriteToFirestore(write);
  }

  Future<void> loadRandomPosts() async {
    final posts = await _service.fetchRandomPostsFromFirestore();

    // savedAiWritesProvider에 저장
    for (final post in posts) {
      if (post.type == PostType.random) {
        // 이미 있는 글이 중복 저장되지 않도록 체크하거나 무조건 저장
        ref.read(savedAiWritesProvider.notifier).publish(post);
      }
    }
  }
}

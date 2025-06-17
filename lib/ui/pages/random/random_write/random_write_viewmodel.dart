import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write.dart';
import 'package:your_write/ui/pages/random/random_write/random_keyword_list.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_service.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_state.dart';

final randomWriteViewModelProvider =
    StateNotifierProvider<RandomWriteViewModel, RandomWriteState>(
      (ref) => RandomWriteViewModel(ref.read(randomWriteServiceProvider)),
    );

class RandomWriteViewModel extends StateNotifier<RandomWriteState> {
  final RandomWriteService _service;

  RandomWriteViewModel(this._service) : super(RandomWriteState.initial());

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
    final write = Write(
      title: state.title,
      keyWord: state.keywords.join(', '),
      nickname: state.author,
      content: state.content,
      date: DateTime.now(),
      type: PostType.random,
    );

    await _service.saveWriteToFirestore(write);
  }
}

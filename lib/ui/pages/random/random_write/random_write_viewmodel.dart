// ViewModel: 키워드를 생성하고 저장하는 로직 담당
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/ui/pages/random/random_write/random_keyword_list.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_state.dart';

class RandomWriteViewModel extends StateNotifier<RandomWriteState> {
  RandomWriteViewModel() : super(RandomWriteState.initial());

  // 키워드 갯수만큼 무작위 키워드를 생성
  void generateKeywords(int count) {
    final random = Random();
    final Set<String> newKeywords = {};

    while (newKeywords.length < count) {
      newKeywords.add(
        randomkeywordList[random.nextInt(randomkeywordList.length)],
      );
    }
    // 새로운 키워드를 상태에 반영
    state = state.copyWith(keywords: newKeywords.toList());
  }

  // 저장용 함수 (현재는 print로 출력만 함)
  Future<void> saveRandomPost({
    required String title,
    required String author,
    required String content,
    required List<String> keywords,
  }) async {
    // 실제 저장 전 키워드 정리 예시 (사용하지 않으면 제거 가능)
    // final cleanedKeywords = keywords.map((e) => e.trim()).toList();
    // 실제 저장 로직 (예: Firestore) 구현 예정
    // ignore: avoid_print
    print('[랜덤 저장됨] 제목: $title, 작가: $author, 키워드: $keywords, 내용: $content');
  }

  // 예시 - Firestore 저장 (리스트 형태 권장)
  // await FirebaseFirestore.instance.collection('randomPosts').add({
  //   'title': title,
  //   'author': author,
  //   'content': content,
  //   'keywords': cleanedKeywords,
  // });
}

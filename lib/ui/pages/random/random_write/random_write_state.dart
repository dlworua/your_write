// Riverpod 상태 클래스와 Provider 정의
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/ui/pages/random/random_write/random_write_viewmodel.dart';

// 상태 클래스: 키워드 리스트를 관리
class RandomWriteState {
  final List<String> keywords;

  RandomWriteState({required this.keywords});

  // 초기 상태: 키워드 없음
  factory RandomWriteState.initial() => RandomWriteState(keywords: []);

  // 새로운 키워드로 상태를 갱신
  RandomWriteState copyWith({List<String>? keywords}) {
    return RandomWriteState(keywords: keywords ?? this.keywords);
  }
}

// 상태 관리를 위한 ViewModel Provider
final randomWriteViewModelProvider =
    StateNotifierProvider<RandomWriteViewModel, RandomWriteState>(
      (ref) => RandomWriteViewModel(),
    );

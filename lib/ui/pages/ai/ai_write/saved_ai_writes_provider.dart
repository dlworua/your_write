import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/ai_write.dart';

/// 글 목록을 관리하는 상태 저장용 Provider
final savedAiWritesProvider =
    StateNotifierProvider<AiWriteListNotifier, List<AiWrite>>(
      (ref) => AiWriteListNotifier(),
    );

/// 내부에서 글 목록을 상태로 가지고 있음
class AiWriteListNotifier extends StateNotifier<List<AiWrite>> {
  AiWriteListNotifier() : super([]);

  /// 새로운 글을 목록에 추가
  void publish(AiWrite post) {
    state = [...state, post];
  }

  /// 모든 글 초기화 (필요한 경우 사용)
  void clear() {
    state = [];
  }
}

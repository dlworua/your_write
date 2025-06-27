import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';

final savedRandomWritesProvider =
    StateNotifierProvider<RandomWriteListNotifier, List<WriteModel>>(
      (ref) => RandomWriteListNotifier(),
    );

class RandomWriteListNotifier extends StateNotifier<List<WriteModel>> {
  RandomWriteListNotifier() : super([]);

  /// Firestore 저장은 하지 않고, 상태에만 새 글 추가 (중복 저장 방지)
  Future<String?> publish(WriteModel post, {bool fromExternal = false}) async {
    if (!fromExternal) {
      print('⚠️ publish는 Firestore 저장하지 않고 상태만 업데이트해야 합니다.');
      return null;
    }
    // 외부에서 호출 시 상태에만 추가
    state = [...state, post];
    return post.id;
  }

  /// 글 목록 전체 교체
  void setPosts(List<WriteModel> posts) {
    state = posts;
  }

  /// 상태 초기화
  void clear() {
    state = [];
  }
}

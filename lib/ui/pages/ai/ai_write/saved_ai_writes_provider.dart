import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 글 목록을 관리하는 상태 저장용 Provider
final savedAiWritesProvider =
    StateNotifierProvider<AiWriteListNotifier, List<Write>>(
      (ref) => AiWriteListNotifier(),
    );

/// 내부에서 글 목록을 상태로 가지고 있음
class AiWriteListNotifier extends StateNotifier<List<Write>> {
  AiWriteListNotifier() : super([]);

  /// 새로운 글을 목록에 추가
  Future<void> publish(Write post) async {
    state = [...state, post];
  }

  /// 모든 글을 교체 (Firestore에서 불러온 글 목록 반영용)
  /// ✅ 불러온 글 목록 전체 반영
  void setPosts(List<Write> posts) {
    state = posts;
  }

  /// 모든 글 초기화 (필요한 경우 사용)
  void clear() {
    state = [];
  }
}

/// ✅ Firestore에서 ai_writes 컬렉션을 불러오는 함수
Future<void> loadAiPostsFromFirestore(WidgetRef ref) async {
  final snapshot =
      await FirebaseFirestore.instance
          .collection('ai_writes')
          .orderBy('date', descending: true)
          .get();

  final posts =
      snapshot.docs.map((doc) {
        final data = doc.data();
        return Write(
          title: data['title'] ?? '',
          keyWord: data['keyWord'] ?? '',
          nickname: data['nickname'] ?? '',
          content: data['content'] ?? '',
          date: DateTime.parse(data['date']),
          type: PostType.ai,
        );
      }).toList();

  ref.read(savedAiWritesProvider.notifier).setPosts(posts);
}

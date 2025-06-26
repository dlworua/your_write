// lib/ui/pages/ai/ai_write/saved_ai_writes_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 글 목록을 관리하는 상태 저장용 Provider
final savedAiWritesProvider =
    StateNotifierProvider<AiWriteListNotifier, List<WriteModel>>(
      (ref) => AiWriteListNotifier(),
    );

/// 내부에서 글 목록을 상태로 가지고 있음
class AiWriteListNotifier extends StateNotifier<List<WriteModel>> {
  AiWriteListNotifier() : super([]);

  /// ✅ Firestore 저장 + ID 반환
  Future<String?> publish(WriteModel post) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('ai_writes')
          .add(post.toMap());

      final newPost = post.copyWith(id: docRef.id);
      state = [...state, newPost];
      return docRef.id;
    } catch (e) {
      print('🔥 저장 실패: $e');
      return null;
    }
  }

  /// 모든 글을 교체 (Firestore에서 불러온 글 목록 반영용)
  void setPosts(List<WriteModel> posts) {
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
        return WriteModel(
          id: doc.id,
          title: data['title'] ?? '',
          keyWord: data['keyWord'] ?? '',
          nickname: data['nickname'] ?? '',
          content: data['content'] ?? '',
          date:
              data['date'] is Timestamp
                  ? (data['date'] as Timestamp).toDate()
                  : DateTime.now(),
          type: PostType.ai,
        );
      }).toList();

  ref.read(savedAiWritesProvider.notifier).setPosts(posts);
}

// lib/ui/pages/random/random_write/saved_random_writes_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final savedRandomWritesProvider =
    StateNotifierProvider<RandomWriteListNotifier, List<WriteModel>>(
      (ref) => RandomWriteListNotifier(),
    );

class RandomWriteListNotifier extends StateNotifier<List<WriteModel>> {
  RandomWriteListNotifier() : super([]);

  Future<String?> publish(WriteModel post) async {
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('random_writes')
          .add(post.toMap());

      final newPost = post.copyWith(id: docRef.id);
      state = [...state, newPost];
      return docRef.id;
    } catch (e) {
      print('🔥 랜덤 글 저장 실패: $e');
      return null;
    }
  }

  void setPosts(List<WriteModel> posts) {
    state = posts;
  }

  void clear() {
    state = [];
  }
}

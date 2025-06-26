// lib/ui/pages/random/random_write/random_write_firestore_loader.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_write/data/models/write_model.dart';
import 'saved_random_writes_provider.dart';

Future<void> loadRandomPostsFromFirestore(Ref ref) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('random_writes')
            .orderBy('date', descending: true)
            .get();

    final posts =
        snapshot.docs
            .map((doc) => WriteModel.fromMap(doc.data(), docId: doc.id))
            .toList();

    ref.read(savedRandomWritesProvider.notifier).setPosts(posts);
  } catch (e) {
    print('❌ 랜덤 글 불러오기 실패: $e');
  }
}

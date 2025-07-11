// lib/ui/pages/random/random_write/random_write_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write_model.dart';

final randomWriteServiceProvider = Provider<RandomWriteService>((ref) {
  return RandomWriteService();
});

class RandomWriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> saveWriteToFirestore(WriteModel write) async {
    try {
      final docRef = await _firestore.collection('random_writes').add({
        'title': write.title,
        'keyWord': write.keyWord,
        'nickname': write.nickname,
        'content': write.content,
        'date': write.date,
        'type': write.type.name,
      });
      print('✅ 랜덤 글 Firestore 저장 성공');
      return docRef.id;
    } catch (e) {
      print('❌ 랜덤 글 저장 실패: $e');
      return null;
    }
  }

  Future<List<WriteModel>> fetchRandomPostsFromFirestore() async {
    try {
      final snapshot =
          await _firestore
              .collection('random_writes')
              .orderBy('date', descending: true)
              .get();

      return snapshot.docs
          .map((doc) => WriteModel.fromMap(doc.data(), docId: doc.id))
          .toList();
    } catch (e) {
      print('❌ 랜덤 글 불러오기 실패: $e');
      return [];
    }
  }
}

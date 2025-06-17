// random_write_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_write/data/models/write.dart';

final randomWriteServiceProvider = Provider<RandomWriteService>((ref) {
  return RandomWriteService();
});

class RandomWriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveWriteToFirestore(Write write) async {
    try {
      await _firestore.collection('random_writes').add({
        'title': write.title,
        'keyWord': write.keyWord,
        'nickname': write.nickname,
        'content': write.content,
        'date': write.date,
        'type': write.type.name, // "random"
      });
      print('✅ 랜덤 글 Firestore 저장 성공');
    } catch (e) {
      print('❌ 랜덤 글 저장 실패: $e');
    }
  }
}

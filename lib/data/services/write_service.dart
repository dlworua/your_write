import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_write/data/models/write.dart';

class WriteService {
  final _firestore = FirebaseFirestore.instance;

  Future<void> saveWrite(Write write) async {
    await _firestore.collection('writes').add({
      'title': write.title,
      'keyWord': write.keyWord,
      'nickname': write.nickname,
      'content': write.content,
      'date': write.date.toIso8601String(),
      'type': write.type.name, // 'ai' 또는 'random'
    });
  }
}

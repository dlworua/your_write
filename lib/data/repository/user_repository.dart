import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  // Firestore의 'users' 컬렉션 참조를 저장하는 변수
  final CollectionReference _usersCollection;

  // 생성자: Firestore 인스턴스에서 'users' 컬렉션을 초기화
  UserRepository()
    : _usersCollection = FirebaseFirestore.instance.collection('users');

  // 사용자 데이터를 Firestore에 저장하는 비동기 함수
  Future<void> saveUser(UserModel user) async {
    // uid를 문서 ID로 사용해 사용자 데이터를 Map 형태로 저장
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  // uid로 Firestore에서 사용자 데이터를 가져오는 비동기 함수
  Future<UserModel?> fetchUser(String uid) async {
    // 해당 uid의 문서 가져오기
    final doc = await _usersCollection.doc(uid).get();

    // 문서가 존재하면 UserModel 인스턴스로 변환 후 반환
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }

    // 문서가 없으면 null 반환
    return null;
  }
}

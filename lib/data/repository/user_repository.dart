import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  // ignore: unused_field
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection;

  UserRepository()
    : _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> saveUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> fetchUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}

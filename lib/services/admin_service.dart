import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  /// 현재 사용자가 관리자인지 확인
  /// 보안: Firestore의 isAdmin 필드만 신뢰
  static Future<bool> isAdmin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // Firestore에서만 확인 (보안 강화)
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final isAdmin = doc.data()?['isAdmin'] as bool? ?? false;
      return isAdmin;
    } catch (e) {
      return false;
    }
  }

  /// 현재 로그인한 사용자의 UID
  static String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  /// 현재 로그인한 사용자의 이메일
  static String? get currentUserEmail =>
      FirebaseAuth.instance.currentUser?.email;
}

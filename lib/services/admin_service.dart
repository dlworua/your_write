import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  static const List<String> _adminEmails = [
    // 관리자 이메일 목록 (나중에 Firestore로 옮길 수 있음)
    // 'admin@example.com',
  ];

  /// 현재 사용자가 관리자인지 확인
  static Future<bool> isAdmin() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // 이메일 기반 확인
      if (_adminEmails.contains(user.email)) {
        return true;
      }

      // Firestore에서 확인 (선택적)
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

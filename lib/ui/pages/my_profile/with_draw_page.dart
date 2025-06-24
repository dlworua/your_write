// 회원탈퇴 기능
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WithDrawPage extends StatelessWidget {
  const WithDrawPage({super.key});

  // 실제 회원 탈퇴 처리를 수행하는 함수
  Future<void> _deleteUser(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자

    if (user == null) return; // 사용자가 없을 경우 리턴

    try {
      final uid = user.uid;

      // Firestore에 저장된 사용자 데이터 삭제
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // Firebase Auth 계정 삭제
      await user.delete();

      // 탈퇴 완료 메시지 표시
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('회원 탈퇴가 완료되었습니다.')));

      // 로그인 화면으로 이동하며 기존 스택 제거
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      // 최근 로그인 필요 오류 처리
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('보안을 위해 다시 로그인 후 탈퇴해주세요.')),
        );
      } else {
        // 그 외 Firebase Auth 오류 처리
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류: ${e.message}')));
      }
    }
  }

  // 탈퇴 확인 다이얼로그 표시
  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('회원 탈퇴'), // 다이얼로그 제목
            content: const Text('정말 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다.'), // 안내 메시지
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context), // 취소 버튼
                child: const Text('취소'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그 닫기
                  _deleteUser(context); // 탈퇴 함수 실행
                },
                child: const Text('탈퇴하기'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원 탈퇴')), // 앱바 제목
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // 빨간 버튼
          onPressed: () => _showConfirmDialog(context), // 버튼 클릭 시 확인 다이얼로그 표시
          child: const Text(
            '회원 탈퇴',
            style: TextStyle(color: Colors.white),
          ), // 버튼 텍스트
        ),
      ),
    );
  }
}

// 프로필 수정 페이지
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nicknameController = TextEditingController(); // 닉네임 입력 컨트롤러
  bool _isSaving = false; // 저장 중 상태 표시

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 페이지 로딩 시 유저 정보 불러오기
  }

  // 현재 사용자 Firestore 정보에서 닉네임 불러오기
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      _nicknameController.text = doc.data()?['nickname'] ?? ''; // 입력창에 닉네임 설정
    }
  }

  // 닉네임을 Firestore에 저장하는 함수
  Future<void> _saveProfile() async {
    final nickname = _nicknameController.text.trim(); // 공백 제거
    if (nickname.isEmpty) return; // 닉네임이 비어있으면 저장하지 않음

    setState(() => _isSaving = true); // 저장 중 상태로 전환

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Firestore에 닉네임 업데이트
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'nickname': nickname});

        // 저장 완료 메시지
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('프로필이 저장되었습니다.')));

        Navigator.pop(context); // 이전 페이지로 돌아가기
      }
    } catch (e) {
      // 오류 발생 시 메시지 출력
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('오류 발생: $e')));
    } finally {
      setState(() => _isSaving = false); // 저장 완료 상태로 전환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')), // 상단 앱바

      body: Padding(
        padding: const EdgeInsets.all(24), // 전체 패딩
        child: Column(
          children: [
            // 닉네임 입력 필드
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),

            const SizedBox(height: 24), // 간격
            // 저장 버튼
            ElevatedButton(
              onPressed: _isSaving ? null : _saveProfile, // 저장 중이면 버튼 비활성화
              child:
                  _isSaving
                      ? const CircularProgressIndicator() // 로딩 표시
                      : const Text('저장하기'), // 저장 텍스트
            ),
          ],
        ),
      ),
    );
  }
}

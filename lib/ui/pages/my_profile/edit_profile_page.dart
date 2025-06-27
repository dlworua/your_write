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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '프로필이 저장되었습니다.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFFD4AF37),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );

        Navigator.pop(context); // 이전 페이지로 돌아가기
      }
    } catch (e) {
      // 오류 발생 시 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '오류 발생: $e',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: const Color(0xFFCD853F),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } finally {
      setState(() => _isSaving = false); // 저장 완료 상태로 전환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E3), // 따뜻한 크림색 배경
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          '프로필 수정',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFFD4AF37), // 따뜻한 골드색
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 198, 169, 140), // 크림색
                Color(0xFFFAF0E6), // 따뜻한 베이지
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_rounded, size: 18),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFDF6E3), // 크림색
              Color(0xFFFAF0E6), // 따뜻한 베이지
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 부드러운 그라데이션 구분선
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFD4AF37).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 메인 카드
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCD853F).withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 제목 섹션
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Color(0xFFD4AF37),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '프로필 정보',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8B4513),
                              ),
                            ),
                            Text(
                              '닉네임을 수정할 수 있어요',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFCD853F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // 닉네임 입력 필드
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '닉네임',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF6E3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFD4AF37).withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            controller: _nicknameController,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8B4513),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: '새로운 닉네임을 입력해주세요',
                              hintStyle: TextStyle(
                                color: const Color(0xFF8B4513).withOpacity(0.5),
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.only(
                                  left: 12,
                                  right: 8,
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.7),
                                  size: 20,
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // 저장 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            _isSaving
                                ? null
                                : (_nicknameController.text.trim().isEmpty
                                    ? null
                                    : _saveProfile),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            212,
                            195,
                            145,
                          ),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          disabledBackgroundColor: const Color.fromARGB(
                            255,
                            175,
                            167,
                            140,
                          ).withOpacity(0.5),
                        ).copyWith(
                          overlayColor: WidgetStateProperty.all(
                            Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child:
                            _isSaving
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      '저장하기',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

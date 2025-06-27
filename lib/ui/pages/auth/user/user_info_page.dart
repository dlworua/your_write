// 사용자 추가 정보 입력 페이지 (닉네임 입력)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_write/data/models/user_model.dart';
import 'package:your_write/data/repository/user_repository.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _nicknameController = TextEditingController(); // 닉네임 입력 컨트롤러
  bool _isSaving = false; // 저장 중 여부
  final UserRepository _userRepository = UserRepository(); // 사용자 저장용 레포지토리 인스턴스

  // 사용자 정보 저장 함수
  Future<void> _saveUserInfo() async {
    final nickname = _nicknameController.text.trim(); // 닉네임 앞뒤 공백 제거
    if (nickname.isEmpty) return; // 닉네임이 없으면 저장하지 않음

    setState(() => _isSaving = true); // 저장 중 상태 표시

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // FirebaseAuth 사용자 프로필에 닉네임 업데이트
        await user.updateDisplayName(nickname);

        // Firestore에 사용자 정보 저장
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          nickname: nickname,
        );
        await _userRepository.saveUser(userModel); // 레포지토리를 통해 저장

        // 홈 페이지로 이동 (기존 스택 제거)
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      // 오류 발생 시 메시지 출력
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('프로필 저장 실패: ${e.toString()}')));
    } finally {
      setState(() => _isSaving = false); // 저장 종료 상태
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose(); // 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // 따뜻한 크림톤 배경
      appBar: AppBar(
        title: const Text(
          '추가 정보 입력',
          style: TextStyle(
            color: Color(0xFF8B4513), // 브라운 계열 텍스트
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF8B4513)), // 뒤로가기 아이콘 색
      ),
      body: Container(
        decoration: const BoxDecoration(
          // 위에서 아래로 그라디언트 배경
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF8F0), // 크림색
              Color(0xFFFFF0E6), // 살구색
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 인물 아이콘 (원형 배경)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE4B5).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    size: 60,
                    color: Color(0xFFCD853F),
                  ),
                ),

                const SizedBox(height: 40),

                // 환영 메시지
                const Text(
                  '환영합니다! 🌻',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513),
                  ),
                ),

                const SizedBox(height: 16),

                // 설명 메시지
                const Text(
                  '사용하실 닉네임을 입력해주세요.\n함께 따스한 시간을 만들어가요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFA0522D),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // 닉네임 입력 필드
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDEB887).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _nicknameController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF8B4513),
                    ),
                    decoration: InputDecoration(
                      labelText: '닉네임',
                      labelStyle: const TextStyle(
                        color: Color(0xFFCD853F),
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: const Icon(
                        Icons.edit_rounded,
                        color: Color(0xFFCD853F),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color(0xFFCD853F),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 저장 버튼
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDEB887), Color(0xFFCD853F)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCD853F).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveUserInfo, // 저장 중이면 비활성화
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // 버튼 투명 (Gradient 보여지도록)
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child:
                        _isSaving
                            ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '저장하고 시작하기',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

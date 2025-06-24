import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 이메일 로그인 페이지 (StatefulWidget)
class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final _formKey = GlobalKey<FormState>(); // 폼 유효성 검사용 키
  final _emailController = TextEditingController(); // 이메일 입력 컨트롤러
  final _passwordController = TextEditingController(); // 비밀번호 입력 컨트롤러

  bool _isLoading = false; // 로그인 처리 중 로딩 상태
  String? _errorMessage; // 에러 메시지 상태 저장

  // 로그인 함수
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return; // 폼 검증 실패 시 중단

    setState(() {
      _isLoading = true; // 로딩 상태 시작
      _errorMessage = null; // 이전 에러 초기화
    });

    try {
      // FirebaseAuth 이메일/비밀번호 로그인 시도
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // 이메일 인증 확인
      if (!userCredential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut(); // 인증 안됐으면 로그아웃 처리
        setState(() {
          _errorMessage = '이메일 인증이 필요합니다. 메일을 확인하세요.'; // 에러 메시지 표시
        });
        return;
      }

      // 인증 완료 시 홈 화면으로 이동
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      // Firebase 로그인 오류 코드에 따른 메시지 분기 처리
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = '가입된 이메일이 없습니다.';
          break;
        case 'wrong-password':
          message = '비밀번호가 올바르지 않습니다.';
          break;
        case 'invalid-email':
          message = '올바른 이메일 주소를 입력하세요.';
          break;
        case 'user-disabled':
          message = '해당 계정은 비활성화되었습니다.';
          break;
        default:
          message = '로그인 중 오류가 발생했습니다.';
      }
      setState(() {
        _errorMessage = message; // 에러 메시지 상태 업데이트
      });
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태 종료
      });
    }
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // 따스한 크림색 배경
      body: Container(
        decoration: const BoxDecoration(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // 따스한 환영 아이콘 컨테이너
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4B5).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.waving_hand_rounded,
                      size: 50,
                      color: Color(0xFFCD853F),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 환영 텍스트
                  const Text(
                    '만나서 반가워요! 🌻',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '따스한 공간으로 어서오세요:)',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFA0522D),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 로그인 폼 카드 컨테이너
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDEB887).withOpacity(0.3),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey, // 폼 키 연결
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 이메일 입력 필드
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8B4513),
                            ),
                            decoration: InputDecoration(
                              labelText: '이메일',
                              labelStyle: const TextStyle(
                                color: Color(0xFFCD853F),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Color(0xFFCD853F),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFCD853F),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFFF8F0),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return '이메일을 입력하세요.';
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value))
                                return '올바른 이메일을 입력하세요.';
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // 비밀번호 입력 필드
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF8B4513),
                            ),
                            decoration: InputDecoration(
                              labelText: '비밀번호',
                              labelStyle: const TextStyle(
                                color: Color(0xFFCD853F),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFFCD853F),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xFFCD853F),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFFFF8F0),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return '비밀번호를 입력하세요.';
                              if (value.length < 6)
                                return '비밀번호는 6자 이상이어야 합니다.';
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          // 에러 메시지 표시 영역 (조건부 렌더링)
                          if (_errorMessage != null)
                            Container(
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE4E1),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xFFB85450,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFB85450,
                                      ).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.error_outline_rounded,
                                      color: Color(0xFFB85450),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: Color(0xFFB85450),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // 로그인 버튼 컨테이너 (그라디언트 및 그림자 포함)
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFDEB887), Color(0xFFCD853F)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFCD853F,
                                  ).withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading ? null : _login, // 로딩 중에는 비활성화
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent, // 배경 투명
                                shadowColor: Colors.transparent, // 그림자 제거
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '로그인',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.login_rounded,
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

                  const SizedBox(height: 32),

                  // 회원가입 링크 영역
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFDEB887).withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDEB887).withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '아직 계정이 없으신가요?',
                          style: TextStyle(
                            color: Color(0xFFA0522D),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed('/agreement'); // 약관 페이지로 이동
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCD853F).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '회원가입 🌱',
                              style: TextStyle(
                                color: Color(0xFFCD853F),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

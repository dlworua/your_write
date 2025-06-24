import 'package:flutter/material.dart'; // Flutter UI 라이브러리 임포트
import 'package:firebase_auth/firebase_auth.dart'; // Firebase 인증 라이브러리 임포트
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 라이브러리 임포트
import 'package:your_write/data/models/user_model.dart'; // 사용자 모델 임포트

// 회원가입 페이지 위젯 정의, agreeMarketing은 마케팅 동의 여부를 받는 필수 인자
class SignUpPage extends StatefulWidget {
  final bool agreeMarketing;

  const SignUpPage({super.key, required this.agreeMarketing});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

// SignUpPage의 상태를 관리하는 클래스
class _SignUpPageState extends State<SignUpPage> {
  // 입력 컨트롤러들 선언 (이메일, 비밀번호, 비밀번호 확인, 닉네임)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // 폼 상태 키 (검증용)
  bool isLoading = false; // 로딩 상태 변수
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase 인증 인스턴스
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Firestore 인스턴스

  // 회원가입 비동기 함수
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return; // 폼 검증 실패 시 함수 종료

    setState(() => isLoading = true); // 로딩 시작 상태 설정

    try {
      final email = _emailController.text.trim(); // 이메일 입력값 트림
      final password = _passwordController.text.trim(); // 비밀번호 입력값 트림

      // Firebase에 사용자 생성 요청
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!; // 생성된 사용자 정보 가져오기
      await user.updateDisplayName(
        _nicknameController.text.trim(),
      ); // 닉네임 Firebase 프로필에 업데이트
      await user.sendEmailVerification(); // 이메일 인증 메일 전송

      // Firestore에 사용자 정보 저장을 위한 UserModel 생성
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        nickname: _nicknameController.text.trim(),
        agreeMarketing: widget.agreeMarketing,
      );

      // Firestore 'users' 컬렉션에 사용자 문서 저장
      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      // 이메일 인증 안내 다이얼로그 표시 (사용자에게 인증 안내 메시지)
      await showDialog(
        context: context,
        barrierDismissible: false, // 다이얼로그 외부 탭 막기
        builder:
            (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32), // 둥근 모서리
              ),
              child: Container(
                padding: const EdgeInsets.all(36), // 내부 여백
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFF8E1), // 크림색 그라데이션 시작
                      Color(0xFFFFE0B2), // 오렌지색 그라데이션 끝
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // 최소 높이만 차지
                  children: [
                    // 이메일 아이콘 컨테이너
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFFF8A65,
                        ).withOpacity(0.15), // 반투명 오렌지 배경
                        borderRadius: BorderRadius.circular(45), // 둥근 원형
                        border: Border.all(
                          color: const Color(
                            0xFFFF8A65,
                          ).withOpacity(0.3), // 테두리 색상
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined, // 이메일 확인 아이콘
                        size: 45,
                        color: Color(0xFFD84315), // 진한 오렌지 색상
                      ),
                    ),
                    const SizedBox(height: 28), // 공간
                    const Text(
                      '💌 이메일 인증', // 제목 텍스트
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5D4037), // 짙은 갈색
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 20), // 공간
                    const Text(
                      '따뜻한 인사와 함께 인증 메일을\n보내드렸어요!\n\n메일함을 확인해 주세요 ☺️', // 안내 텍스트
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF6D4C41), // 부드러운 갈색
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 36), // 공간
                    Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27), // 둥근 모서리
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFAB91),
                            Color(0xFFFF8A65),
                          ], // 그라데이션 색상
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFFF8A65,
                            ).withOpacity(0.3), // 그림자 색
                            blurRadius: 12,
                            offset: const Offset(0, 6), // 그림자 위치
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed:
                            () =>
                                Navigator.pop(context), // 확인 버튼 눌렀을 때 다이얼로그 닫기
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // 투명 배경
                          shadowColor: Colors.transparent, // 그림자 없음
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              27,
                            ), // 둥근 버튼 모서리
                          ),
                        ),
                        child: const Text(
                          '확인했어요', // 버튼 텍스트
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // 흰색 글자
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );

      // 다이얼로그가 닫히면 '/check-email' 페이지로 이동 (이메일 인증 대기 페이지 등)
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/check-email');
      }
    } on FirebaseAuthException catch (e) {
      // FirebaseAuth 오류 처리
      // ignore: unused_local_variable
      String message = '회원가입에 실패했습니다.'; // 기본 오류 메시지
      if (e.code == 'email-already-in-use') {
        message = '이미 사용 중인 이메일입니다.'; // 중복 이메일
      } else if (e.code == 'invalid-email') {
        message = '올바르지 않은 이메일 형식입니다.'; // 잘못된 이메일 형식
      } else if (e.code == 'weak-password') {
        message = '비밀번호는 6자 이상이어야 합니다.'; // 약한 비밀번호
      }
      // 여기서 메시지를 사용자에게 보여주는 UI를 추가해도 좋음 (예: SnackBar)
    } finally {
      setState(() => isLoading = false); // 로딩 상태 해제
    }
  }

  @override
  void dispose() {
    // 컨트롤러 메모리 해제
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  // 텍스트 필드 커스텀 빌더 함수 (컨트롤러, 라벨, 아이콘, 유효성 검사, 보안 텍스트 여부 등)
  Widget _buildTextField({
    required TextEditingController controller, // 입력 컨트롤러
    required String label, // 라벨 텍스트
    required IconData icon, // 앞 아이콘
    required String? Function(String?) validator, // 검증 함수
    bool obscureText = false, // 비밀번호 등 가림 여부
    TextInputType? keyboardType, // 키보드 타입 (이메일, 숫자 등)
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24), // 아래 마진
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨 텍스트
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8D6E63), // 짙은 갈색
              ),
            ),
          ),
          // 텍스트 필드 컨테이너 (박스 그림자 포함)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), // 둥근 모서리
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD7CCC8).withOpacity(0.3), // 연한 그림자
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5D4037), // 진한 갈색
              ),
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 8, right: 12),
                  child: Icon(
                    icon,
                    color: const Color(0xFFBCAAA4),
                    size: 22,
                  ), // 아이콘
                ),
                hintText: '$label을 입력해주세요', // 힌트 텍스트
                hintStyle: const TextStyle(
                  color: Color(0xFFBCAAA4), // 연한 갈색
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none, // 테두리 없음
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none, // 활성화 시 테두리 없음
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF8A65), // 오렌지색 테두리
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5722), // 오류 빨간색 테두리
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF5722), // 오류 빨간색 테두리 (포커스)
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: const Color(0xFFFFF3E0), // 밝은 배경색
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
              ),
              validator: validator, // 검증 함수 적용
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 전체 페이지 UI 빌드
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // 따뜻한 크림 배경색
      appBar: AppBar(
        title: const Text(
          '🌱 회원가입', // 앱바 제목
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Color(0xFF5D4037), // 짙은 갈색
          ),
        ),
        backgroundColor: Colors.transparent, // 앱바 배경 투명
        elevation: 0, // 그림자 없음
        centerTitle: true, // 제목 가운데 정렬
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded, // 뒤로 가기 아이콘
            color: Color(0xFF8D6E63), // 연한 갈색
          ),
          onPressed: () => Navigator.pop(context), // 뒤로 가기 처리
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24), // 페이지 패딩
          child: Column(
            children: [
              const SizedBox(height: 20), // 상단 여백
              // 따뜻한 환영 섹션
              Container(
                width: double.infinity, // 가로 최대폭
                padding: const EdgeInsets.all(36), // 내부 여백
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFE0B2), // 부드러운 오렌지
                      Color(0xFFFFCC80), // 따뜻한 복숭아색
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32), // 둥근 모서리
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFCC80).withOpacity(0.4), // 그림자
                      blurRadius: 20,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '☕️ Your Write\n가입을 환영합니다!', // 환영 메시지
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.brown[500], // 부드러운 갈색
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14), // 공간
                    Text(
                      '작가님만의 이야기를 써보세요 🌿', // 서브 메시지
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green[500], // 부드러운 초록색
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40), // 공간
              // 회원가입 폼 카드
              Container(
                padding: const EdgeInsets.all(36), // 내부 여백
                decoration: BoxDecoration(
                  color: Colors.white, // 흰색 배경
                  borderRadius: BorderRadius.circular(32), // 둥근 모서리
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD7CCC8).withOpacity(0.2), // 연한 그림자
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey, // 폼 키 적용
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch, // 폭 최대
                    children: [
                      // 폼 제목
                      const Text(
                        '✨ 계정 만들기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5D4037), // 짙은 갈색
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8), // 공간
                      const Text(
                        '몇 가지 정보만 알려주세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF8D6E63), // 연한 갈색
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32), // 공간
                      // 이름 입력 필드
                      _buildTextField(
                        controller: _nicknameController,
                        label: '이름',
                        icon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return '이름을 입력해주세요.'; // 이름 검증 메시지
                          }
                          return null;
                        },
                      ),

                      // 이메일 입력 필드
                      _buildTextField(
                        controller: _emailController,
                        label: '이메일',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return '이메일을 입력해주세요.'; // 이메일 검증
                          if (!val.contains('@'))
                            return '이메일 형식이 올바르지 않아요.'; // 형식 검증
                          return null;
                        },
                      ),

                      // 비밀번호 입력 필드
                      _buildTextField(
                        controller: _passwordController,
                        label: '비밀번호',
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        validator: (val) {
                          if (val == null || val.length < 6)
                            return '6자 이상 입력해주세요.'; // 비밀번호 길이 검증
                          return null;
                        },
                      ),

                      // 비밀번호 확인 입력 필드
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: '비밀번호 확인',
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        validator: (val) {
                          if (val != _passwordController.text)
                            return '비밀번호가 일치하지 않아요.'; // 비밀번호 일치 검증
                          return null;
                        },
                      ),

                      const SizedBox(height: 8), // 공간
                      // 회원가입 버튼 컨테이너
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30), // 둥근 모서리
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFFAB91), // 산호색 그라데이션 시작
                              Color(0xFFFF8A65), // 오렌지 그라데이션 끝
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFFFAB91,
                              ).withOpacity(0.4), // 그림자
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : _signUp, // 로딩 중이면 버튼 비활성화, 아니면 _signUp 호출
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // 투명 배경
                            shadowColor: Colors.transparent, // 그림자 없음
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                30,
                              ), // 둥근 모서리 버튼
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white, // 흰색 로딩 인디케이터
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    '🌟 시작하기', // 버튼 텍스트
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40), // 하단 공간
            ],
          ),
        ),
      ),
    );
  }
}

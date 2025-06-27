import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 이메일 인증 확인 페이지 (StatefulWidget)
class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage>
    with TickerProviderStateMixin {
  Timer? _timer; // 주기적으로 이메일 인증 상태 확인하는 타이머
  // ignore: unused_field
  bool _isVerified = false; // 이메일 인증 완료 여부 상태
  bool _isSending = false; // 인증 메일 재전송 중 상태

  // 애니메이션 컨트롤러와 애니메이션 선언
  late final AnimationController _pulseController;
  late final AnimationController _rotationController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations(); // 애니메이션 초기화
    _startEmailCheckTimer(); // 이메일 인증 주기 체크 시작
  }

  // 애니메이션 초기화 함수
  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // 크기 확대/축소 애니메이션 (펄스)
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // 회전 애니메이션
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseController.repeat(reverse: true); // 반복 (역방향 포함)
    _rotationController.repeat(); // 무한 반복
  }

  // 이메일 인증 상태 주기적 확인 타이머 시작
  void _startEmailCheckTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload(); // 사용자 정보 새로고침
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        setState(() {
          _isVerified = true; // 인증 완료 플래그 업데이트
        });
        timer.cancel(); // 타이머 중지
        Navigator.of(context).pushReplacementNamed('/user-info'); // 다음 화면 이동
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 타이머 취소
    _pulseController.dispose(); // 애니메이션 컨트롤러 해제
    _rotationController.dispose();
    super.dispose();
  }

  // 인증 메일 재전송 함수
  Future<void> _resendEmail() async {
    if (_isSending) return; // 이미 전송 중이면 무시
    setState(() => _isSending = true); // 전송 상태 시작
    try {
      await FirebaseAuth.instance.currentUser
          ?.sendEmailVerification(); // 재전송 요청
      _showSnackBar(
        message: '인증 메일을 다시 보냈습니다. 메일함을 확인하세요.',
        color: const Color(0xFFD4A574),
        icon: Icons.check_circle_outline,
      );
    } catch (e) {
      _showSnackBar(
        message: '인증 메일 전송 중 오류가 발생했습니다.',
        color: const Color(0xFFB85450),
        icon: Icons.error_outline,
      );
    } finally {
      setState(() => _isSending = false); // 전송 상태 종료
    }
  }

  // 스낵바 표시 함수
  void _showSnackBar({
    required String message,
    required Color color,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // 크림색 배경
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
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildMainCard(), // 메인 카드 빌드
                const SizedBox(height: 30),
                _buildTipsCard(), // 도움말 카드 빌드
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 메인 카드 UI
  Widget _buildMainCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDEB887).withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 펄스 애니메이션 아이콘
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDEB887), Color(0xFFCD853F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCD853F).withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          // 안내 문구 타이틀
          const Text(
            '메일함을 확인해주세요! 💌',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B4513),
            ),
          ),
          const SizedBox(height: 16),

          // 안내 서브 텍스트
          const Text(
            '메일함 확인 후 인증을 완료하시면\n저희와 함께하실 수 있답니다 🌼',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFA0522D),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),

          // 인증 대기 로딩 인디케이터
          _buildLoadingIndicator(),
          const SizedBox(height: 32),

          // 인증 메일 재전송 버튼
          _buildResendButton(),
        ],
      ),
    );
  }

  // 인증 대기 상태 표시 UI
  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFDEB887).withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 회전 애니메이션 아이콘
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFFCD853F),
                  size: 24,
                ),
              );
            },
          ),
          const SizedBox(width: 12),

          // 상태 텍스트
          const Text(
            '인증을 기다리고 있어요...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFCD853F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 인증 메일 재전송 버튼 UI
  Widget _buildResendButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFCD853F), width: 2),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFDEB887).withOpacity(0.1),
            const Color(0xFFCD853F).withOpacity(0.1),
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: _isSending ? null : _resendEmail, // 전송 중이면 비활성화
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child:
            _isSending
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFCD853F),
                    ),
                  ),
                )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFFCD853F),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '인증 메일 다시 보내기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFCD853F),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  // 도움말 카드 UI
  Widget _buildTipsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFDEB887).withOpacity(0.15),
            const Color(0xFFCD853F).withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFDEB887).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 도움말 헤더
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFCD853F).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Color(0xFFCD853F),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '작은 도움말 💡',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 개별 도움말 아이템들
          _buildTipItem('📬', '메일이 오지 않았다면 스팸함도 확인해보세요!'),
          const SizedBox(height: 12),
          _buildTipItem('✨', '인증 완료되면 자동으로 다음 단계로 넘어가요!'),
          const SizedBox(height: 12),
          _buildTipItem('🔄', '문제가 있다면 언제든 다시 보내기를 눌러주세요!'),
        ],
      ),
    );
  }

  // 도움말 아이템 UI
  Widget _buildTipItem(String emoji, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFA0522D),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

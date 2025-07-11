import 'package:flutter/material.dart';
import 'package:your_write/ui/pages/ai/ai_detail/ai_detail.dart';
import 'package:your_write/ui/pages/auth/agreement/agreement_page.dart';
import 'package:your_write/ui/pages/auth/email/check_email_page.dart';
import 'package:your_write/ui/pages/auth/email/email_login_page.dart';
import 'package:your_write/ui/pages/auth/signup/signup_page.dart';
import 'package:your_write/ui/pages/auth/user/user_info_page.dart';
import 'package:your_write/ui/pages/home/home_detail/detail_page.dart'; // 홈 상세페이지 import 추가
import 'package:your_write/ui/pages/random/random_detail/random_detail.dart';
import 'package:your_write/ui/pages/main_page.dart';
import 'package:your_write/ui/pages/my_profile/edit_profile_page.dart';

class AppRoutes {
  // 고정된 라우트 정의: 각 경로 문자열과 해당 페이지 위젯을 매핑
  static Map<String, WidgetBuilder> get routes => {
    '/login': (context) => const EmailLoginPage(), // 로그인 페이지
    '/check-email': (context) => const CheckEmailPage(), // 이메일 인증 대기 페이지
    '/agreement': (context) => const AgreementPage(), // 약관 동의 페이지
    '/user-info': (context) => const UserInfoPage(), // 유저 추가 정보 입력 페이지
    '/home': (context) => const MainPage(), // 메인 홈 페이지
    '/edit-profile': (context) => const EditProfilePage(), // 프로필 수정 페이지
  };

  // 동적 라우트 처리 (예: arguments 전달이 필요한 경우)
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // '/signup' 경로일 경우 arguments 처리
    if (settings.name == '/signup') {
      // arguments는 보통 약관 동의 여부(agreeMarketing 등)를 포함
      final args = settings.arguments as Map<String, dynamic>?;

      // SignUpPage에 동의 여부 인자를 넘겨줌
      return MaterialPageRoute(
        builder:
            (context) =>
                SignUpPage(agreeMarketing: args?['agreeMarketing'] ?? false),
      );
    }

    // 홈 상세페이지 라우팅 추가
    if (settings.name == '/home-detail') {
      final args = settings.arguments as Map<String, dynamic>?;

      return MaterialPageRoute(
        builder:
            (context) => HomeDetailPage(
              postId: args?['postId'] ?? '',
              title: args?['title'] ?? '',
              content: args?['content'] ?? '',
              author: args?['author'] ?? '',
              keyword: args?['keyword'] ?? '',
              date: args?['date'] ?? DateTime.now(),
              scrollToCommentInput: args?['scrollToCommentInput'] ?? false,
            ),
      );
    }

    // AI 상세페이지 라우팅 추가
    if (settings.name == '/ai-detail') {
      final args = settings.arguments as Map<String, dynamic>?;

      return MaterialPageRoute(
        builder:
            (context) => AiDetailPage(
              postId: args?['postId'] ?? '',
              title: args?['title'] ?? '',
              content: args?['content'] ?? '',
              author: args?['author'] ?? '',
              keywords: args?['keywords']?.cast<String>() ?? [],
              date: args?['date'] ?? DateTime.now(),
              scrollToCommentOnLoad: args?['scrollToCommentOnLoad'] ?? false,
            ),
      );
    }

    // 랜덤 상세페이지 라우팅 추가
    if (settings.name == '/random-detail') {
      final args = settings.arguments as Map<String, dynamic>?;

      return MaterialPageRoute(
        builder:
            (context) => RandomDetailPage(
              postId: args?['postId'] ?? '',
              title: args?['title'] ?? '',
              content: args?['content'] ?? '',
              author: args?['author'] ?? '',
              keyword: args?['keyword'] ?? '',
              date: args?['date'] ?? DateTime.now(),
              focusOnComment: args?['focusOnComment'] ?? false,
            ),
      );
    }

    // 그 외 경로는 null 반환 (onUnknownRoute로 처리할 수 있음)
    return null;
  }
}

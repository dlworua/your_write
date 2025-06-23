import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_write/ui/pages/auth/email/check_email_page.dart';
import 'package:your_write/ui/pages/auth/user/user_info_page.dart';

class AuthStateWrapper extends StatelessWidget {
  final Widget loggedInWidget;
  final Widget loggedOutWidget;

  const AuthStateWrapper({
    super.key,
    required this.loggedInWidget,
    required this.loggedOutWidget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          if (!user.emailVerified) {
            // 이메일 인증 안 됐으면 인증 대기 페이지로
            return const CheckEmailPage();
          }
          // 이메일 인증 됐으면 추가 정보 확인 필요
          // Firestore 유저 닉네임 정보 확인 (간단하게 FirebaseAuth displayName 활용 가능)
          if (user.displayName == null || user.displayName!.isEmpty) {
            return const UserInfoPage();
          }
          return loggedInWidget;
        }
        return loggedOutWidget;
      },
    );
  }
}

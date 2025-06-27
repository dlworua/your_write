import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:your_write/data/repository/user_repository.dart';
import 'package:your_write/ui/pages/auth/agreement/agreement_page.dart';
import 'package:your_write/ui/pages/auth/email/check_email_page.dart';
import 'package:your_write/ui/pages/auth/user/user_info_page.dart';

class AuthStateWrapper extends StatefulWidget {
  final Widget loggedInWidget;
  final Widget loggedOutWidget;

  const AuthStateWrapper({
    super.key,
    required this.loggedInWidget,
    required this.loggedOutWidget,
  });

  @override
  State<AuthStateWrapper> createState() => _AuthStateWrapperState();
}

class _AuthStateWrapperState extends State<AuthStateWrapper> {
  final UserRepository _userRepository = UserRepository();

  bool _loading = true;
  Widget? _page;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _page = widget.loggedOutWidget;
        _loading = false;
      });
      return;
    }

    await user.reload();

    if (!user.emailVerified) {
      setState(() {
        _page = const CheckEmailPage();
        _loading = false;
      });
      return;
    }

    // UserRepository 사용해 Firestore에서 사용자 데이터 가져오기
    final userModel = await _userRepository.fetchUser(user.uid);

    if (userModel == null) {
      // 사용자 문서가 없으면 약관 동의 페이지로 이동
      setState(() {
        _page = const AgreementPage();
        _loading = false;
      });
      return;
    }

    if (userModel.nickname.isEmpty) {
      // 닉네임이 비어있으면 추가 정보 입력 페이지로 이동
      setState(() {
        _page = const UserInfoPage();
        _loading = false;
      });
      return;
    }

    // 모든 체크 완료, 로그인 상태 위젯으로 이동
    setState(() {
      _page = widget.loggedInWidget;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _page!;
  }
}

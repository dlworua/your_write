import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {
  Timer? _timer;
  // ignore: unused_field
  bool _isVerified = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _startEmailCheckTimer();
  }

  void _startEmailCheckTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        setState(() {
          _isVerified = true;
        });
        timer.cancel();
        Navigator.of(context).pushReplacementNamed('/user-info');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _resendEmail() async {
    if (_isSending) return;
    setState(() => _isSending = true);
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증 메일을 다시 보냈습니다. 메일함을 확인하세요.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('인증 메일 전송 중 오류가 발생했습니다.')));
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이메일 인증 대기')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, size: 80, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                '회원가입하신 이메일로\n인증 메일이 발송되었습니다.\n메일함을 확인하고 인증을 완료해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSending ? null : _resendEmail,
                child:
                    _isSending
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('인증 메일 다시 보내기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

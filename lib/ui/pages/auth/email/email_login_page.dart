import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (!userCredential.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        setState(() {
          _errorMessage = '이메일 인증이 필요합니다. 메일을 확인하세요.';
        });
        return;
      }

      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
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
        _errorMessage = message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('이메일 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return '이메일을 입력하세요.';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                    return '올바른 이메일을 입력하세요.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return '비밀번호를 입력하세요.';
                  if (value.length < 6) return '비밀번호는 6자 이상이어야 합니다.';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                        : const Text('로그인'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/signup');
                },
                child: const Text('회원가입 하러 가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
  final _nicknameController = TextEditingController();
  bool _isSaving = false;
  final UserRepository _userRepository = UserRepository();

  Future<void> _saveUserInfo() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // FirebaseAuth 프로필 업데이트
        await user.updateDisplayName(nickname);

        // Firestore에 프로필 저장
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          nickname: nickname,
        );
        await _userRepository.saveUser(userModel);

        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('프로필 저장 실패: ${e.toString()}')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('추가 정보 입력')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('사용하실 닉네임을 입력해주세요.', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: '닉네임',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveUserInfo,
              child:
                  _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('저장하고 시작하기'),
            ),
          ],
        ),
      ),
    );
  }
}

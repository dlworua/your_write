import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SignupLink extends StatelessWidget {
  const SignupLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDEB887).withOpacity(0.3)),
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
          const Expanded(
            child: AutoSizeText(
              '아직 계정이 없으신가요?',
              style: TextStyle(color: Color(0xFFA0522D), fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/agreement');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFCD853F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const AutoSizeText(
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
    );
  }
}

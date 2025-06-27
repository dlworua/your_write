import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;

  const PasswordInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(fontSize: 16, color: Color(0xFF8B4513)),
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
          borderSide: const BorderSide(color: Color(0xFFCD853F), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFFFF8F0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '비밀번호를 입력하세요.';
        if (value.length < 6) return '비밀번호는 6자 이상이어야 합니다.';
        return null;
      },
    );
  }
}

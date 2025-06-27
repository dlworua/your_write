import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 16, color: Color(0xFF8B4513)),
      decoration: InputDecoration(
        labelText: '이메일',
        labelStyle: const TextStyle(
          color: Color(0xFFCD853F),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFCD853F)),
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
        if (value == null || value.isEmpty) return '이메일을 입력하세요.';
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return '올바른 이메일을 입력하세요.';
        }
        return null;
      },
    );
  }
}

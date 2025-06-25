import 'package:flutter/material.dart';

class AiPostKeyword extends StatelessWidget {
  final String keyword;

  const AiPostKeyword({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDDBEA9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        keyword,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

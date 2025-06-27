import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE4B5).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.waving_hand_rounded,
            size: 50,
            color: Color(0xFFCD853F),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '만나서 반가워요! 🌻',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B4513),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '따스한 공간으로 어서오세요:)',
          style: TextStyle(fontSize: 16, color: Color(0xFFA0522D), height: 1.3),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class HomePostBottom extends StatelessWidget {
  final List<String> keywords;
  const HomePostBottom({super.key, required this.keywords});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF5F1EB).withOpacity(0.3), Colors.white],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconWithCount(
                Icons.favorite_border_rounded,
                '37',
                const Color(0xFFD2691E),
              ),
              _buildIconWithCount(
                Icons.chat_bubble_outline_rounded,
                '326',
                const Color(0xFF4682B4),
              ),
              _buildIconWithCount(
                Icons.share_outlined,
                '',
                const Color(0xFF8FBC8F),
              ),
              _buildIconWithCount(
                Icons.bookmark_outline_rounded,
                '',
                const Color(0xFFDDA0DD),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithCount(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 6),
          Text(
            count,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D4037),
            ),
          ),
        ],
      ],
    );
  }
}

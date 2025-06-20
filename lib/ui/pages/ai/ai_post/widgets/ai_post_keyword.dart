import 'package:flutter/material.dart';

class AiPostKeyword extends StatelessWidget {
  final String keyword;

  const AiPostKeyword({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE6CCB2).withOpacity(0.7), // 베이지
            Color(0xFFF5F1EB).withOpacity(0.5), // 연한 베이지
            Colors.white.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFDDBEA9).withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '#$keyword',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFFA0522D), // 브라운 톤
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

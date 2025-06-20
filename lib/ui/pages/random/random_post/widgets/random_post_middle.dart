import 'package:flutter/material.dart';

class RandomPostMiddle extends StatelessWidget {
  final String title;
  final String content;

  const RandomPostMiddle({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFFF5F1EB).withOpacity(0.6), // 베이지
            Color(0xFFFAF6F0).withOpacity(0.4), // 크림 베이지
            Color(0xFFF5F1EB).withOpacity(0.3), // 연한 베이지
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF8B4513), // 따뜻한 브라운
                letterSpacing: -0.8,
                height: 1.4,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Color(0xFFFAF6F0).withOpacity(0.4), // 크림
                  Colors.white.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFFDDBEA9).withOpacity(0.3), // 베이지 테두리
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  blurRadius: 15,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5D4037), // 따뜻한 브라운 텍스트
                height: 1.7,
                letterSpacing: 0.3,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

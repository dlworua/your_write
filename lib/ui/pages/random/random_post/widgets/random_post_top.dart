import 'package:flutter/material.dart';
import 'package:your_write/ui/widgets/report/report_popup.dart';

class RandomPostTop extends StatelessWidget {
  final String nickname;
  final String postId;

  const RandomPostTop({
    super.key,
    required this.nickname,
    required this.postId,
  });

  void _onReportPressed(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ReportDialog(boardType: 'random_writes', postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFF5F1EB).withOpacity(0.5), // 베이지 톤
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: Colors.brown.withOpacity(0.1), width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFDDBEA9).withOpacity(0.8), // 따뜻한 베이지
                    Color(0xFFE6CCB2).withOpacity(0.6), // 연한 베이지
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.2),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/app_logo.png', fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nickname,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF8B4513), // 따뜻한 브라운
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '☕ 작가 창작',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA0522D), // 브라운 톤
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () => _onReportPressed(context),
              icon: Icon(
                Icons.report,
                color: Color(0xFFCD853F), // 따뜻한 브라운
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

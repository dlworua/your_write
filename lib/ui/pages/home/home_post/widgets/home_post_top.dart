import 'package:flutter/material.dart';
import 'package:your_write/ui/widgets/report/report_popup.dart';

class HomePostTop extends StatelessWidget {
  final String nickname;
  final String postId;
  const HomePostTop({super.key, required this.nickname, required this.postId});

  void _onReportPressed(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => ReportDialog(boardType: 'home_posts', postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFF5F1EB).withOpacity(0.5)],
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
                gradient: const LinearGradient(
                  colors: [Color(0xFFDDBEA9), Color(0xFFE6CCB2)],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/app_logo.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                nickname,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Color(0xFF8B4513),
                ),
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

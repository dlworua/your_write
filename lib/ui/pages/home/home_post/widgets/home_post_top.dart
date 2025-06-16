import 'package:flutter/material.dart';
import 'package:your_write/ui/widgets/report/report_popup.dart';

class HomePostTop extends StatelessWidget {
  final String nickname;
  // final String imageAssetPath;

  const HomePostTop({
    super.key,
    required this.nickname,
    // this.imageAssetPath = 'assets/app_logo.png',
  });

  void _onReportPressed(BuildContext context) {
    showDialog(context: context, builder: (context) => const ReportDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/app_logo.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            IconButton(
              onPressed: () => _onReportPressed(context),
              icon: const Icon(Icons.flag),
            ),
          ],
        ),
      ),
    );
  }
}

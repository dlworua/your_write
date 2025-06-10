import 'package:flutter/material.dart';
import 'package:your_write/ui/widgets/report/report_popup.dart';

class AiPostTop extends StatelessWidget {
  const AiPostTop({super.key});

  void _onReportPressed(BuildContext context) {
    showDialog(context: context, builder: (context) => const ReportDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/app_logo.png', fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Text('닉네임'),
            Spacer(),
            IconButton(
              onPressed: () => _onReportPressed(context),
              icon: Icon(Icons.flag),
            ),
          ],
        ),
      ),
    );
  }
}
